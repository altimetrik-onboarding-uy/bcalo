@isTest
public class AddToDoPointsToContactTest {

    @testSetup
    private static void onSetup() {
        Contact contact = new Contact(LastName='Test Contact');
        insert contact;
        
    }

    @isTest
    private static void taskUpdateToCompletedBeforeDueDateTest() {
        Contact contact = [select Id from Contact limit 1];
        //Id toDoId = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Id toDoId = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
        Task__c toDo = new Task__c(Status__c='New', Difficulty__c='Hard', Due_Date__c = System.now().addMinutes(1), Contact__c=contact.Id, RecordTypeId=toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        System.assertEquals(5.0,result.Total_Earned_Points__c);
    }

    @isTest
    private static void taskUpdateToCompletedAfterDueDateTest() {
        Contact contact = [select Id from Contact limit 1];
        //Id toDoId = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Id toDoId = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
        Task__c toDo = new Task__c(Status__c='New', Difficulty__c='Hard', Due_Date__c = System.now().addMinutes(-1), Contact__c=contact.Id, RecordTypeId=toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        System.assertEquals(2.5,result.Total_Earned_Points__c);
    }

    @isTest
    private static void taskCreateCompletedBeforeDueDateTest() {
        Contact contact = [select Id from Contact limit 1];
        Id toDoId = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
        
        Test.startTest();
        Task__c toDo = new Task__c(Status__c='Completed', Difficulty__c='Trivial', Due_Date__c = System.now().addMinutes(1), Contact__c=contact.Id, RecordTypeId=toDoId);
        Database.SaveResult createResult = Database.insert(toDo);
        Test.stopTest();

        System.assert(createResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        System.assertEquals(1,result.Total_Earned_Points__c);

    }

    @isTest
    private static void taskCreateCompletedAfterDueDateTest() {
        Contact contact = [select Id from Contact limit 1];
        Id toDoId = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
        
        Test.startTest();
        Task__c toDo = new Task__c(Status__c='Completed', Difficulty__c='Trivial', Due_Date__c = System.now().addMinutes(-1), Contact__c=contact.Id, RecordTypeId=toDoId);
        Database.SaveResult createResult = Database.insert(toDo);
        Test.stopTest();

        System.assert(createResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        System.assertEquals(0.5,result.Total_Earned_Points__c);

    }

}