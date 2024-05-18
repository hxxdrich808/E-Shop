package eshop.servives;

import eshop.models.Product;
import eshop.models.ProductCompatibility;
import eshop.models.enums.ProductType;
import eshop.repositories.ProductCompatibilityRepository;
import eshop.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PcBuilderService {

    private ProductRepository productRepository;
    private ProductCompatibilityRepository productCompatibilityRepository;

    public List<Product> getNeededType(ProductType productType) {
        return productRepository.findByProductType(productType);
    }

    public List<Product> getCompatibleComponents(String productType, Long selectedComponentId) {
        Optional<Product> selectedComponentOpt = productRepository.findById(selectedComponentId);
        if (selectedComponentOpt.isPresent()) {
            Product selectedComponent = selectedComponentOpt.get();
            ProductCompatibility selectedCompatibility = productCompatibilityRepository.findById(selectedComponentId).orElse(null);

            if (selectedCompatibility != null) {
                switch (productType) {
                    case "Motherboard":
                        return getCompatibleMotherboards(selectedCompatibility);
                    case "RAM":
                        return getCompatibleRam(selectedCompatibility);
                    case "GPU":
                        return getCompatibleGpus(selectedCompatibility);
                    case "PSU":
                        return getCompatiblePsus(selectedCompatibility);
                    case "Case":
                        return getCompatibleCases(selectedCompatibility);
                    default:
                        log.warn("Unsupported product type: " + productType);
                        return List.of();
                }
            }
        }
        log.warn("Selected component with ID: " + selectedComponentId + " not found or has no compatibility info.");
        return List.of();
    }

    private List<Product> getCompatibleMotherboards(ProductCompatibility cpuCompatibility) {
        if (cpuCompatibility.getSocket() != null) {
            String requiredSocket = cpuCompatibility.getSocket();
            return getNeededType(ProductType.MOTHERBOARD).stream()
                    .filter(mb -> {
                        ProductCompatibility mbCompatibility = productCompatibilityRepository.findById(mb.getId()).orElse(null);
                        return mbCompatibility != null && requiredSocket.equals(mbCompatibility.getSocket());
                    })
                    .collect(Collectors.toList());
        }
        return List.of();
    }


    private List<Product> getCompatibleRam(ProductCompatibility mbCompatibility) {
        if (mbCompatibility.getDdr() != null) {
            String requiredDdr = mbCompatibility.getDdr();
//            switch (productType){
//                case CPU ->{
//                    return getNeededType(ProductType.RAM).stream()
//                            .filter(ram -> {
//                                ProductCompatibility ramCompatibility = productCompatibilityRepository.findById(ram.getId()).orElse(null);
//                                return ramCompatibility != null && requiredDdr.equals(ramCompatibility.getDdr());
//                            })
//                            .collect(Collectors.toList());
//                }
//            }
            return getNeededType(ProductType.RAM).stream()
                    .filter(ram -> {
                        ProductCompatibility ramCompatibility = productCompatibilityRepository.findById(ram.getId()).orElse(null);
                        return ramCompatibility != null && requiredDdr.equals(ramCompatibility.getDdr());
                    })
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    private List<Product> getCompatibleGpus(ProductCompatibility mbCompatibility) {
        if (mbCompatibility.getGddr() != null) {
            String requiredGddr = mbCompatibility.getGddr();
            return getNeededType(ProductType.GPU).stream()
                    .filter(gpu -> {
                        ProductCompatibility gpuCompatibility = productCompatibilityRepository.findById(gpu.getId()).orElse(null);
                        return gpuCompatibility != null && requiredGddr.equals(gpuCompatibility.getGddr());
                    })
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    private List<Product> getCompatiblePsus(ProductCompatibility mbCompatibility) {
        if (mbCompatibility.getFormat() != null) {
            String requiredFormat = mbCompatibility.getFormat();
            return getNeededType(ProductType.PSU).stream()
                    .filter(psu -> {
                        ProductCompatibility psuCompatibility = productCompatibilityRepository.findById(psu.getId()).orElse(null);
                        return psuCompatibility != null && requiredFormat.equals(psuCompatibility.getFormat());
                    })
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    private List<Product> getCompatibleCases(ProductCompatibility mbCompatibility) {
        if (mbCompatibility.getFormat() != null) {
            String requiredFormat = mbCompatibility.getFormat();
            return getNeededType(ProductType.CASE).stream()
                    .filter(caseProduct -> {
                        ProductCompatibility caseCompatibility = productCompatibilityRepository.findById(caseProduct.getId()).orElse(null);
                        return caseCompatibility != null && requiredFormat.equals(caseCompatibility.getFormat());
                    })
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    private List<Product> getCompatibleDrives(ProductCompatibility mbCompatibility) {
        boolean supportsM2Slot = mbCompatibility.isM2slot();
        return null;
    }

    /*TODO дописать методы для поиска оставшихся комплектующих, попробовать написать универсальный метод поиска комплектующего.
    *  попробовать написать метод свитч кейс формата для получения необходимых переменных в зависимости от типа продукта*/
}
