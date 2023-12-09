@isTest
private class ucl_clientsControllerTest {
    @isTest
    static void testGetClients() {
        // Crear datos de prueba
        Legal_Advisor__c legalAdvisor = new Legal_Advisor__c(Account_Name__c = 'Legal Advisor Test',
                                                    Account_Number__c = '123abc');
        insert legalAdvisor;

        List <Client__c> clientsList = new List <Client__c>();
        for (Integer i=0; i < 5; i++){
            Client__c client = new Client__c(Legal_Advisor__c = legalAdvisor.Id);
            clientsList.add(client);
        }
        insert clientsList;

        Test.startTest();
        List<AggregateResult> result = ucl_clientsController.getClients();
        Test.stopTest();

        // Verificar que el resultado no sea nulo y que tenga los valores esperados
        System.assertNotEquals(null, result, 'The list of results should not be zero.');

        for (AggregateResult aggResult : result) {
            if ( (String.valueof(aggResult.get('Legal_Advisor__r.Account_Name__c')) == 'Legal Advisor Test') && (String.valueof(aggResult.get('Legal_Advisor__r.Account_Number__c')) == '123abc')){
                Integer count = Integer.valueOf(aggResult.get('expr0'));
                System.assertEquals(5, count, 'Incorrect customer count. It should be: 5.');
            }
        }
    }
}