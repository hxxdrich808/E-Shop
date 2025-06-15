package eshop.utils;

import com.ibm.icu.text.Transliterator;

public class FileUtils {

    private static final Transliterator TO_LATIN = Transliterator.getInstance("Cyrillic-Latin");

    public static String cleanFileName(String originalFileName) {
        String filenameAfterReplacement = originalFileName.replaceAll("—", "-");
        return TO_LATIN.transliterate(filenameAfterReplacement);
    }

}
