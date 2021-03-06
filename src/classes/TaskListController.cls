public class TaskListController {


    @AuraEnabled
    public static List<Task__c> getContactTaskByType(Id contactId, String type) {
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SobjectType='Task__c' and Name =: type].Id;
        if(type == 'Habit') {
            return [SELECT Id, Name, Status__c, Points_Award__c, Contact__c 
                    FROM Task__c 
                    WHERE contact__c =: contactId AND RecordTypeId =: recordTypeId];
        } else {
            return [SELECT Id, Name, Status__c, Points_Award__c 
                    FROM Task__c 
                    WHERE contact__c =: contactId AND RecordTypeId =: recordTypeId AND Status__c != 'Completed'];
        }
    }

    @AuraEnabled
    public static Task__c updateTask(Task__c task) {
        update task;
        return task;
    }

     @AuraEnabled
    public static List<String> getStatusFieldValues() {
        List<String> statusValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry value : values) {
            statusValues.add(value.getLabel());
        }
        return statusValues;
    }
    
}