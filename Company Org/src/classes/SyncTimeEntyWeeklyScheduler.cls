global with sharing class SyncTimeEntyWeeklyScheduler implements Schedulable{
    global void execute(SchedulableContext sc){ 
        SyncTimeEntyWeeklyBatchJob syncTimeEntyWeekly = new SyncTimeEntyWeeklyBatchJob(); 
        database.executebatch(syncTimeEntyWeekly, 1);
    } 
}