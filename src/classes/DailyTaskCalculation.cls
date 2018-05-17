global class DailyTaskCalculation implements Database.Batchable<Contact> {
    private Id dailyRecordType = [SELECT Id 
                                  FROM RecordType 
                                  WHERE SobjectType='Task__c' and DeveloperName='Daily'].Id;

    private Id habitRecordType = [SELECT Id 
                              FROM RecordType 
                              WHERE SobjectType='Task__c' and DeveloperName = 'Habit'].Id;

    global Iterable<Contact> start(Database.BatchableContext bc) {
        return [SELECT Id, Total_Earned_Points__c, (SELECT Id, Status__c, Points_Award__c, RecordTypeId 
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
            for(Task__c task : contact.Tasks__r) {
                if(task.RecordTypeId == dailyRecordType) {
                    if(task.Status__c == 'Completed') {
                        pointsToAssign += task.Points_Award__c;
                    }
                    else {
                        pointsToAssign -= task.Points_Award__c;
                    }
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