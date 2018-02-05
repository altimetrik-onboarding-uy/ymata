@isTest
private class TestTaskPointCalculation {

    @isTest static void TestTaskPointCalculation() {
        // Test data setup
        Contact employee = TestDataFactory.createEmployee();
        List<Task__c> tasks = TestDataFactory.createTasksToEmployee(employee.Id);
        
        Contact employeeUpdated = [SELECT Id, Name, Total_Points_Calculated__c FROM Contact WHERE Id = :employee.Id];
        System.assertEquals(8.5, employeeUpdated.Total_Points_Calculated__c);
    }
    
}