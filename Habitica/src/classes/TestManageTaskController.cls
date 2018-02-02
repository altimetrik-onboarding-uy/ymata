@isTest
private class TestManageTaskController {
    @isTest static void TestManageTaskUpdateController() {
        // Test data setup
        Contact employee = TestDataFactory.createEmployee();
        List<Task__c> tasks = TestDataFactory.createTasksToEmployee(employee.Id);
        
        List<Task__c> tasksToDo = ManageEmployeeTaskController.getEmployeeToDoTasks(employee.Id);
        System.assertEquals(3, tasksToDo.size());
        
        List<Task__c> tasksDaily = ManageEmployeeTaskController.getEmployeeDailyTasks(employee.Id);
        System.assertEquals(1, tasksDaily.size());
        
        List<Task__c> tasksHabit = ManageEmployeeTaskController.getEmployeeHabitTasks(employee.Id);
        System.assertEquals(2, tasksHabit.size());
    }

    @isTest static void TestUpdateTask() {
        Contact employee = TestDataFactory.createEmployee();
        
        Id RecordTypeIdHabit = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('Habit').getRecordTypeId();
        Task__c taskHabit = new Task__c(Name = 'Habit type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   RecordTypeId = RecordTypeIdHabit,
            					   Employee__c = employee.Id);
        insert taskHabit;
        
        taskHabit.Status__c = 'New';
        Task__c taskUpdated = ManageEmployeeTaskController.updateTask(taskHabit);
        System.assertEquals('New', taskUpdated.Status__c);
    }
}