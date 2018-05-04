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
        Id toDoId = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Task__c toDo = new Task__c(Status__c='New', Difficulty__c='Hard', Due_Date__c=System.today()+1, Contact__c=contact.Id, RecordTypeId=toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        system.assertEquals(5.0,result.Total_Earned_Points__c);
    }

    @isTest
    private static void taskUpdateToCompletedAfterDueDateTest() {
        Contact contact = [select Id from Contact limit 1];
        Id toDoId = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        Task__c toDo = new Task__c(Status__c='New', Difficulty__c='Hard', Due_Date__c=System.today(), Contact__c=contact.Id, RecordTypeId=toDoId);
        insert toDo;

        Test.startTest();
        toDo.Status__c = 'Completed';
        Database.SaveResult updateResult = Database.update(toDo);
        Test.stopTest();

        System.assert(updateResult.isSuccess());

        Contact result = [select Id, Total_Earned_Points__c from Contact where id =: contact.Id];
        system.assertEquals(2.5,result.Total_Earned_Points__c);
    }


}