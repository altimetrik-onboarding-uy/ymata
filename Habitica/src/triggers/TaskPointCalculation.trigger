trigger TaskPointCalculation on Task__c (after insert, after update) {    
    for(Task__c task : Trigger.New) {
        Task__c oldValue = Trigger.isInsert ? null : Trigger.oldMap.get(task.Id);
        TaskPointCalculationUtil.updateEmployeeAwaredPoints(task, oldValue, Trigger.isInsert);
    }
}