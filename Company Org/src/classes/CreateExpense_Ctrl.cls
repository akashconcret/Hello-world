/**
 * Name : CreateExpense_Ctrl
 * Author : Mr Arun Jain Concretio
 * Date : 01-Nov-2017
 * Description : It will create the Expense in AWS DynamoDB
**/

global class CreateExpense_Ctrl {
    /**
     * Name : createExpense
     * @param
     *  expenseName String Name of The Expense
     *  amount String Money Spend in Expense
     *  expenseDate String Expense Date
     *  expenseType String Type of Expense
     *  description String Small Description of Expense
     *  havingBill Boolean Whether the Expense contains Bill or Not : For some expenses it might happen that doesn't Contain Bill
     *  fileBill String BASE64 String for the Bill Image or PDF
    **/
    @RemoteAction
    public static Response createExpense(String expenseName,String amount,
                                     String expenseDate,String expenseType,
                                     String description,Boolean havingBill,
                                     List<String> fileBill) {
        
       
        
        //Fetching AWS Key From Custom Settings
        AWS__c awsKey = [SELECT Access_key_ID__c,Secret_access_key__c FROM AWS__c WHERE Name ='Concretio' LIMIT 1];
        String userName = UserInfo.getName();
        DateTime dt = System.now();
        Long expenseId = dt.getTime();
        String jsonRequest = '{"expenseId":'+expenseId+',"expenseName":"'+expenseName+'","expenseType":"'+expenseType+'","price":"'+amount+'","expenseDate":"'+expenseDate+'","description":"'+description+'","whom":"'+userName+'","havingBill":"'+havingBill+'"}';
        if(fileBill.size()>0){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://aws-rest-api.herokuapp.com/UploadFile.php');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization1',awsKey.Access_key_ID__c);
            request.setHeader('Secret-Key',awsKey.Secret_access_key__c);
            // Set the body as a JSON object
            request.setBody(JSON.serialize(fileBill));
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
               System.debug('File Uploaded Successfully');
               System.debug(response.getBody());
            } else {
                System.debug(response.getStatusCode());
            }
        }
       
       
       
        //Calling RestAPI From PHP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://aws-rest-api.herokuapp.com/CreateExpense.php');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization1',awsKey.Access_key_ID__c);
        request.setHeader('Secret-Key',awsKey.Secret_access_key__c);
        // Set the body as a JSON object
        System.debug(jsonRequest);
        request.setBody(jsonRequest);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            //Generating Response
            List<ExpenseItem> lstExpenseItems = new List<ExpenseItem>();
            //for(Integer i=0;i<10;i++){
                ExpenseItem et = new ExpenseItem(expenseName,amount,expenseDate,expenseType,description,havingBill,'');
                lstExpenseItems.add(et);
            //}
            return new Response(lstExpenseItems,response.getStatusCode(),'');
        } else {
            return new Response(new List<ExpenseItem>(),response.getStatusCode(),response.getBody());
        }
    }
    
    
    /**
     * Name : createExpense
     * Return the Expense List entered by User
    **/
    @RemoteAction
    public static Response getAllExpensesByUser(){
        //Fetching AWS Key From Custom Settings
        AWS__c awsKey = [SELECT Access_key_ID__c,Secret_access_key__c FROM AWS__c WHERE Name ='Concretio' LIMIT 1];
        String userName = UserInfo.getName();
        DateTime dt = System.now();
        Long expenseId = dt.getTime();
        String jsonRequest = '{"whom":"'+userName+'"}';
        //Calling RestAPI From PHP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://aws-rest-api.herokuapp.com/ShowAll.php');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization1',awsKey.Access_key_ID__c);
        request.setHeader('Secret-Key',awsKey.Secret_access_key__c);
        // Set the body as a JSON object
        request.setBody(jsonRequest);
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        if (response.getStatusCode() == 200) {
        //     //Generating Response
        //     List<ExpenseItem> lstExpenseItems = new List<ExpenseItem>();
        //     //for(Integer i=0;i<10;i++){
        //         ExpenseItem et = new ExpenseItem(expenseName,amount,expenseDate,expenseType,description,havingBill,fileBill);
        //         lstExpenseItems.add(et);
        //     //}
        //     return new Response(lstExpenseItems,response.getStatusCode(),'');
        // } else {
            return new Response(new List<ExpenseItem>(),response.getStatusCode(),response.getBody());
        }
        return new Response(new List<ExpenseItem>(),response.getStatusCode(),response.getBody());
    }
    public class Response{
        public List<ExpenseItem> lstExpenseItems{get;set;}
        public Integer statusCode{get;set;}
        public String errorMessage{get;set;}
        
        public Response(List<ExpenseItem> lET,Integer sc,String em){
            lstExpenseItems = lET;
            statusCode = sc;
            errorMessage = em;
        }
    }
    public class ExpenseItem{
        public String expenseName{get;set;}
        public String amount{get;set;}
        public String expenseDate{get;set;}
        public String expenseType{get;set;}
        public String description{get;set;}
        public Boolean havingBill{get;set;}
        public String fileBill{get;set;}
        
        public ExpenseItem(String expenseName,String amount,
                                     String expenseDate,String expenseType,
                                     String description,Boolean havingBill,
                                     String fileBill){
            this.expenseName = expenseName;
            this.amount = amount;
            this.expenseDate = expenseDate;
            this.expenseType = expenseType;
            this.description = description;
            this.havingBill = havingBill;
            this.fileBill = fileBill;
        }
    }
}