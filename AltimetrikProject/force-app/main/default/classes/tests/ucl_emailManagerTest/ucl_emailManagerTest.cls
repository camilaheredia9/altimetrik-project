@isTest
private class ucl_emailManagerTest {
    @isTest
    static void testSendMail() {
        String toAddress = 'test@example.com';
        String subject = 'Test Subject';
        String body = 'Test Body';

        Test.startTest();
        // Deshabilitar el envío real de 1 correo electrónico durante la prueba
        Messaging.reserveSingleEmailCapacity(1);
        ucl_emailManager.sendMail(toAddress, subject, body);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        // Verificar que se envió 1 correo electrónico

        System.assertEquals(1, invocations, 'An email should be sent');
    }
}
