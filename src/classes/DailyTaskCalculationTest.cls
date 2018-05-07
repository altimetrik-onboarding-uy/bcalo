@isTest
public class DailyTaskCalculationTest {

    private static Id dailyRecordType = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='Daily'].Id; 
    private static Id habitRecordType = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='Habit'].Id;
    private static Id toDoRecordType = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;

    @testSetup
    private static void onSetup() {
        Contact contact = new Contact(LastName='Test Contact');
        insert contact;
        
        List<Task__c> taskToCreate = new List<Task__c>();
        for(Integer i = 0; i<10; i++) {
            taskToCreate.add(new Task__c(Status__c='New', Difficulty__c='Trivial', Contact__c=contact.Id, RecordTypeId=dailyRecordType));
            taskToCreate.add(new Task__c(Status__c='Completed', Difficulty__c='Hard', Contact__c=contact.Id, RecordTypeId=dailyRecordType));
            taskToCreate.add(new Task__c(Status__c='New', Difficulty__c='Easy', Contact__c=contact.Id, RecordTypeId=habitRecordType));
            taskToCreate.add(new Task__c(Status__c='Completed', Difficulty__c='Hard', Contact__c=contact.Id, RecordTypeId=habitRecordType));
            taskToCreate.add(new Task__c(Status__c='In Progress', Difficulty__c='Hard', Contact__c=contact.Id, Due_Date__c = System.now(), RecordTypeId=toDoRecordType));
        }

        insert taskToCreate;
    }

    @isTest
    private static void executeDailyContactPointsAssignment() {
        Test.startTest();
        Database.executeBatch(new DailyTaskCalculation());
        Test.stopTest();

        Contact contactResult = [select Id, Total_Earned_Points__c from Contact limit 1];
        System.assertEquals(20.0, contactResult.Total_Earned_Points__c);

        List<Task__c> dailyHabitMovedToNew = [select Id from Task__c where Status__c = 'New'];
        System.assertEquals(40, dailyHabitMovedToNew.size());

        List<Task__c> toDoKeptInProgress = [select Id from Task__c where Status__c= 'In Progress'];
        System.assertEquals(10,toDoKeptInProgress.size());
    }

}