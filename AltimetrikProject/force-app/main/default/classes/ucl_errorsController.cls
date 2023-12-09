public with sharing class ucl_errorsController {
    @AuraEnabled(cacheable=true)

    public static List<Error__c> getErrors() {
        return [SELECT Id, Error_Message__c 
                FROM Error__c];
    }
}