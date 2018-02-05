@isTest
private class TestBatchResetTaskSatus {
    
    @isTest static void TestResetTaskStatus() {
        // Test data setup
        Contact employee = TestDataFactory.createEmployee();
        List<Task__c> tasks = TestDataFactory.createTasksToEmployee(employee.Id);
        
        Test.startTest();
        BatchResetTaskStatus b = new BatchResetTaskStatus();
        Id batchId = Database.executeBatch(b);
        Test.stopTest();
		
        Contact updatedEmployee = [SELECT Id, Name, Total_Points_Calculated__c FROM Contact WHERE Id = :employee.Id];
        System.assertEquals(5, updatedEmployee.Total_Points_Calculated__c);
    }
}