@isTest
public class TaskListControllerTest {

    private static Id dailyRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Daily'].Id; 
    private static Id habitRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'Habit'].Id;
    private static Id toDoRecordType = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and DeveloperName = 'TO_DO'].Id;

    @testSetup
    private static void onSetup() {
        Contact contact = new Contact(LastName='Test Contact');
        insert contact;
        
        List<Task__c> taskToCreate = new List<Task__c>();
        for(Integer i = 0; i<5; i++) {
            //Daily Task
            taskToCreate.add(new Task__c(Name='New Daily ' + i,Status__c='New', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = dailyRecordType));
            taskToCreate.add(new Task__c(Name='In Progress Daily ' + i,Status__c='In Progress', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = dailyRecordType));
            taskToCreate.add(new Task__c(Name='Completed Daily ' + i,Status__c = 'Completed', Difficulty__c = 'Hard', Contact__c = contact.Id, RecordTypeId = dailyRecordType));
            //Habit Tasks
            taskToCreate.add(new Task__c(Name='New Habit ' + i,Status__c='New', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = habitRecordType));
            taskToCreate.add(new Task__c(Name='In Progress Habit ' + i,Status__c='In Progress', Difficulty__c = 'Trivial', Contact__c = contact.Id, RecordTypeId = habitRecordType));
            taskToCreate.add(new Task__c(Name='Completed Habit ' + i,Status__c = 'Completed', Difficulty__c = 'Hard', Contact__c = contact.Id, RecordTypeId = habitRecordType));
            //TO-DO Tasks
            taskToCreate.add(new Task__c(Name='New TO-DO' + i,Status__c='New', Difficulty__c = 'Trivial', Contact__c = contact.Id, Due_Date__c = System.now(), RecordTypeId = toDoRecordType));
            taskToCreate.add(new Task__c(Name='In Progress TO-DO' + i,Status__c='In Progress', Difficulty__c = 'Trivial', Contact__c = contact.Id, Due_Date__c = System.now(), RecordTypeId = toDoRecordType));
           
        }
        insert taskToCreate;
    }

    @isTest
    private static void getContactHabitTasksTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        List<Task__c> habitTasks = TaskListController.getContactTaskByType(contact.Id,'Habit');
        Test.stopTest();

        System.assertEquals(15,habitTasks.size());

        for(Task__c task : habitTasks) {
            System.assert(task.Name.indexOf('Habit') > -1);
        }
       
    }

    @isTest
    private static void getContactDailyTasksTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        List<Task__c> dailyTasks = TaskListController.getContactTaskByType(contact.Id,'Daily');
        Test.stopTest();

        System.assertEquals(10,dailyTasks.size());

        for(Task__c task : dailyTasks) {
             System.assert(task.Name.indexOf('Daily') > -1);
             System.assertNotEquals('Completed', task.Status__c);
        }
    }

    @isTest
    private static void getContactToDoTasksTest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        List<Task__c> toDoTasks = TaskListController.getContactTaskByType(contact.Id,'TO-DO');
        Test.stopTest();

        System.assertEquals(10,toDoTasks.size());

        for(Task__c task : toDoTasks) {
             System.assert(task.Name.indexOf('TO-DO') > -1);
             System.assertNotEquals('Completed', task.Status__c);
        }
    }

    @isTest
    private static void updateTaskTest() {

        Task__c testTask = [SELECT Id, Status__c
                            FROM Task__c
                            LIMIT 1];

        Test.startTest();
        testTask.Status__c = 'Completed';
        Task__c resultTask = TaskListController.updateTask(testTask);
        Test.stopTest();

        System.assertEquals(testTask.Id, resultTask.Id);
        System.assertEquals('Completed',testTask.Status__c);

    }

     @isTest
    private static void getStatysFieldValuesTest() {
        Test.startTest();
        List<String> picklistValues = TaskListController.getStatusFieldValues();
        Test.stopTest();

        System.assert(picklistValues.contains('New'));
        System.assert(picklistValues.contains('In Progress'));
        System.assert(picklistValues.contains('Completed'));
    }
}