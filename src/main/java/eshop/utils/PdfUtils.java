package eshop.utils;

import eshop.exceptions.ConvertationException;
import eshop.exceptions.PdfSaveException;
import eshop.models.Build;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;


import java.io.IOException;

@Slf4j
public class PdfUtils {

    public static Long saveBuildToPdf(Build build) {
        PDDocument document = new PDDocument();
        PDPage page = new PDPage();
        document.addPage(page);

        try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
            contentStream.beginText();
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
            contentStream.setLeading(14.5f);
            contentStream.newLineAtOffset(25, 700);

            contentStream.showText("PC Build Details:");
            contentStream.newLine();

            if (build.getCpu() != null) {
                contentStream.showText("CPU: " + build.getCpu());
                contentStream.newLine();
            }
            if (build.getMotherboard() != null) {
                contentStream.showText("Motherboard: " + build.getMotherboard());
                contentStream.newLine();
            }
            if (build.getRam() != null) {
                contentStream.showText("RAM: " + build.getRam());
                contentStream.newLine();
            }
            if (build.getGpu() != null) {
                contentStream.showText("GPU: " + build.getGpu());
                contentStream.newLine();
            }
            if (build.getPsu() != null) {
                contentStream.showText("PSU: " + build.getPsu());
                contentStream.newLine();
            }
            if (build.getSystemUnit() != null) {
                contentStream.showText("Case: " + build.getSystemUnit());
                contentStream.newLine();
            }
            if (build.getCooler() != null) {
                contentStream.showText("Cooler: " + build.getCooler());
                contentStream.newLine();
            }
            if (build.getDrive() != null) {
                contentStream.showText("Drive: " + build.getDrive());
                contentStream.newLine();
            }

            contentStream.endText();
        } catch (IOException e) {
            log.error("Error while trying to parse build: {}", e.getMessage(), e);
            throw new ConvertationException("Error while trying to parse build");
        }

        try {
            document.save(build.getId() + "build.pdf");
            document.close();
            return build.getId();
        } catch (IOException e) {
            log.error("Error while trying to save build in PDF: {}", e.getMessage(), e);
            throw new PdfSaveException("Error while trying to save build in PDF");
        }
    }
}

