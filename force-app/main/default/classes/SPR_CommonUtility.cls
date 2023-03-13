public with sharing class SPR_CommonUtility 
{
    /*
    public static String generateRandomNumber(Integer len) 
    {
        final String chars = '0123456789';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    */

    public static String generateRandomString(Integer len) 
    {
        final String chars = '123456789ABCDEFGIJKLMNOPQRSTUVWXYZ123456789';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}