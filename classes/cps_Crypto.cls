public with sharing class cps_Crypto {

	// Class for enctypting/decrypting info

	public static String encryptString(String stringToEncrypt){
            Playground_Setting__mdt settings = [SELECT Crypto_Key__c
                                                    FROM Playground_Setting__mdt
                                                    WHERE DeveloperName =: cps_Helper.SETTINGS_NAME];
            String Base64EncryptionKey = settings.Crypto_Key__c;
            Blob cryptoKey = EncodingUtil.base64Decode(Base64EncryptionKey);
            Blob data = Blob.valueOf(stringToEncrypt);

            Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
            String encryptedDataString = EncodingUtil.base64Encode(encryptedData);
            System.debug(encryptedDataString);

            return encryptedDataString;
    }

    public static String decryptString(String stringToDecrypt){
            Playground_Setting__mdt settings = [SELECT Crypto_Key__c
                                                    FROM Playground_Setting__mdt
                                                    WHERE DeveloperName =: cps_Helper.SETTINGS_NAME];
            String Base64EncryptionKey = settings.Crypto_Key__c;
            Blob cryptoKey = EncodingUtil.base64Decode(Base64EncryptionKey);

            Blob stringBlob = EncodingUtil.base64Decode(stringToDecrypt);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, stringBlob);
            String decryptedDataString = decryptedData.toString();
            System.debug(decryptedDataString);

            return decryptedDataString;
    }

}