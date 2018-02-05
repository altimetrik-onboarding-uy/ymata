({    
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) { 
        component.set("v.isOpen", false);
    },
    
    changeStatusAction: function(component, event, helper) {
        var task = component.get("v.taskItem");
        var newState = component.find("status").get("v.value");
        task.Status__c = newState;
        var updatedTaskToDoStatus = component.getEvent("updatedTaskStatus");
        updatedTaskToDoStatus.setParams({ "taskItem": task });
        updatedTaskToDoStatus.fire();
        component.set("v.isOpen", false);
    },
})