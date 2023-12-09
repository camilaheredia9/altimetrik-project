public with sharing class ucl_scheduleGetCallout {
    public String scheduleGetCallout() {
        String cronExp = '0 0 20 * * ? *';

        ucl_getCallout calloutJob = new ucl_getCallout();
        
        String jobID = System.schedule('Run Get Callout', cronExp, calloutJob);

        return jobID;
    }
}