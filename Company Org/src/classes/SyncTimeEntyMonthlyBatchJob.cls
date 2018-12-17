global with sharing class SyncTimeEntyMonthlyBatchJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    global List<Monthly_Report__c> lstMonthlyReport;
    
    global SyncTimeEntyMonthlyBatchJob(){
        lstMonthlyReport = new List<Monthly_Report__c>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        delete [select id from Time_Entry__c limit 10000];
        return Database.getQueryLocator('Select id, Email__c, Teamwork_User_Id__c from Concretian__c Where Teamwork_User_Id__c != null');
    }
    
    global void execute(Database.BatchableContext BC, List<Concretian__c> scope){
        HttpRequest req ;
        Http http;
        HTTPResponse res;
        TeamWork_Configuration__c  Configure = TeamWorkConFig.Configuration;
        TimeEntry timeEntryDetail;
        String authorizationHeader = EncodingUtil.base64Encode(Blob.valueOf(Configure.App_Key__c));
        Time_Entry__c timeEntryObj;
        List<Time_Entry__c> lstOfTimeEntry = new list<Time_Entry__c>();
        Monthly_Report__c monthlyReportObj;  
        // integer daysBetween = Date.Today().addmonths(-1).daysBetween(Date.Today().addDays(-1));
        integer daysBetween = Date.daysInMonth(Date.Today().addmonths(-1).year(), Date.Today().addmonths(-1).month());
        for(Concretian__c conObj : scope){
            monthlyReportObj = new Monthly_Report__c();
            monthlyReportObj.Concretian__c = conObj.Id;
            monthlyReportObj.Email__c = conObj.Email__c;
            monthlyReportObj.Monthly_Report_External_Id__c = conObj.Teamwork_User_Id__c+'-'+string.valueof(Date.Today().adddays(-1)).ReplaceAll('-','')+string.valueof(Date.Today().addmonths(-1)).ReplaceAll('-','');
            // monthlyReportObj.From_Date__c = Date.Today().addmonths(-1);
            monthlyReportObj.From_Date__c = Date.newInstance(Date.Today().addmonths(-1).year(), Date.Today().addmonths(-1).month(), 01);
            // monthlyReportObj.To_Date__c = Date.Today().adddays(-1);
            monthlyReportObj.To_Date__c = Date.newInstance(Date.Today().addmonths(-1).year(), Date.Today().addmonths(-1).month(), Date.daysInMonth(Date.Today().addmonths(-1).year(), Date.Today().addmonths(-1).month()));
            
            for(integer i=0;i<daysBetween;i++){
                DateTime dtime = DateTime.newInstance(Date.Today().addmonths(-1).year(),Date.Today().addmonths(-1).month(),i+1);
                //if(dtime.format('E') != 'Sat' && dtime.format('E') != 'Sun'){
                    string LastDayStr = string.valueof(dtime.date()).ReplaceAll('-',''); 
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
                                timeEntryObj.Day__c = returnDay(dtime);
                                timeEntryObj.billable_mins_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.billable_mins_sum);
                                timeEntryObj.non_billable_mins_sum__c = Decimal.valueOf(timeEntryDetail.time_totals.non_billable_mins_sum);
                                timeEntryObj.Email__c = conObj.Email__c;
                                // timeEntryObj.Date__c = Date.Today().adddays(-(i)); 
                                // timeEntryObj.Date__c = Date.Today().addmonths(-1).adddays(i);
                                
                                timeEntryObj.Date__c = dtime.date();
                                timeEntryObj.Time_Entry_ExternalId__c = lastdayStr+conObj.Teamwork_User_Id__c;
                                lstOfTimeEntry.add(timeEntryObj);
                            }
                        }
                    } catch(System.CalloutException e) {}
                //}
            }
            
        }
        upsert monthlyReportObj Monthly_Report_External_Id__c;
        if(!lstOfTimeEntry.IsEmpty()){
            for(Time_Entry__c timeEntry : lstOfTimeEntry){
                timeEntry.Monthly_Report__c = monthlyReportObj.Id;
                if(timeEntry.total_hours_sum__c < 5.0){
                    monthlyReportObj.Notify_User__c = true;
                }
            }
            upsert lstOfTimeEntry Time_Entry_ExternalId__c;
        }
        update monthlyReportObj;
        lstMonthlyReport.add(monthlyReportObj);
    }
    
    global string returnDay(DateTime dtm){
        if(dtm.format('E') == 'Sat'){
            return 'Saturday';
        }else if(dtm.format('E') == 'Sun'){
            return 'Sunday';
        }else if(dtm.format('E') == 'Mon'){
            return 'Monday';
        }else if(dtm.format('E') == 'Tue'){
            return 'Tuesday';
        }else if(dtm.format('E') == 'Wed'){
            return 'Wednesday';
        }else if(dtm.format('E') == 'Thu'){
            return 'Thursday';
        }else if(dtm.format('E') == 'Fri'){
            return 'Friday';
        }
        return null;
    }
    global void finish(Database.BatchableContext BC){
        if(!lstMonthlyReport.isEmpty()){
            Hr_Report__c hrReportObj = new Hr_Report__c();
            hrReportObj.From_Date__c = lstMonthlyReport[0].From_Date__c;
            hrReportObj.To_Date__c = lstMonthlyReport[0].To_Date__c;
            hrReportObj.Report_Generated__c = false;
            insert hrReportObj;
            
            for(Monthly_Report__c monthlyReportObj : lstMonthlyReport){
                monthlyReportObj.Hr_Report__c = hrReportObj.Id;
            }
            update lstMonthlyReport;
            hrReportObj.Report_Generated__c = true;
            update hrReportObj;
            SendHRReport sendReport = new SendHRReport(); 
            sendReport.reportObjId = hrReportObj.Id;
            database.executebatch(sendReport, 1);
            // SendHRReport.sendEmail(hrReportObj.Id);
            // PageReference pdf = Page.HRReportPage;
            // pdf.getParameters().put('id', hrReportObj.Id);
            // List<Hr_Report__c> reportObjList = [Select Name, Report_Generated__c, From_Date__c, To_Date__c from Hr_Report__c];
            // System.debug('hrReportObj.Id:: '+hrReportObj.Id+'::::'+reportObjList);
            // pdf.setRedirect(false);
            // Blob b = pdf.getContent();
            // Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            // efa.setFileName('MonthlyTimeSheet.xls');
            // efa.setBody(b);
            // String[] toAddresses = new list<string> {'badan@concret.io'};
            // String subject ='Monthly time sheet report';
            // Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            // email.setSubject(subject);
            // email.setToAddresses( toAddresses );
            // email.setPlainTextBody('Monthly time sheet report genrated, Please check attachment.');
            // email.setFileAttachments(new Messaging.EmailFileAttachment[]{efa});
            // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}