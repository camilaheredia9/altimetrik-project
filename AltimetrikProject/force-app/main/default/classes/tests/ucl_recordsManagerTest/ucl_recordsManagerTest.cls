@isTest
public class ucl_recordsManagerTest {

    @isTest
    static void testRecordsManagerScenario1() {
        // Escenario con un LA de status Enabled y un cliente 
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"AccountNumber": "123", "AccountName": "Realu", "AccountStatus": "Enabled", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "Carol", "LastName": "Swan", "Email": "carol.swan@example.com", "Phone": "123456789", "Address": "Main 123", "ClientNumber": "C123"}]}');
        
        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        // Verifico si los registros se crearon
        List<Legal_Advisor__c> legalAdvisors = [SELECT Id, Account_Number__c 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '123'];
        System.assertEquals(1, legalAdvisors.size(), 'There should be a Legal Advisor record with Account Number: 123');

        List<Client__c> clients = [SELECT Id, Client_Number__c 
                                   FROM Client__c 
                                   WHERE Client_Number__c = 'C123' AND Legal_Advisor__r.Account_Number__c = '123'];
        System.assertEquals(1, clients.size(), 'There should be a Client record with Client Number: C123 and related to the Legal Advisor: Realu');
    }

    @isTest
    static void testRecordsManagerScenario2() {
        // Escenario con un LA de status Enabled sin clientes
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"AccountNumber": "456", "AccountName": "Juart", "AccountStatus": "Enabled", "AsOfDate": "2023-02-01", "Clients": []}');

        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        List<Legal_Advisor__c> legalAdvisors = [SELECT Id, Account_Number__c 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '456'];
        System.assertEquals(1, legalAdvisors.size(), 'There should be a Legal Advisor record with Account Number: 456');

        List<Client__c> clients = [SELECT Id 
                                   FROM Client__c 
                                   WHERE Legal_Advisor__r.Account_Number__c = '456'];
        System.assertEquals(0, clients.size(), 'There should be no associated Clients to the Legal Advisor: Juart');
    }

    @isTest
    static void testRecordsManagerScenario3() {
        // Escenario con un LA con status Disabled. El LA ya se encuentra en la base de datos con status Enabled.
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"AccountNumber": "123", "AccountName": "Realu", "AccountStatus": "Disabled", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "Carol", "LastName": "Swan", "Email": "carol.swan@example.com", "Phone": "123456789", "Address": "Main 123", "ClientNumber": "C123"}]}');

        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        // Verifico que el registro del LA haya cambiado su status a Disabled.
        List<Legal_Advisor__c> legalAdvisors = [SELECT Id, Account_Status__c
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '123'];
        String newStatus = legalAdvisors[0].Account_Status__c;
        System.assertEquals('Disabled', newStatus, 'The record status should have been updated to: Disabled.');
    }

    @isTest
    static void testRecordsManagerScenario4() {
        // Escenario con un LA con status Disabled. El LA no se encuentra en la base de datos.
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"AccountNumber": "101", "AccountName": "DisabledAccount", "AccountStatus": "Disabled", "AsOfDate": "2023-04-01", "Clients": [{"FirstName": "Johny", "LastName": "Good", "Email": "johny.good@example.com", "Phone": "987654321", "Address": "Village 456", "ClientNumber": "C456"}]}');

        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        // Verifico que no se hayan creado registros LA ni Client para ese LA.
        List<Legal_Advisor__c> legalAdvisors = [SELECT Id 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '101'];
        System.assertEquals(0, legalAdvisors.size(), 'There should not be Legal Advisor records because the account is disabled.');

        List<Client__c> clients = [SELECT Id, Client_Number__c
                                   FROM Client__c
                                   WHERE Client_Number__c = 'C456' AND Legal_Advisor__r.Account_Number__c = '101'];
        System.assertEquals(0, clients.size(), 'There should not be Client records because the Legal Advisor account associated is disabled.');
    }

    @isTest
    static void testRecordsManagerScenario5() {
        // Escenario con varios Legal Advisors y clientes
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('[{"AccountNumber": "789", "AccountName": "Ticsu", "AccountStatus": "Enabled", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "Alice", "LastName": "Wonderland", "Email": "alice@example.com", "Phone": "5551234567", "Address": "Wonderland St", "ClientNumber": "C789"}]}, {"AccountNumber": "890", "AccountName": "Dream", "AccountStatus": "Enabled", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "Bob", "LastName": "Dreamer", "Email": "bob@example.com", "Phone": "5559876543", "Address": "Dreamland Ave", "ClientNumber": "C890"}]}]');
        
        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        List<Legal_Advisor__c> legalAdvisors1 = [SELECT Id, Account_Number__c 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '789' OR Account_Number__c = '890'];
        System.assertEquals(2, legalAdvisors1.size(), 'There should be 2 Legal Advisor records.');

        List<Client__c> client1 = [SELECT Id, Client_Number__c 
                                    FROM Client__c 
                                    WHERE Client_Number__c = 'C789' AND Legal_Advisor__r.Account_Number__c = '789'];
        System.assertEquals(1, client1.size(), 'There should be a Client record with Client Number: C789 and related to the Legal Advisor: Ticsu');

        List<Client__c> client2 = [SELECT Id, Client_Number__c 
                                    FROM Client__c 
                                    WHERE Client_Number__c = 'C890' AND Legal_Advisor__r.Account_Number__c = '890'];
        System.assertEquals(1, client2.size(), 'There should be a Client record with Client Number: C890 and related to the Legal Advisor: Dream');
    }
    
    @isTest
    static void testRecordsManagerScenario6() {
        // Escenario para probar el método deleteRecords
        List <Legal_Advisor__c> legalAdvisors = new List <Legal_Advisor__c>();
        List <Client__c> clients = new List <Client__c>();

        Legal_Advisor__c la1 = new Legal_Advisor__c(
            Account_Number__c = '333',
            Account_Name__c = 'AccountOne',
            Account_Status__c = 'Enabled'
        );
        legalAdvisors.add(la1);

        Legal_Advisor__c la2 = new Legal_Advisor__c(
            Account_Number__c = '444',
            Account_Name__c = 'AccountTwo',
            Account_Status__c = 'Enabled'
        );
        legalAdvisors.add(la2);
        insert(legalAdvisors);

        Client__c cl1 = new Client__c(
            First_Name__c = 'Alice',
            Last_Name__c = 'One',
            Email__c = 'alice.one@example.com',
            Phone__c = '1112223333',
            Address__c = 'Street One',
            Client_Number__c = 'C3331',
            Legal_Advisor__c = la1.Id
        );
        clients.add(cl1);

        Client__c cl2 = new Client__c(
            First_Name__c = 'Charlie',
            Last_Name__c = 'Two',
            Email__c = 'charlie.two@example.com',
            Phone__c = '2223334444',
            Address__c = 'Street Two',
            Client_Number__c = 'C4441',
            Legal_Advisor__c = la2.Id
        );
        clients.add(cl2);
        insert clients;

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('[{"AccountNumber": "444", "AccountName": "AccountTwo", "AccountStatus": "Enabled", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "Charlie", "LastName": "Two", "Email": "charlie.two@example.com", "Phone": "2223334444", "Address": "Street Two", "ClientNumber": "C4441"}]}]');

        Test.startTest();
        ucl_recordsManager.recordsManager(mockResponse);
        Test.stopTest();

        // En la mockResponse no están ni el Legal Advisor la1 ni el Client cl1. Verifico que se hayan borrado.
        List<Legal_Advisor__c> legalAdvisors1 = [SELECT Id, Account_Number__c 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '333'];
        System.assertEquals(0, legalAdvisors1.size(), 'The Legal Advisor record should have been deleted');

        List<Client__c> client1 = [SELECT Id, Client_Number__c 
                                    FROM Client__c 
                                    WHERE Client_Number__c = 'C3331' AND Legal_Advisor__r.Account_Number__c = '333'];
        System.assertEquals(0, client1.size(), 'The Client record should have been deleted');

        // Verifico que el otro LA y cliente que siguen en el mock, sigan en la base de datos
        List<Legal_Advisor__c> legalAdvisors2 = [SELECT Id, Account_Number__c 
                                                FROM Legal_Advisor__c 
                                                WHERE Account_Number__c = '444'];
        System.assertEquals(1, legalAdvisors2.size(), 'There should be 1 Legal Advisor record with the Account Number: 444');

        List<Client__c> client2 = [SELECT Id, Client_Number__c 
                                    FROM Client__c 
                                    WHERE Client_Number__c = 'C4441' AND Legal_Advisor__r.Account_Number__c = '444'];
        System.assertEquals(1, client2.size(), 'There should be 1 Client with Client Number: C4441 and associated with the Legal Advisor 444');
    }
}