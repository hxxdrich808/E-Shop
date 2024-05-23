package eshop.servives;

import eshop.models.Build;
import eshop.models.Product;
import eshop.models.ProductCompatibility;
import eshop.models.enums.ProductType;
import eshop.repositories.BuildRepository;
import eshop.repositories.ProductCompatibilityRepository;
import eshop.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PcBuilderService {
    private final BuildRepository buildRepository;
    private final ProductRepository productRepository;
    private final ProductCompatibilityRepository productCompatibilityRepository;

    public List<Product> getNeededType(ProductType productType) {
        return productRepository.findByProductType(productType);
    }

    private String cpuSocket;
    private String ddr;
    private String gddr;
    private String format;
    private boolean m2Slot;

    public List<Product> getCompatibleProduct(ProductType productType) {
        switch (productType) {
            case CPU -> {
                List<Product> cpus = getNeededType(ProductType.CPU);
                if (!cpus.isEmpty()) {
                    Product selectedCpu = cpus.get(0);
                    ProductCompatibility cpuCompatibility = productCompatibilityRepository.findById(selectedCpu.getId()).orElse(null);
                    if (cpuCompatibility != null) {
                        cpuSocket = cpuCompatibility.getSocket();
                    }
                }
                return cpus;
            }
            case MOTHERBOARD -> {
                if (cpuSocket != null) {
                    List<Product> motherboards = getNeededType(ProductType.MOTHERBOARD).stream()
                            .filter(product -> {
                                ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                                return neededCompatibility != null && cpuSocket.equals(neededCompatibility.getSocket());
                            })
                            .collect(Collectors.toList());

                    if (!motherboards.isEmpty()) {
                        ProductCompatibility motherboardCompatibility = productCompatibilityRepository.findById(motherboards.get(0).getId()).orElse(null);
                        if (motherboardCompatibility != null) {
                            gddr = motherboardCompatibility.getGddr();
                            ddr = motherboardCompatibility.getDdr();
                            format = motherboardCompatibility.getFormat();
                            m2Slot = motherboardCompatibility.isM2slot();
                        }
                    }
                    return motherboards;
                }
            }
            case RAM -> {
                if (ddr != null) {
                    return getNeededType(ProductType.RAM).stream()
                            .filter(product -> {
                                ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                                return neededCompatibility != null && ddr.equals(neededCompatibility.getDdr());
                            })
                            .collect(Collectors.toList());
                }
            }
            case GPU -> {
                if (gddr != null) {
                    return getNeededType(ProductType.GPU).stream()
                            .filter(product -> {
                                ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                                return neededCompatibility != null && gddr.equals(neededCompatibility.getGddr());
                            })
                            .collect(Collectors.toList());
                }
            }
            case PSU -> {
                if (format != null) {
                    return getNeededType(ProductType.PSU).stream()
                            .filter(product -> {
                                ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                                return neededCompatibility != null && format.equals(neededCompatibility.getFormat());
                            })
                            .collect(Collectors.toList());
                }
            }
            case CASE -> {
                if (format != null) {
                    return getNeededType(ProductType.CASE).stream()
                            .filter(product -> {
                                ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                                return neededCompatibility != null && format.equals(neededCompatibility.getFormat());
                            })
                            .collect(Collectors.toList());
                }
            }
            case COOLER -> {
                return getNeededType(ProductType.COOLER);
            }
            case DRIVE -> {
                return getNeededType(ProductType.DRIVE).stream()
                        .filter(product -> {
                            ProductCompatibility neededCompatibility = productCompatibilityRepository.findById(product.getId()).orElse(null);
                            if (neededCompatibility == null) {
                                return false;
                            }
                            return m2Slot || !neededCompatibility.isM2slot();
                        })
                        .collect(Collectors.toList());
            }
        }
        return List.of();
    }

    public void addToBuild(String productId, ProductType productType, Build build) {
        Product product = productRepository.findById(Long.valueOf(productId)).orElse(null);
        if (product != null) {

            switch (productType) {
                case CPU:
                    build.setCpu(product.getTitle());
                    break;
                case MOTHERBOARD:
                    build.setMotherboard(product.getTitle());
                    break;
                case RAM:
                    build.setRam(product.getTitle());
                    break;
                case GPU:
                    build.setGpu(product.getTitle());
                    break;
                case PSU:
                    build.setPsu(product.getTitle());
                    break;
                case CASE:
                    build.setSystemUnit(product.getTitle());
                    break;
                case COOLER:
                    build.setCooler(product.getTitle());
                    break;
                case DRIVE:
                    build.setDrive(product.getTitle());
                    break;
                default:
                    log.warn("Unsupported product type: {}", productType);
                    break;
            }
            log.info("Добавлен продукт в сборку: {}", product.getTitle());
        } else {
            log.warn("Продукт с идентификатором {} не найден", productId);
        }
    }

    public void saveBuild(Build build) {
        buildRepository.save(build);
        PdfService.saveBuildToPdf(build);
    }
}
