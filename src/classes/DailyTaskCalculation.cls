global class DailyTaskCalculation implements Database.Batchable<Contact> {
    global Iterable<Contact> start(Database.BatchableContext bc) {
        Id dailyRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName='Daily'].Id;

        return [SELECT Id, Total_Earned_Points__c, (SELECT Id, Status__c, Points_Award__c 
                                                    FROM Tasks__r 
                                                    WHERE RecordTypeId =: dailyRecordType) 
                FROM Contact];
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