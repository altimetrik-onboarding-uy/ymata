({
    updateTask: function(component, taskItem) {
        var action = component.get("c.updateTask");        
        action.setParams({
            "task": taskItem
        });
        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                var taskUpdated = response.getReturnValue();
                var listToUpdate = "";
                if (taskUpdated.RecordTypeName__c == "TO-DO") {
                    listToUpdate = "v.tasksToDo";
                }
                else if (taskUpdated.RecordTypeName__c == "Daily") {
                    listToUpdate = "v.tasksDaily";
                }
				else if (taskUpdated.RecordTypeName__c == "Habit") {
                    listToUpdate = "v.tasksHabit";
                }                
                var tasks = component.get(String(listToUpdate));                                
                var cont = 0;
                tasks.forEach(function(task) {
                    if (task.Id == taskItem.Id) {
                        tasks[cont] = taskUpdated;
                    }
                    cont++;
                })
                component.set(String(listToUpdate), tasks);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully.",
                    "type": "success",
                });
                toastEvent.fire();
            }
            else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was a problem updating the task.",
                    "type": "error",
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPickListVal: function(component, fieldName) {
        var action = component.get("c.getSelectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v.taskStatusList", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadTasksToDo: function(component) {
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
    },
    
    loadTasksDaily: function(component) {
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
    },
    
    loadTasksHabit: function(component) {
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