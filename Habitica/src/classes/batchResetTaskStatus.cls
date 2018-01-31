global class batchResetTaskStatus implements Database.Batchable<sObject>, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, Name, Status__c FROM Task__c WHERE RecordTypeName__c = \'Daily\' OR RecordTypeName__c = \'Habit\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Task__c> scope)
    {
        List<Task__c> tasksList = new List<Task__c>();
        for(Task__c task : scope)
        {
            task.Status__c = 'New';
            tasksList.add(task);
        }
        update tasksList;
    } 
    
    global void finish(Database.BatchableContext BC)
    {
    }
}