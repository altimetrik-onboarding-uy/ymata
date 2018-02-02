public class TestDataFactory {
    public static Contact createEmployee() {
        Contact employee = new Contact(FirstName = 'First Name', 
                                       LastName = 'Last Name', 
                                       Total_Points_Calculated__c = null );
        insert employee;
        return employee;
    }
    
    public static List<Task__c> createTasksToEmployee(Id employeeId) {
        List<Task__c> tasks = new List<Task__c>();
        
        // Test for TO-DO type task (Points: 5)
        Id RecordTypeIdTODO = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Task__c taskTODO = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = Date.today(),
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employeeId);
        tasks.add(taskTODO);
        
        // Test for TO-DO type task over due (Points: -2.5)
        Task__c taskTODOOverDue = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = Date.today().addDays(-5),
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employeeId);
        tasks.add(taskTODOOverDue);
        
        // Test for TO-DO type task whitout Due Date (Points: 5)
        Task__c taskTODOWithoutDue = new Task__c(Name = 'TO-DO type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   Due_Date__c = null,
                                   RecordTypeId = RecordTypeIdTODO,
            					   Employee__c = employeeId);
        tasks.add(taskTODOWithoutDue);
        
        // Test for Daily type task (Points: -2.5 in batch apex ) 
        Id RecordTypeIdDaily = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('Daily').getRecordTypeId();
        Task__c taskDaily = new Task__c(Name = 'Daily type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'New',
                                   Difficulty__c = 'Hard',
                                   RecordTypeId = RecordTypeIdDaily,
            					   Employee__c = employeeId);                
        tasks.add(taskDaily);
        
        // Test for Habit type task (Points: 1) 
        Id RecordTypeIdHabit = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('Habit').getRecordTypeId();
        Task__c taskHabit = new Task__c(Name = 'Habit type task',
                                   Description__c = 'Task Description',
                                   Status__c = 'Completed',
                                   Difficulty__c = 'Hard',
                                   RecordTypeId = RecordTypeIdHabit,
            					   Employee__c = employeeId);
        tasks.add(taskHabit);
        
        // Test for Habit type task (Points: -1 in batch apex )
        Task__c taskHabitNew = new Task__c(Name = 'Habit type task resetted',
                                   Description__c = 'Task Description',
                                   Status__c = 'New',
                                   Difficulty__c = 'Hard',
                                   RecordTypeId = RecordTypeIdHabit,             
            					   Employee__c = employeeId);
        tasks.add(taskHabitNew);        
        insert tasks;
        
        return tasks;
    }
}