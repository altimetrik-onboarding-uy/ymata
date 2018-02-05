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
        var actionToDo = component.get("c.getEmployeeToDoTasks");
        actionToDo.setParams({
            "employeeId": component.get("v.recordId")
        });
        actionToDo.setCallback(this, function(response){            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tasksToDo", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionToDo);
        
        var actionDaily = component.get("c.getEmployeeDailyTasks");
        actionDaily.setParams({
            "employeeId": component.get("v.recordId")
        });
        actionDaily.setCallback(this, function(response){            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tasksDaily", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionDaily);
        
        var actionHabit = component.get("c.getEmployeeHabitTasks");
        actionHabit.setParams({
            "employeeId": component.get("v.recordId")
        });
        actionHabit.setCallback(this, function(response){            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tasksHabit", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionHabit);
    },
})