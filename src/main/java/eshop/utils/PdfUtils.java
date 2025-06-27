package eshop.utils;

import eshop.exceptions.PdfSaveException;
import eshop.models.Build;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

import java.io.IOException;
import java.io.InputStream;
import java.util.Objects;

@Slf4j
public class PdfUtils {

    public static Long saveBuildToPdf(Build build) {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            // Загружаем шрифт из resources/fonts/DejaVuSans.ttf
            InputStream fontStream = PdfUtils.class.getResourceAsStream("/fonts/DejaVuSans.ttf");
            if (fontStream == null) {
                throw new IOException("Шрифт не найден: /fonts/DejaVuSans.ttf");
            }
            PDType0Font font = PDType0Font.load(document, fontStream, true);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.beginText();
                contentStream.setFont(font, 12);
                contentStream.setLeading(14.5f);
                contentStream.newLineAtOffset(25, 700);

                contentStream.showText("Сборка ПК:");
                contentStream.newLine();

                if (build.getCpu() != null) {
                    contentStream.showText("Процессор: " + build.getCpu());
                    contentStream.newLine();
                }
                if (build.getMotherboard() != null) {
                    contentStream.showText("Материнская плата: " + build.getMotherboard());
                    contentStream.newLine();
                }
                if (build.getRam() != null) {
                    contentStream.showText("Оперативная память: " + build.getRam());
                    contentStream.newLine();
                }
                if (build.getGpu() != null) {
                    contentStream.showText("Видеокарта: " + build.getGpu());
                    contentStream.newLine();
                }
                if (build.getPsu() != null) {
                    contentStream.showText("Блок питания: " + build.getPsu());
                    contentStream.newLine();
                }
                if (build.getSystemUnit() != null) {
                    contentStream.showText("Корпус: " + build.getSystemUnit());
                    contentStream.newLine();
                }
                if (build.getCooler() != null) {
                    contentStream.showText("Кулер: " + build.getCooler());
                    contentStream.newLine();
                }
                if (build.getDrive() != null) {
                    contentStream.showText("Накопитель: " + build.getDrive());
                    contentStream.newLine();
                }

                contentStream.endText();
            }

            String fileName = build.getId() + "_build.pdf";
            document.save(fileName);
            return build.getId();

        } catch (IOException e) {
            log.error("Ошибка при создании PDF: {}", e.getMessage(), e);
            throw new PdfSaveException("Не удалось сохранить PDF: " + e.getMessage());
        }
    }
}
