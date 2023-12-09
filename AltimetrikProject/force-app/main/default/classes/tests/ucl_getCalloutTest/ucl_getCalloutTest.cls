@isTest
private class ucl_getCalloutTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    @isTest
    static void getCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new ucl_getCalloutMock());

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ucl_getCallout());
        Test.stopTest();
        
        // Verifico la creación de registros
        List<Legal_Advisor__c> legalAdvisors = [SELECT Id 
                                                FROM Legal_Advisor__c
                                                WHERE Account_Number__c = '854'];
        System.assertEquals(1, legalAdvisors.size(), 'There should be 1 Legal Advisor record with Account Number 854');
        
        List<Client__C> clients = [SELECT Id 
                                   FROM Client__c
                                   WHERE Client_Number__c = '854C1'
                                   OR Client_Number__c = '854C2'];
        System.assertEquals(2, clients.size(), 'There should be 2 Clients with those Client Numbers');
    
        delete legalAdvisors;
        delete clients;
    }
}