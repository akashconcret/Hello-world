global with sharing class SyncTimeEntyWeeklyBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC){
        delete [select id from Time_Entry__c];
        delete [select id from Weekly_Report__c];
        return Database.getQueryLocator('Select id, Email__c, Teamwork_User_Id__c from Concretian__c Where Teamwork_User_Id__c != null');
    }
    
    global void execute(Database.BatchableContext BC, List<Concretian__c> scope){
        HttpRequest req ;
        Http http;
        HTTPResponse res;
        TeamWork_Configuration__c  Configure = TeamWorkConFig.Configuration;
        // Date lastday = Date.today().addDays(-1);
        // DateTime dt = DateTime.newInstance(lastday.year(), lastday.month(),lastday.day());
        // String lastdayStr = dt.format('yyyyMMdd');
        TimeEntry timeEntryDetail;
        String authorizationHeader = EncodingUtil.base64Encode(Blob.valueOf(Configure.App_Key__c));
        Time_Entry__c timeEntryObj;
        List<Time_Entry__c> lstOfTimeEntry = new list<Time_Entry__c>();
        Weekly_Report__c weeklyReportObj;
        for(Concretian__c conObj : scope){
            weeklyReportObj = new Weekly_Report__c();
            weeklyReportObj.Concretian__c = conObj.Id;
            weeklyReportObj.Email__c = conObj.Email__c;
            weeklyReportObj.Weekly_Report_External_Id__c = conObj.Teamwork_User_Id__c+'-'+string.valueof(Date.Today().adddays(-1)).ReplaceAll('-','')+string.valueof(Date.Today().adddays(-5)).ReplaceAll('-','');
            weeklyReportObj.From_date__c = Date.Today().adddays(-5);
            weeklyReportObj.To_Date__c = Date.Today().adddays(-1);
            
            for(integer i=1;i<=5;i++){
                string LastDayStr = string.valueof(Date.Today().adddays(-i)).ReplaceAll('-','');
                req = new HttpRequest(); 
                req.setEndpoint(Configure.End_Point__c+'time/total.json?userId='+conObj.Teamwork_User_Id__c+'&fromDate='+LastDayStr+'&toDate='+LastDayStr);
                req.setMethod('GET');
                req.setHeader('Accept', 'application/json; charset=UTF-8');
                req.setHeader('Content-Type','application/json');  
                req.setHeader('Authorization', 'Basic '+authorizationHeader);
                req.setTimeout(120000);
                http = new Http();
                try {
                    res = http.send(req);
                    if(res.getStatusCode() == 200){
                        timeEntryDetail = TimeEntry.parse(string.valueof(res.getbody()).ReplaceAll('-','_'));
                        if(timeEntryDetail.STATUS == 'OK' && timeEntryDetail.time_totals != null){
                            timeEntryObj = new Time_Entry__c();
                            timeEntryObj.Concretians__c = conObj.Id;
                            timeEntryObj.total_hours_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.total_hours_sum);
                            timeEntryObj.total_mins_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.total_mins_sum);
                            timeEntryObj.billable_mins_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.billable_mins_sum);
                            timeEntryObj.non_billable_mins_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.non_billable_mins_sum);
                            timeEntryObj.Email__c = conObj.Email__c;
                            timeEntryObj.Date__c = Date.Today().adddays(-(i));
                            timeEntryObj.Time_Entry_ExternalId__c = lastdayStr+conObj.Teamwork_User_Id__c;
                            lstOfTimeEntry.add(timeEntryObj);
                        }
                    }
                } catch(System.CalloutException e) {}
            }
            // lstOfWeeklyReports.add(weeklyReportObj);
        }
        upsert weeklyReportObj Weekly_Report_External_Id__c;
        if(!lstOfTimeEntry.IsEmpty()){
            for(Time_Entry__c timeEntry : lstOfTimeEntry){
                timeEntry.Weekly_Report__c = weeklyReportObj.Id;
                if(timeEntry.total_hours_sum__c < 5.0){
                    weeklyReportObj.Notify_User__c = true;
                }
            }
            upsert lstOfTimeEntry Time_Entry_ExternalId__c;
        }
        update weeklyReportObj;
    }
    
    global void finish(Database.BatchableContext BC){}
}