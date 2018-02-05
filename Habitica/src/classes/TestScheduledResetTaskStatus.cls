@isTest
private class TestScheduledResetTaskStatus {
    
    @isTest static void TestScheduledResetTaskStatus() {
        // Test data setup
        Contact employee = TestDataFactory.createEmployee();
        List<Task__c> tasks = TestDataFactory.createTasksToEmployee(employee.Id);
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('Scheduled Apex Test', '0 0 0 15 3 ? 2022', new ScheduledResetTaskStatus());         
        Test.stopTest();
		
        Contact updatedEmployee = [SELECT Id, Name, Total_Points_Calculated__c FROM Contact WHERE Id = :employee.Id];
        System.assertEquals(8.5, updatedEmployee.Total_Points_Calculated__c);
    }
}