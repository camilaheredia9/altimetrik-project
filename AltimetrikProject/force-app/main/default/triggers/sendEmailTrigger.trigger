trigger sendEmailTrigger on Error__c (after insert) {

    List <Error__c> errorsList = [SELECT Id, Error_Message__c
                                FROM Error__c 
                                WHERE Id IN :Trigger.new];

    for (Error__c err : errorsList) {
        ucl_emailManager.sendMail(UserInfo.getUserEmail(), 
                             'An error has ocurred during the Integration Service', 
                              err.Error_Message__c);
    }
}