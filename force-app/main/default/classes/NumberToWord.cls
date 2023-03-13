/**
 * @description       : Any Currency number to Word conversion
 * @author            : K SANSI
 * @group             :
 * @last modified on  : 08-08-2022
 * @last modified by  : K SANSI
 * Modifications Log
 * Ver   Date         Author           Modification
 * 1.0   08-08-2022   K SANSI   Initial Version 
 **/
public with sharing class NumberToWord {
    static String[] to_19 = new string[] { '', 'one',  'two', 'three', 'four',  'five',  'six',
                                           'seven', 'eight', 'nine', 'ten',  'eleven', 'twelve', 'thirteen',
                                           'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' };
    static String[] tens = new string[] {'', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};
    static String[] denom = new string[] { 'hundred',
                                           'thousand',   'million',     'billion',    'trillion',    'quadrillion',
                                           'quintillion', 's!xtillion',   'septillion',  'octillion',   'nonillion',
                                           'decillion',  'undecillion',   'duodecillion', 'tredecillion',  'quattuordecillion',
                                           's!xdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' };

    @InvocableMethod(label = 'Number to Word' category = 'Translation')
    public static List<String> english_number(List<Decimal> decimalNumber) {
        List<String> numberStrings = new List<String>();
        for (Decimal n : decimalNumber) {
            numberStrings.add(english_number(n));
        }
        return numberStrings;
    }

    public static String english_number(Decimal val) {
        return english_number(String.valueOf(val)).trim();
    }

    public static String english_number(String valAsString) {
        if(String.isEmpty(valAsString)) {return '';}
        List<String> dollarsCents = valAsString.split('\\.');
        String dollars = dollarsCents[0];
        String finalWord = '';
        Integer count = 0;

        if (dollars.length() < 3) {
            finalWord = digitsToWord(dollars);
        } else {
            System.debug('C: ' + count);
            while (dollars.length() > 0) {
                System.debug('C: ' + count);
                String threeDigits = dollars.right(3);
                if(Decimal.valueOf(threeDigits) > 0) {
                    finalWord = digitsToWord(dollars.right(3)) + (count > 0 ? denom[count] + ', ': '')  + finalWord;
                }
                dollars = dollars.left(dollars.length() - 3);
                System.debug(dollars);
                count++;
            }
        }

        finalWord = finalWord.removeEnd(', ').trim() + ' dollars';
        if(dollarsCents.size() == 2) {
            String centWord = digitsToWord(dollarsCents[1]).trim();
            if(String.isNotEmpty(centWord)) {
                finalWord = finalWord + ' and ' + centWord + ' cents';
            }
        }
        return finalWord;
    }

    public static String digitsToWord(String valAsString) {
        System.debug(valAsString);
        Integer hunderds = 0;
        Integer tenplace = 0;
        Integer ones = 0;

        if(valAsString.length() == 3) {
            hunderds = Integer.valueOf(valAsString.left(1));
        }
        if(valAsString.length() >= 2) {
            tenplace = Integer.valueOf(valAsString.right(2).left(1));
        }

        ones = Integer.valueOf(valAsString.right(1));

        String finalWord = '';
        if(hunderds > 0) {
            finalWord = to_19[hunderds] + ' hundred ';
        }

        if(tenplace == 1) {
            finalWord = finalWord + to_19[10 + ones] + ' ';
            ones = 0;
        } else if(tenplace > 1) {
            finalWord = finalWord + tens[tenplace] + ' ';
        }

        if(ones > 0) {
            finalWord = finalWord + to_19[ones] + ' ';
        }

        return finalWord;
    }
}