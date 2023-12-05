@isTest
private class ucl_errorsControllerTest {
    @isTest
    static void testGetErrors() {
        // Contar cuántos registros Error__c existen antes de la prueba
        List<Error__c> errorsBeforeTest = [SELECT Id
                                           FROM Error__c];

        // Crear algunos registros de Error__c 
        List<Error__c> errorRecords = new List<Error__c>();

        for (Integer i = 0; i < 3; i++) {
            Error__c errorRecord = new Error__c(Error_Message__c = 'Error Message ' + i);
            errorRecords.add(errorRecord);
        }
        insert errorRecords;

        Test.startTest();
        List<Error__c> result = ucl_errorsController.getErrors();
        Test.stopTest();

        // Verificar que los registros devueltos sumen los existentes previamente más los creados para la prueba
        System.assertEquals(errorsBeforeTest.size() + 3, result.size(), 'The number of records returned is not correct.');
    }
}