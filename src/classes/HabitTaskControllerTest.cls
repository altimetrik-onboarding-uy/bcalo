@isTest
public class HabitTaskControllerTest {

    private static Id habitRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Habit'].Id;
    
    @testSetup
    private static void onSetup() {

        Contact contact = new Contact(LastName='Test Contact');
        insert contact;
        

        insert new Task__c(Name='Habit Test',Status__c='New', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = habitRecordType);
        
    }

    @isTest
    private static void updateHabitTaskPositiveTest() {
        Task__c habitTask = [SELECT Id, Status__c, Points_Award__c, Contact__c 
                             FROM Task__c 
                             LIMIT 1];

        Test.startTest();
        Task__c habitTasks = HabitTaskController.updateHabitTask(habitTask, true);
        Test.stopTest();

        Contact contact = [SELECT Id, Total_Earned_Points__c FROM Contact LIMIT 1];
        System.assertEquals('Completed', habitTasks.Status__c);
        System.assertEquals(1.0, contact.Total_Earned_Points__c);
    }

    @isTest
    private static void updateHabitTaskNegativeTest() {
        Task__c habitTask = [SELECT Id, Status__c, Points_Award__c, Contact__c 
                             FROM Task__c 
                             LIMIT 1];

        Test.startTest();
        Task__c habitTasks = HabitTaskController.updateHabitTask(habitTask, false);
        Test.stopTest();

        Contact contact = [SELECT Id, Total_Earned_Points__c FROM Contact LIMIT 1];
        System.assertEquals('Completed', habitTasks.Status__c);
        System.assertEquals(-1.0, contact.Total_Earned_Points__c);
    }
}