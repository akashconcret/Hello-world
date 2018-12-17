public class TeamWorkSetUp{
    
    public TeamWorkSetUp(){
        
    }
    public void fetchPeople(){
        GetConcretiansCls.processPeople();
        apexpages.getmessages().clear();
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Concretions is being fetched successfully.'));
    }
    public void fetchTimeEntries(){
        ID batchId = Database.executeBatch(new SyncTimeEntyMonthlyBatchJob(),1);
        if(batchId!=null){
            apexpages.getmessages().clear();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Time Entries is being fetched. Please wait for some time'));
        }
        
    }
}