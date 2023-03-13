public class ApplicationResponse{
    @AuraEnabled public message message{get;set;}
    @AuraEnabled public Boolean success{get;set;}
    public class message{
        @AuraEnabled public String resUpdateUser{get;set;}
        @AuraEnabled public String resCreateLoan{get;set;}
        @AuraEnabled public String resCreateUser{get;set;}
        @AuraEnabled public String resUpdateLoan{get;set;}
        @AuraEnabled public list<errors> errors{get;set;}
        @AuraEnabled public String name{get;set;}
    }
    public class errors{
        @AuraEnabled public String path{get;set;}
        @AuraEnabled public String origin{get;set;}
        @AuraEnabled public String validatorKey{get;set;}
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String validatorName{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public list<String> validatorArgs{get;set;}
        @AuraEnabled public String message{get;set;}
    }
}