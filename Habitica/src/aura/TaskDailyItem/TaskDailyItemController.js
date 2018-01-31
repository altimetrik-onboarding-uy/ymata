({
	fireEventOpenTaskUpdateWindow: function(component, event, helper) {
        var taskItem = component.get("v.item");
        var showTaskUpdateWindowEvent = component.getEvent("showTaskUpdateWindow");
        showTaskUpdateWindowEvent.setParams({ "taskItem": taskItem });
        showTaskUpdateWindowEvent.fire();
    },
})