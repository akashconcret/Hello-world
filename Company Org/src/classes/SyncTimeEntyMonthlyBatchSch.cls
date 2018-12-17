global with sharing class SyncTimeEntyMonthlyBatchSch implements Schedulable{
    global void execute(SchedulableContext sc){ 
        SyncTimeEntyMonthlyBatchJob createTimeEntry = new SyncTimeEntyMonthlyBatchJob(); 
        database.executebatch(createTimeEntry, 1);
    } 
}