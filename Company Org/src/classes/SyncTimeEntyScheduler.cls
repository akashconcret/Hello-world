global with sharing class SyncTimeEntyScheduler implements Schedulable{
    global void execute(SchedulableContext sc){ 
        SyncTimeEntyBatchJob createTimeEntry = new SyncTimeEntyBatchJob(); 
        database.executebatch(createTimeEntry, 10);
    } 
}