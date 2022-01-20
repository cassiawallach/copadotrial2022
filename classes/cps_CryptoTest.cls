@isTest
private class cps_CryptoTest {
	@isTest static void test_encrypt_decrypt() {
        String phrase = 'Test string for crypto test';
        String encryptedPhrase = cps_Crypto.encryptString(phrase);
        System.assertNotEquals(phrase, encryptedPhrase);

        // Base64 string length is always a multiple of 4, so we check if the remainder of division is 0
		System.assertEquals(Math.mod(encryptedPhrase.length(), 4), 0);
        
        String decryptedPhrase = cps_Crypto.decryptString(encryptedPhrase);
        System.assertEquals(phrase, decryptedPhrase);
        
        // Checking if an empty string can be encrypted
        phrase = '';
        encryptedPhrase = cps_Crypto.encryptString(phrase);
        System.assertNotEquals('', encryptedPhrase);
	}
}