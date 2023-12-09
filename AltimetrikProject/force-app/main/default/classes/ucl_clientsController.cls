public with sharing class ucl_clientsController {
    @AuraEnabled(cacheable=true)

    public static List<AggregateResult> getClients() {
        return [SELECT Legal_Advisor__r.Account_Number__c, Legal_Advisor__r.Account_Name__c, 
                COUNT(Id) 
                FROM Client__c
                GROUP BY Legal_Advisor__r.Account_Number__c, Legal_Advisor__r.Account_Name__c];
    }
}