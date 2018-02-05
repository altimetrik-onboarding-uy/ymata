public class TaskPointCalculationUtil {
    static final String taskCompleted = 'Completed';
    static final String taskTODO = 'TO-DO';
    static final String taskDaily = 'Daily';
    static final String taskHabit = 'Habit';
    
    public static void updateEmployeeAwaredPoints(Task__c task, Task__c oldValue, Boolean actionInsert) {  
        RecordType rt = [SELECT Name FROM RecordType WHERE Id = :task.RecordTypeId Limit 1];
        Contact employee = [select Name, Total_Points_Calculated__c from Contact where id = :task.Employee__c Limit 1];
        if (employee.Total_Points_Calculated__c == null) {
            employee.Total_Points_Calculated__c = 0;
        }
        
        if ((actionInsert && task.Status__c.equals(taskCompleted)) || 
            (oldValue != null && (task.Status__c.equals(taskCompleted) && !oldValue.Status__c.equals(taskCompleted)))) {
            if (rt.Name.equals(taskTODO)) {
                updateEmployeeAwardedPointsTaskToDo(task, employee);
            }
            else if (rt.Name.equals(taskDaily) || rt.Name.equals(taskHabit)) {
                employee.Total_Points_Calculated__c += task.Award_Points__c;
            }
        }
        else if (!actionInsert && oldValue != null && !oldValue.Status__c.equals(taskCompleted) 
                 && !task.Status__c.equals(taskCompleted) && System.isBatch()) {
            if (rt.Name.equals(taskDaily) || rt.Name.equals(taskHabit)) {
                employee.Total_Points_Calculated__c -= task.Award_Points__c;
            }
        }
        try{
            update employee;            
        } catch (DMLException e){              
            System.debug('There was a problem updating the employees points');
        }                        
    }
    
    private static void updateEmployeeAwardedPointsTaskToDo(Task__c task, Contact employee) {
        if (task.Due_Date__c != null) {
            Integer daysBeforeDueDate = task.Due_Date__c.daysBetween(Date.today());
            if (daysBeforeDueDate <= 0) {   
                employee.Total_Points_Calculated__c += task.Award_Points__c;                    
            }
            else {
                employee.Total_Points_Calculated__c -= (task.Award_Points__c / 2);
            }
        }
        else {
            employee.Total_Points_Calculated__c += task.Award_Points__c;
        }
    }
}