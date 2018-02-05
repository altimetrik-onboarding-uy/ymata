({        
    doInit: function(component, event, helper) {
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        var dayDigit = today.getDate();
        if(dayDigit <= 9){
            dayDigit = '0' + dayDigit;
        }
        component.set('v.dateToday', today.getFullYear() + "-" + monthDigit + "-" + dayDigit);
        component.set('v.baseURL', window.location.origin + '/' + component.get("v.item.Id"));
    },
    
    fireEventOpenTaskUpdateWindow: function(component, event, helper) {
        var taskItem = component.get("v.item");
        var showTaskUpdateWindowEvent = component.getEvent("showTaskUpdateWindow");
        showTaskUpdateWindowEvent.setParams({ "taskItem": taskItem });
        showTaskUpdateWindowEvent.fire();
    },
})