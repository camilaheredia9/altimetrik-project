@isTest
private class ucl_deleteOldErrorsTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    @isTest
    static void testDeleteOldErrors() {
        // Crear registros de Error__c más antiguos que un mes
        Date olderThanOneMonth = System.today().addMonths(-2);
        List<Error__c> errorRecordsToDelete = new List<Error__c>();

        for (Integer i = 0; i < 5; i++) {
            Error__c errorRecord = new Error__c(Error_Created_Date__c = olderThanOneMonth);
            errorRecordsToDelete.add(errorRecord);
        }
        insert errorRecordsToDelete;

        Map<Id, Error__c> errorsMap = new Map<Id, Error__c>(errorRecordsToDelete);
        List<Id> errorIds = new List<Id>(errorsMap.keySet());

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ucl_deleteOldErrors());
        Test.stopTest();

        // Verificar que los registros se hayan eliminado
        List<Error__c> remainingErrorRecords = [SELECT Id 
                                                FROM Error__c
                                                WHERE Id IN :errorIds];
        System.assertEquals(0, remainingErrorRecords.size(), 'Old records were not deleted correctly');
    }
}