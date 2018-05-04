trigger AddToDoPointsToContact on Task__c (before insert, before update) {
    List<Contact> toUpdate = new List<Contact>();
    //Id toDoId = Schema.SObjectType.Task__c.getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
    Id toDoId = [Select Id from RecordType where SobjectType='Task__c' and DeveloperName='TO_DO'].Id;
    for(Task__c task : Trigger.New) {
        if(task.RecordTypeId == toDoId && task.Status__c == 'Completed') {
            Contact contact = [select id, Total_Earned_Points__c from Contact where Id=: task.Contact__c];
            if(task.Due_Date__c >= System.now()) {
                contact.Total_Earned_Points__c += task.Points_Award__c;
                
            }
            else {
                contact.Total_Earned_Points__c += task.Points_Award__c/2;
            }
            toUpdate.add(contact);
        }
    }
    if(toUpdate.size()>0) {
        update toUpdate;
    }

}