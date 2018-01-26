trigger TaskPointCalculation on Task__c (after insert, after update) {
    for(Task__c task : Trigger.New) {
        if (((Trigger.isInsert) || (Trigger.oldMap.get(task.Id).Status__c != task.Status__c )) && task.Status__c == 'Completed') {
            RecordType rt = [SELECT Name FROM RecordType WHERE Id = :task.RecordTypeId Limit 1];
            Contact employee = [select Name, Total_Points_Calculated__c from Contact where id = :task.Employee__c Limit 1];
            if (employee.Total_Points_Calculated__c == null) {
                employee.Total_Points_Calculated__c = 0;
            }
            if (rt.Name == 'TO-DO') {
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
            else if (rt.Name == 'Daily' || rt.Name == 'Habit') {
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