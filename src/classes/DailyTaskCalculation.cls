global class DailyTaskCalculation implements Database.Batchable<Contact>, Database.Stateful {
    private final Id dailyRecordType = [SELECT Id 
                                  FROM RecordType 
                                  WHERE SobjectType='Task__c' and DeveloperName='Daily'].Id;
    private final Id habitRecordType = [SELECT Id 
                              FROM RecordType 
                              WHERE SobjectType='Task__c' and DeveloperName = 'Habit'].Id;
    global Map<Contact,Integer> contactsToNotify;

    global DailyTaskCalculation() {
        contactsToNotify = new Map<Contact,Integer>();
    }

    global Iterable<Contact> start(Database.BatchableContext bc) {
        return [SELECT Id, Name, Email, Total_Earned_Points__c, (SELECT Id, Status__c, Points_Award__c, RecordTypeId 
                                                                 FROM Tasks__r 
                                                                 WHERE RecordTypeId =: dailyRecordType 
                                                                       OR RecordTypeId =: habitRecordType) 
                FROM Contact];
    }

    global void execute(Database.BatchableContext bc, List<Contact> records) {
        List<Contact> contactToUpdate = new List<Contact>();
        List<Task__c> taskToUpdate = new List<Task__c>();
        for(Contact contact : records) {
            Double pointsToAssign = 0.0;
            Integer dailyUncompleted = 0;
            for(Task__c task : contact.Tasks__r) {
                if(task.RecordTypeId == dailyRecordType) {
                    if(task.Status__c == 'Completed') {
                        pointsToAssign += task.Points_Award__c;
                    }
                    else {
                        pointsToAssign -= task.Points_Award__c;
                        dailyUncompleted++;
                    }
                }
                task.Status__c = 'New';
                taskToUpdate.add(task);
            }
            if(contact.Email != null && dailyUncompleted > 0) {
                contactsToNotify.put(contact, dailyUncompleted);
            }

            contact.Total_Earned_Points__c += pointsToAssign;
            contactToUpdate.add(contact);
        }
        update taskToUpdate;
        update contactToUpdate;
    }

    global void finish(Database.BatchableContext bc) {
        EmailTemplate template = [SELECT Id, Subject, Body
                                  FROM EmailTemplate
                                  WHERE DeveloperName='Daily_Email_Template'];
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for(Contact contact : contactsToNotify.keySet()) {
            Integer pendingTasks = contactsToNotify.get(contact);
            String subject = template.Subject;
            String body = template.Body;
            body = body.replace('{!Contact.Name}', contact.Name);
            body = body.replace('{!taskAmount}', pendingTasks.format());
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { contact.Email });
            email.setSubject(subject);
            email.setPlainTextBody(body);
            emailsToSend.add(email);
        }
        
        if(emailsToSend.size() > 0) {
            Messaging.sendEmail(emailsToSend);
        }
        
    }

}