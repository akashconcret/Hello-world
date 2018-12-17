global class SendHRReport implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global String reportObjId{get; set;}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Name, Report_Generated__c, From_Date__c, To_Date__c from Hr_Report__c where Id = \'' + reportObjId + '\' Limit 1');
    }
    
    global void execute(Database.BatchableContext BC, List<Concretian__c> scope){}
    global void finish(Database.BatchableContext BC){
        PageReference pdf = Page.HRReportPage;
        pdf.getParameters().put('id', reportObjId);
        pdf.setRedirect(true);
        Blob b = pdf.getContent();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('MonthlyTimeSheet.xls');
        efa.setBody(b);
        String[] toAddresses = new list<string> {'badan@concret.io'};
        String subject ='Monthly time sheet report';
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Monthly time sheet report genrated, Please check attachment.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{efa});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
   }
}