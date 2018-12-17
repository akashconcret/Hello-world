public with sharing class HRReportCtlr {
    public HRReport reportData{get; set;}
    public Map<String, List<Time_Entry__c>> mapAllMonthlyTimeEntry;
    
    public HRReportCtlr(ApexPages.StandardController stdCtrl){
        String hrReportObjId = ApexPages.currentPage().getParameters().get('id');
        Hr_Report__c reportObj = [Select Name, Report_Generated__c, From_Date__c, To_Date__c from Hr_Report__c where Id =:hrReportObjId Limit 1];
        reportData = new HRReport();
        reportData.reportName = reportObj.Name;
        reportData.fromDate = reportObj.From_Date__c;
        reportData.toDate = reportObj.To_Date__c;
        getAllMonthlyTimeEntry();
        reportData.lstUserTimeSheet = addUsersDetail();
    }
    
    public void getAllMonthlyTimeEntry(){
        mapAllMonthlyTimeEntry = new Map<String, List<Time_Entry__c>>();
        for(Time_Entry__c timeEntry : [Select Concretians__c, Date__c, total_hours_sum__c, total_mins_sum__c, Time_Entry_ExternalId__c from Time_Entry__c Where Date__c >= : reportData.fromDate AND Date__c <= : reportData.toDate AND Monthly_Report__c != null AND Concretians__c != null Limit 50000]){
            List<Time_Entry__c> lstTimeEntries = new List<Time_Entry__c>();
            if(!mapAllMonthlyTimeEntry.containsKey(timeEntry.Concretians__c)){
                lstTimeEntries.add(timeEntry);
                mapAllMonthlyTimeEntry.put(timeEntry.Concretians__c, lstTimeEntries);
            }else{
                lstTimeEntries = (List<Time_Entry__c>)mapAllMonthlyTimeEntry.get(timeEntry.Concretians__c);
                lstTimeEntries.add(timeEntry);
                mapAllMonthlyTimeEntry.put(timeEntry.Concretians__c, lstTimeEntries);
            }
        }
    }
    
    public List<HRReport.UserTimeSheet> addUsersDetail(){
        List<HRReport.UserTimeSheet> userTimeSheetLst = new List<HRReport.UserTimeSheet>();
        for(Concretian__c concretian : [Select Id, FirstName__c, Email__c, LastName__c, Teamwork_User_Id__c, Concretian_External_Id__c from Concretian__c]){
            HRReport.UserTimeSheet usrerTimeSheetObj = new HRReport.UserTimeSheet();
            usrerTimeSheetObj.userName = concretian.FirstName__c + ' ' + concretian.LastName__c;
            addTimeEntry(concretian.Id, usrerTimeSheetObj);
            userTimeSheetLst.add(usrerTimeSheetObj);
        }
        return userTimeSheetLst;
    }
    
    public void addTimeEntry(String concretianId, HRReport.UserTimeSheet usrerTimeSheetDetails){
        integer daysBetween = reportData.fromDate.daysBetween(reportData.toDate);
        Date entryDate = Date.Today().addmonths(-1);
        for(integer i=0; i<=daysBetween; i++){
            HRReport.timeSheet timeSheetObj = new HRReport.timeSheet();
            timeSheetObj.day = String.valueof(entryDate.addDays(i)); //.ReplaceAll('-','/');
            timeSheetObj.totalHrsSum = 0.0;
            if(mapAllMonthlyTimeEntry.containsKey(concretianId)){
                for(Time_Entry__c timeEntry : mapAllMonthlyTimeEntry.get(concretianId)){
                    if(timeEntry.Date__c == entryDate.addDays(i) && timeEntry.Concretians__c == concretianId){
                        timeSheetObj.totalHrsSum = timeEntry.total_hours_sum__c;
                    }
                }
            }
            if(i == 0){
               usrerTimeSheetDetails.lstTimeEntry1 = timeSheetObj;
            }
            if(i == 1){
               usrerTimeSheetDetails.lstTimeEntry2 = timeSheetObj;
            }
            if(i == 2){
               usrerTimeSheetDetails.lstTimeEntry3 = timeSheetObj;
            }
            if(i == 3){
               usrerTimeSheetDetails.lstTimeEntry4 = timeSheetObj;
            }
            if(i == 4){
               usrerTimeSheetDetails.lstTimeEntry5 = timeSheetObj;
            }
            if(i == 5){
               usrerTimeSheetDetails.lstTimeEntry6 = timeSheetObj;
            }
            if(i == 6){
               usrerTimeSheetDetails.lstTimeEntry7 = timeSheetObj;
            }
            if(i == 7){
               usrerTimeSheetDetails.lstTimeEntry8 = timeSheetObj;
            }
            if(i == 8){
               usrerTimeSheetDetails.lstTimeEntry9 = timeSheetObj;
            }
            if(i == 9){
               usrerTimeSheetDetails.lstTimeEntry10 = timeSheetObj;
            }
            if(i == 10){
               usrerTimeSheetDetails.lstTimeEntry11 = timeSheetObj;
            }
            if(i == 11){
               usrerTimeSheetDetails.lstTimeEntry12 = timeSheetObj;
            }
            if(i == 12){
               usrerTimeSheetDetails.lstTimeEntry13 = timeSheetObj;
            }
            if(i == 13){
               usrerTimeSheetDetails.lstTimeEntry14 = timeSheetObj;
            }
            if(i == 14){
               usrerTimeSheetDetails.lstTimeEntry15 = timeSheetObj;
            }
            if(i == 15){
               usrerTimeSheetDetails.lstTimeEntry16 = timeSheetObj;
            }
            if(i == 16){
               usrerTimeSheetDetails.lstTimeEntry17 = timeSheetObj;
            }
            if(i == 17){
               usrerTimeSheetDetails.lstTimeEntry18 = timeSheetObj;
            }
            if(i == 18){
               usrerTimeSheetDetails.lstTimeEntry19 = timeSheetObj;
            }
            if(i == 19){
               usrerTimeSheetDetails.lstTimeEntry20 = timeSheetObj;
            }
            if(i == 20){
               usrerTimeSheetDetails.lstTimeEntry21 = timeSheetObj;
            }
            if(i == 21){
               usrerTimeSheetDetails.lstTimeEntry22 = timeSheetObj;
            }
            if(i == 22){
               usrerTimeSheetDetails.lstTimeEntry23 = timeSheetObj;
            }
            if(i == 23){
               usrerTimeSheetDetails.lstTimeEntry24 = timeSheetObj;
            }
            if(i == 24){
               usrerTimeSheetDetails.lstTimeEntry25 = timeSheetObj;
            }
            if(i == 25){
               usrerTimeSheetDetails.lstTimeEntry26 = timeSheetObj;
            }
            if(i == 26){
               usrerTimeSheetDetails.lstTimeEntry27 = timeSheetObj;
            }
            if(i == 27){
               usrerTimeSheetDetails.lstTimeEntry28 = timeSheetObj;
            }
            if(i == 28){
               usrerTimeSheetDetails.lstTimeEntry29 = timeSheetObj;
            }
            if(i == 29){
               usrerTimeSheetDetails.lstTimeEntry30 = timeSheetObj;
            }
            if(i == 30){
               usrerTimeSheetDetails.lstTimeEntry31 = timeSheetObj;
            }
        }
    }
}