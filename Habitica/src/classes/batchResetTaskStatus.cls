global class batchResetTaskStatus implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<Id, List<Task__c>> employeeTasksUncompleted = new Map<Id, List<Task__c>>();
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Name, (SELECT Id, Name, Status__c, Description__c, RecordTypeName__c FROM Contact.Tasks__r '+
            		   'WHERE RecordTypeName__c = \'Daily\' OR RecordTypeName__c = \'Habit\') '+
            		   'FROM Contact WHERE Id IN (SELECT Employee__c FROM Task__c ' +
            		   'WHERE RecordTypeName__c = \'Daily\' OR RecordTypeName__c = \'Habit\')';        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        List<Task__c> generalTaskList = new List<Task__c>();        
        for(Contact employee : scope)
        {
            List<Task__c> tasksUncompletedList = new List<Task__c>();
            for(Task__c task : employee.Tasks__r) {
                if ((task.Status__c == 'New' || task.Status__c == 'In Progress') & task.RecordTypeName__c == 'Daily') {
                    tasksUncompletedList.add(task);
                }                
                task.Status__c = 'New';
                generalTaskList.add(task);
            }
            
            if (tasksUncompletedList.size() > 0) {
                employeeTasksUncompleted.put(employee.Id, tasksUncompletedList);
            }            
        }
        
        try{
            update generalTaskList;
        } catch (DMLException e){
            System.debug('There was a problem resetting the tasks status');
        }
               
    } 
    
    global void finish(Database.BatchableContext BC)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Id employeeId : employeeTasksUncompleted.keySet()) {
            Contact employee = [SELECT Id, Email FROM Contact WHERE Id = :employeeId];
            if (!String.isBlank(employee.Email)) {                
                Messaging.singleEmailMessage message = new Messaging.singleEmailMessage();
                message.toAddresses = new String[] { employee.Email };
                message.subject = 'Incompleted Daily tasks on the Habitica Web Site';
                String htmlBody = '<body><h3>Uncompleted tasks:</h3><hr><ul>';                       
                for (Task__c task : employeeTasksUncompleted.get(employeeId)) {
                    String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + task.Id;
                    if (!String.isBlank(task.Description__c)) {
                    	htmlBody += '<li><a href="'+ baseUrl +'">'+ task.Name +'</a>: '+ task.Description__c +'</li>';
                    }
                    else {
                        htmlBody += '<li><a href="'+ baseUrl +'">'+ task.Name +'</a></li>';
                    }
                }
                htmlBody += '</ul></body>';
                message.setHtmlBody(htmlBody);
                mails.add(message); 
            }
        }
        
        if(mails.size() > 0) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
            System.debug(results);
        }        
    }
}