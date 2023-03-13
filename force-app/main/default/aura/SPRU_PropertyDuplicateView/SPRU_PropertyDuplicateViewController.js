({
    
    doInit:function(component, event, helper) {
        var action = component.get("c.getDuplicateProperty");
        action.setParams({recordId : component.get('v.recordId'),recordType:component.get("v.recordType")});
        action.setCallback(this, function(response) {
            component.set("v.spinner", false)
            console.log(response.getReturnValue());
            var result=response.getReturnValue();
            console.log(JSON.stringify(result));
            component.set("v.apiResult", result);
        });
        $A.enqueueAction(action); 
        component.set("v.spinner", true)
    },
    showSpinner: function(component, event, helper) {   
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },
    handleClick: function(component,event,helper){
        var idx = event.target.id;
        var navLink = component.find("navLink");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'Property__c',
                recordId : idx
            },
        };
        navLink.navigate(pageRef, true);
        
    }
})