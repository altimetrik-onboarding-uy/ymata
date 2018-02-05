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
    }
})