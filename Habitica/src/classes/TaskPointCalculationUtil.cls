public class TaskPointCalculationUtil {
    static final String taskCompleted = 'Completed';
    static final String taskTODO = 'TO-DO';
    static final String taskDaily = 'Daily';
    static final String taskHabit = 'Habit';
    
    public static void updateEmployeeAwaredPoints(Task__c task, Task__c oldValue, Boolean areInserted) {
        if ((areInserted && task.Status__c.equals(taskCompleted)) || 
           ((oldValue.Status__c != task.Status__c ) && task.Status__c.equals(taskCompleted))) {
            RecordType rt = [SELECT Name FROM RecordType WHERE Id = :task.RecordTypeId Limit 1];
            Contact employee = [select Name, Total_Points_Calculated__c from Contact where id = :task.Employee__c Limit 1];
            if (employee.Total_Points_Calculated__c == null) {
                employee.Total_Points_Calculated__c = 0;
            }
            if (rt.Name.equals(taskTODO)) {
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
            else if (rt.Name.equals(taskDaily) || rt.Name.equals(taskHabit)) {
                if (task.CreatedDate.date().daysBetween(Date.today()) == 0) {
                    employee.Total_Points_Calculated__c += task.Award_Points__c;
                }
                else {
                    employee.Total_Points_Calculated__c -= task.Award_Points__c;
                }
            }           
            update employee;
        } 
    }
}