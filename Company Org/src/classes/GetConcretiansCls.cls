public with sharing class GetConcretiansCls {
    public Static void processPeople(){
        HttpRequest req ;
        Http http;
        HTTPResponse res;
        GetConcretians getConcretiansDetails;
        // String authorizationHeader = EncodingUtil.base64Encode(Blob.valueOf('speak825cruise')); 
        String authorizationHeader = EncodingUtil.base64Encode(Blob.valueOf('moon355night'));
        Concretian__c ConcretiansDetail;
        List<Concretian__c> lstOfConcretians = new list<Concretian__c>();
        
        req = new HttpRequest(); 
        // req.setEndpoint('https://concretio1.teamwork.com/companies/93188/people.json');
        req.setEndpoint('https://concretio.teamwork.com/companies/74680/people.json');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json; charset=UTF-8');
        req.setHeader('Content-Type','application/json');  
        req.setHeader('Authorization', 'Basic '+authorizationHeader);
        req.setTimeout(120000);
        http = new Http();
        try {
            res = http.send(req);
            if(res.getStatusCode() == 200){
                getConcretiansDetails = GetConcretians.parse(string.valueof(res.getbody()).ReplaceAll('-','_'));
                if(getConcretiansDetails != null && getConcretiansDetails.people != null && getConcretiansDetails.people.size() > 0){
                    for(GetConcretians.cls_people people : getConcretiansDetails.people){
                        ConcretiansDetail = new Concretian__c();
                        ConcretiansDetail.FirstName__c = people.first_name;
                        ConcretiansDetail.LastName__c  = people.last_name;
                        ConcretiansDetail.Email__c     = people.email_address;
                        ConcretiansDetail.Company_Name__c = people.company_name;
                        ConcretiansDetail.Company_Id__c  = people.companyId;
                        ConcretiansDetail.Teamwork_User_Id__c = people.id;
                        ConcretiansDetail.Concretian_External_Id__c = people.id+people.companyId;
                        
                        lstOfConcretians.add(ConcretiansDetail);
                    }
                }
            }
        } catch(System.CalloutException e) {}
        
        if(!lstOfConcretians.IsEmpty()){
            upsert lstOfConcretians Concretian_External_Id__c;
        }
    }
}