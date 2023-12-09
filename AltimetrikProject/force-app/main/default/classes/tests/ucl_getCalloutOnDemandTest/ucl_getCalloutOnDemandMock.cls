@isTest
public class ucl_getCalloutOnDemandMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"AccountNumber":"854","AccountName":"Centidel","AccountStatus":"Enabled","AsOfDate":"2/13/2019","Clients":[{"FirstName":"Foster","LastName":"Burn","Email":"fburn@example.com","Phone":"425-154-5410","Address":"High 49018","ClientNumber":"854C1"},{"FirstName":"Minetta","LastName":"Pol","Email":"mpol1@example.com","Phone":"704-528-1659","Address":"Street 21","ClientNumber":"854C2"}]}]');
        response.setStatusCode(200);
        return response;
    }
}