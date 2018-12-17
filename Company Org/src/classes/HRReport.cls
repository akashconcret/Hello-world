public with sharing class HRReport {
   public String reportName{get; set;}
    public Date fromDate{get; set;}
    public Date toDate{get; set;}
    public List<UserTimeSheet> lstUserTimeSheet{get; set;}
    
    public class UserTimeSheet{
        public String userName{get; set;}
        public timeSheet lstTimeEntry1{get; set;}
        public timeSheet lstTimeEntry2{get; set;}
        public timeSheet lstTimeEntry3{get; set;}
        public timeSheet lstTimeEntry4{get; set;}
        public timeSheet lstTimeEntry5{get; set;}
        public timeSheet lstTimeEntry6{get; set;}
        public timeSheet lstTimeEntry7{get; set;}
        public timeSheet lstTimeEntry8{get; set;}
        public timeSheet lstTimeEntry9{get; set;}
        public timeSheet lstTimeEntry10{get; set;}
        public timeSheet lstTimeEntry11{get; set;}
        public timeSheet lstTimeEntry12{get; set;}
        public timeSheet lstTimeEntry13{get; set;}
        public timeSheet lstTimeEntry14{get; set;}
        public timeSheet lstTimeEntry15{get; set;}
        public timeSheet lstTimeEntry16{get; set;}
        public timeSheet lstTimeEntry17{get; set;}
        public timeSheet lstTimeEntry18{get; set;}
        public timeSheet lstTimeEntry19{get; set;}
        public timeSheet lstTimeEntry20{get; set;}
        public timeSheet lstTimeEntry21{get; set;}
        public timeSheet lstTimeEntry22{get; set;}
        public timeSheet lstTimeEntry23{get; set;}
        public timeSheet lstTimeEntry24{get; set;}
        public timeSheet lstTimeEntry25{get; set;}
        public timeSheet lstTimeEntry26{get; set;}
        public timeSheet lstTimeEntry27{get; set;}
        public timeSheet lstTimeEntry28{get; set;}
        public timeSheet lstTimeEntry29{get; set;}
        public timeSheet lstTimeEntry30{get; set;}
        public timeSheet lstTimeEntry31{get; set;}
    }
    
    public class timeSheet{
        public String day{get; set;}
        public Decimal totalHrsSum{get; set;}
    } 
}