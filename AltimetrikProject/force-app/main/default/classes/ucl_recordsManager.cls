public with sharing class ucl_recordsManager {
    public static void recordsManager(HttpResponse response) {
        List<Object> legalAdvisorsList = (List <Object>) JSON.deserializeUntyped(response.getBody());

        List <Legal_Advisor__c> legalAdvisorsToUpsert = new List <Legal_Advisor__c>();
        List <Client__c> clientsToUpsert = new List <Client__c>();
        List <Error__c> errorsToInsert = new List <Error__c>();

        List <String> legalAdvisorsIncoming = new List <String>(); /** */

        try{
            for(Object legalAdvisor : legalAdvisorsList){
                Map<String, Object> legalAdvisorData = (Map<String, Object>) legalAdvisor;

                String legalAdvisorIncoming = String.valueOf(legalAdvisorData.get('AccountNumber'));
                legalAdvisorsIncoming.add(legalAdvisorIncoming); /** */

                if(legalAdvisorData.get('AccountStatus') == 'Enabled'){
                    Legal_Advisor__c la = new Legal_Advisor__c(
                        Account_Number__c =  String.valueof(legalAdvisorData.get('AccountNumber')),
                        Account_Name__c = String.valueof(legalAdvisorData.get('AccountName')),
                        Account_Status__c = String.valueof(legalAdvisorData.get('AccountStatus')),
                        As_of_Date__c = Date.valueOf((String) legalAdvisorData.get('AsOfDate'))
                    );
                    legalAdvisorsToUpsert.add(la);

                }else if(legalAdvisorData.get('AccountStatus') == 'Disabled'){
                    List <Legal_Advisor__c> queriedLegalAdvisor = [SELECT Account_Status__c, Account_Number__c 
                                                                   FROM Legal_Advisor__c
                                                                   WHERE Account_Number__c = :legalAdvisorIncoming 
                                                                   AND Account_Status__c = 'Enabled' 
                                                                   LIMIT 1]; 

                    if(! queriedLegalAdvisor.isEmpty()){ 
                        queriedLegalAdvisor[0].Account_Status__c = 'Disabled';
                        legalAdvisorsToUpsert.add(queriedLegalAdvisor[0]);
                    }
                }
            }
            upsert legalAdvisorsToUpsert Account_Number__c;
            
            // Obtengo los Legal Advisors upserteados -> ahora ya tienen Id
            List <Legal_Advisor__c> legalAdvisorsUpserted = [SELECT Id, Account_Number__c
                                                             FROM Legal_Advisor__c
                                                             WHERE Account_Number__c IN: legalAdvisorsIncoming];
            
            // Creo lista de clientes relacionados a sus Legal Advisors correspondientes
            for (Object legalAdvisor : legalAdvisorsList){
                Map<String, Object> legalAdvisorData = (Map<String, Object>) legalAdvisor;

                List <Object> clientsList = (List<Object>) legalAdvisorData.get('Clients');
                if (clientsList.size() > 0) {
                    String laIncomingAcctNumber = String.valueOf(legalAdvisorData.get('Account_Number__c'));

                    for (Legal_Advisor__c laUpserted : legalAdvisorsUpserted){
                        String laUpsertedAcctNumber = laUpserted.Account_Number__c;
                    
                        if(laIncomingAcctNumber == laUpsertedAcctNumber){
                            for (Object client : clientsList){
                                Map<String, Object> clientData = (Map<String, Object>) client;

                                Client__C cl = new Client__C(
                                    First_Name__c = String.valueof(clientData.get('FirstName')),
                                    Last_Name__c = String.valueof(clientData.get('LastName')),
                                    Email__c = String.valueof(clientData.get('Email')),
                                    Phone__c = String.valueof(clientData.get('Phone')),
                                    Address__c = String.valueof(clientData.get('Address')),
                                    Client_Number__c = String.valueof(clientData.get('ClientNumber')),
                                    Legal_Advisor__c = laUpserted.Id
                                );
                    
                                clientsToUpsert.add(cl);
                            }
                        }
                    }
                }
            }
            deleteClients(clientsToUpsert);
            upsert clientsToUpsert Client_Number__c;
        }catch(Exception e){
            String messageError = e.getMessage();
            Error__c errorRecord = new Error__c();
            errorRecord.Name = 'Error';
            errorRecord.Error_Created_Date__c = System.today();
            errorRecord.Error_Message__c = messageError;

            errorsToInsert.add(errorRecord);
        }
        insert errorsToInsert;
    }

    private static void deleteClients(List<Client__c> clientsToUpsert) {
        List<String> clientNumbersInJSON = new List<String>();
        for (Client__c client : clientsToUpsert) {
            clientNumbersInJSON.add(client.Client_Number__c);
        }

        List<Client__c> clientsToDelete = [SELECT Id 
                                           FROM Client__c 
                                           WHERE Client_Number__c NOT IN :clientNumbersInJSON
                                           AND Created_by_Administrator__c = false];
        delete clientsToDelete;
    }
}