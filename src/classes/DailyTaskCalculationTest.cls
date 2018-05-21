@isTest
public class DailyTaskCalculationTest {

    private static Id dailyRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Daily'].Id; 
    private static Id habitRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Habit'].Id;
    private static Id toDoRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'TO_DO'].Id;

    @testSetup
    private static void onSetup() {
        Contact contact = new Contact(LastName='Test Contact', Email='bcalo@altimetrik.com');
        insert contact;
        
        List<Task__c> taskToCreate = new List<Task__c>();
        for(Integer i = 0; i<10; i++) {
            taskToCreate.add(new Task__c(Status__c='New', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = dailyRecordType));
            taskToCreate.add(new Task__c(Status__c = 'Completed', Difficulty__c = 'Hard', Contact__c = contact.Id, RecordTypeId = dailyRecordType));
            taskToCreate.add(new Task__c(Status__c = 'Completed', Difficulty__c = 'Hard', Contact__c = contact.Id, RecordTypeId = habitRecordType));
            taskToCreate.add(new Task__c(Status__c = 'In Progress', Difficulty__c = 'Hard', Contact__c = contact.Id, Due_Date__c = System.now(), RecordTypeId = toDoRecordType));
        }

        insert taskToCreate;
    }

    @isTest
    private static void executeDailyContactPointsAssignment() {
        Test.startTest();
        Database.executeBatch(new DailyTaskCalculation(), 1);
        Test.stopTest();

        Contact contactResult = [SELECT Id, Total_Earned_Points__c FROM Contact LIMIT 1];
        System.assertEquals(20.0, contactResult.Total_Earned_Points__c);

        List<Task__c> dailyMovedToNew = [SELECT Id FROM Task__c WHERE Status__c = 'New'];
        System.assertEquals(30, dailyMovedToNew.size());

        List<Task__c> toDoKeptInProgress = [SELECT Id FROM Task__c WHERE Status__c = 'In Progress'];
        System.assertEquals(10,toDoKeptInProgress.size());

        List<Task__c> habitNotUpdated = [SELECT Id FROM Task__c WHERE Status__c= 'Completed'];
        System.assertEquals(0,habitNotUpdated.size());

        List<EmailMessage> message = [SELECT Id, Subject, TextBody, ToAddress FROM EmailMessage LIMIT 1];
        System.assertEquals(1,message.size());
        System.assertEquals('Uncompleted Daily Tasks', message[0].Subject);
        System.assert(message[0].TextBody.indexOf('10') > -1);
        System.assert(message[0].TextBody.indexOf('Dear Test Contact') > -1);
        System.assertEquals('bcalo@altimetrik.com', message[0].ToAddress);
    }

}