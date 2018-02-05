({
	handleUpdatedTaskStatusEvent: function(component, event, helper) {        
        var taskItem = event.getParam("taskItem");
        helper.updateTask(component, taskItem); 
    },
    
    handleshowTaskUpdateWindowEvent: function(component, event, helper) {
        var taskItem = event.getParam("taskItem");        
        component.set("v.updateTaskItem", taskItem);
        component.set("v.openWindowTaskUpdate", true);
    },
    
    doInit: function(component, event, helper) {        
        helper.loadTasksToDo(component);
        helper.loadTasksDaily(component);
        helper.loadTasksHabit(component);
                        
        // Retrieving the Status picklist values
        helper.fetchPickListVal(component, 'Status__c');
    },
})