@isTest
public class AddToDoPointsToContactTest {

    private static Id toDoId = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
    private static Id dailyRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Daily'].Id; 

    @testSetup
    private static void onSetup() {
        Contact contact = new Contact(LastName='Test Contact');
        insert contact;
    }

    @isTest
    private static void taskUpdateToCompletedBeforeDueDateTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Task__c toDo = new Task__c(Status__c = 'New', Difficulty__c = 'Hard', Due_Date__c = System.now().addMinutes(1), Contact__c = contact.Id, RecordTypeId = toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(5.0, result.Total_Earned_Points__c);
    }

    @isTest
    private static void taskUpdateToCompletedAfterDueDateTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Task__c toDo = new Task__c(Status__c = 'New', Difficulty__c = 'Hard', Due_Date__c = System.now().addMinutes(-1), Contact__c = contact.Id, RecordTypeId = toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(2.5, result.Total_Earned_Points__c);
    }

    @isTest
    private static void taskCreateCompletedBeforeDueDateTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        Task__c toDo = new Task__c(Status__c = 'Completed', Difficulty__c = 'Trivial', Due_Date__c = System.now().addMinutes(1), Contact__c = contact.Id, RecordTypeId = toDoId);
        Database.SaveResult createResult = Database.insert(toDo);
        Test.stopTest();

        System.assert(createResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(1,result.Total_Earned_Points__c);

    }

    @isTest
    private static void taskCreateCompletedAfterDueDateTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        Task__c toDo = new Task__c(Status__c = 'Completed', Difficulty__c = 'Trivial', Due_Date__c = System.now().addMinutes(-1), Contact__c = contact.Id, RecordTypeId = toDoId);
        Database.SaveResult createResult = Database.insert(toDo);
        Test.stopTest();

        System.assert(createResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(0.5, result.Total_Earned_Points__c);

    }

     @isTest
    private static void dailyUpdateToCompleteTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Task__c dailyTask = new Task__c(Status__c = 'New', Difficulty__c = 'Hard', Contact__c = contact.Id, RecordTypeId = dailyRecordType);
        insert dailyTask;

        Test.startTest();
        dailyTask.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(dailyTask);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(0, result.Total_Earned_Points__c);
    }

    @isTest
    private static void dailyCreateInCompleteTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        Task__c dailyTask = new Task__c(Status__c = 'Completed', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = dailyRecordType);
        Database.SaveResult createResult = Database.insert(dailyTask);
        Test.stopTest();

        System.assert(createResult.isSuccess());

        Contact result = [SELECT Id, Total_Earned_Points__c FROM Contact WHERE id =: contact.Id];
        System.assertEquals(0, result.Total_Earned_Points__c);

    }

}