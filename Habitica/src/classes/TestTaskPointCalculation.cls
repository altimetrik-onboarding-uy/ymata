@isTest
private class TestTaskPointCalculation {

    @isTest static void TestTaskPointCalculation() {
        // Test data setup
        // Create an employee with a task and then try to record the task.
        Contact employee = new Contact( FirstName = 'Test', LastName = 'Employee' );
        Contact employeeWithoutPoints = new Contact( FirstName = 'Test', LastName = 'Employee Without Default Points', Total_Points_Calculated__c = null );
        
        insert employee;
        insert employeeWithoutPoints;
        
        // Test for TO-DO type task
        Id RecordTypeIdTODO = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Task__c taskTODO = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = Date.today(),
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employee.Id);
        
        // Test for TO-DO type task over due
        Task__c taskTODOOverDue = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = Date.today().addDays(-5),
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employee.Id);
        
        // Test for TO-DO type task whitout Due Date
        Task__c taskTODOWithoutDue = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = null,
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employee.Id);
        
        // Test for Daily type task with employee without a default value for the field TotalPointCalculation 
        Id RecordTypeIdDaily = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('Daily').getRecordTypeId();
        Task__c taskDaily = new Task__c(Name = 'Daily type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   RecordTypeId = RecordTypeIdDaily,
            					   Employee__c = employeeWithoutPoints.Id);                
        
        //Perform test
        Test.startTest();
        Database.SaveResult resultTODO = Database.insert(taskTODO, false);
        Database.SaveResult resultTODOOverDue = Database.insert(taskTODOOverDue, false);
		Database.SaveResult resultTODOWithoutDue = Database.insert(taskTODOWithoutDue, false);        
        Database.SaveResult resultDaily = Database.insert(taskDaily, false);
        Test.stopTest();
        
        // Verify the result of the test
        System.assert(resultTODO.isSuccess());
        System.assert(resultTODOOverDue.isSuccess());
        System.assert(resultTODOWithoutDue.isSuccess());
        System.assert(resultDaily.isSuccess());        
    }
    
}