@isTest
private class ucl_getCalloutOnDemandTest {
    @isTest
    static void getCalloutOnDemandTest() {
        Test.setMock(HttpCalloutMock.class, new ucl_getCalloutOnDemandMock());

        Test.startTest();
        Integer responseStatusCode = ucl_getCalloutOnDemand.getCalloutOnDemand();
        Test.stopTest();

        System.assertEquals(200, responseStatusCode, 'Status Code is not equal to 200.');

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