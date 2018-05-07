global class DailyTaskCalculation implements Database.Batchable<Contact> {
    global Iterable<Contact> start(Database.BatchableContext bc) {
        Id dailyRecordType = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='Daily'].Id; 
        Id habitRecordType = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='Habit'].Id;
        return [select Id, Total_Earned_Points__c, 
               (select Id, Status__c, Points_Award__c 
                from Tasks__r 
                where RecordTypeId=:dailyRecordType or RecordTypeId=:habitRecordType) 
                from Contact];
    }

    global void execute(Database.BatchableContext bc, List<Contact> records) {
        List<Contact> contactToUpdate = new List<Contact>();
        List<Task__c> taskToUpdate = new List<Task__c>();
        for(Contact contact : records) {
            Double pointsToAssign = 0.0;
            for(Task__c task : contact.Tasks__r) {
                if(task.Status__c == 'Completed') {
                    pointsToAssign += task.Points_Award__c;
                }
                else {
                    pointsToAssign -= task.Points_Award__c;
                }
                task.Status__c = 'New';
                taskToUpdate.add(task);
            }
            contact.Total_Earned_Points__c += pointsToAssign;
            contactToUpdate.add(contact);
        }
        update taskToUpdate;
        update contactToUpdate;
    }

    global void finish(Database.BatchableContext bc) {

    }

}