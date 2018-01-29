trigger TaskPointCalculation on Task__c (after insert, after update) {    
    for(Task__c task : Trigger.New) {
        TaskPointCalculationUtil.updateEmployeeAwaredPoints(task, Trigger.oldMap, Trigger.isInsert);
    }
}