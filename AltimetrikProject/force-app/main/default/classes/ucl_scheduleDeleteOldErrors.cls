public with sharing class ucl_scheduleDeleteOldErrors {
    public String scheduleDeleteOldErrors() {
        String cronExp = '0 0 0 * * ?';

        ucl_deleteOldErrors deleteJob = new ucl_deleteOldErrors();
        
        String jobId = System.schedule('Delete Errors', cronExp, deleteJob);

        return jobId;
    }
}