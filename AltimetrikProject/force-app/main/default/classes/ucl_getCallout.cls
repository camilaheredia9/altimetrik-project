public with sharing class ucl_getCallout implements Schedulable {
    public void execute (SchedulableContext sc) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            ucl_recordsManager.recordsManager(response);
        }
    }
}