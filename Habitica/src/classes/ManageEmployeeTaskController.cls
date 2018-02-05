public with sharing class ManageEmployeeTaskController {
	@AuraEnabled
    public static List<Task__c> getEmployeeToDoTasks(Id employeeId) {        
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'TO-DO' Limit 1];
        List<Task__c> taskList = [SELECT Id, Name, Status__c, Difficulty__c, Award_Points__c, Due_Date__c, RecordTypeName__c FROM Task__c WHERE Employee__c = :employeeId AND RecordTypeId = :rt.Id];
        
        return taskList;
    }
    
    @AuraEnabled
    public static List<Task__c> getEmployeeDailyTasks(Id employeeId) {        
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Daily' Limit 1];
        List<Task__c> taskList = [SELECT Id, Name, Status__c, Difficulty__c, Award_Points__c, RecordTypeName__c FROM Task__c WHERE Employee__c = :employeeId AND RecordTypeId = :rt.Id];
        
        return taskList;
    }
    
    @AuraEnabled
    public static List<Task__c> getEmployeeHabitTasks(Id employeeId) {        
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Habit' Limit 1];
        List<Task__c> taskList = [SELECT Id, Name, Status__c, Difficulty__c, Award_Points__c, RecordTypeName__c FROM Task__c WHERE Employee__c = :employeeId AND RecordTypeId = :rt.Id];
        
        return taskList;
    }
    
    @AuraEnabled
    public static Task__c updateTask(Task__c task) {
        try{
            update task;            
        } catch (DMLException e){              
            throw new AuraHandledException('There was a problem updating the task');
        }  
        
        return task;
    }
    
    @AuraEnabled
    public static List < String > getSelectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        
        return allOpts;
    }
}