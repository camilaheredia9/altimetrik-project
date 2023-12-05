public with sharing class ucl_deleteOldErrors implements Schedulable{
    public void execute (SchedulableContext sc) {
        Date oneMonthAgo = System.today().addMonths(-1);

        List<Error__c> oldErrorRecords = [SELECT Id FROM Error__c 
                                        WHERE Error_Created_Date__c < :oneMonthAgo];

        delete oldErrorRecords;
    }
}