public with sharing class ucl_getCalloutOnDemand {
    @AuraEnabled(cacheable=true)
    public static Integer getCalloutOnDemand() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            ucl_recordsManager.recordsManager(response);
        }

        Integer statusCode = response.getStatusCode();
        return statusCode;
    }
}