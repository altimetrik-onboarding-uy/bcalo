public class HabitTaskController {

    @AuraEnabled
    public static Task__c UpdateHabitTask(Task__c habit, Boolean achieved) {
        Contact contact = [SELECT Id, Total_Earned_Points__c
                           FROM Contact
                           WHERE Id =: habit.Contact__c];
        
        if(achieved) {
            contact.Total_Earned_Points__c += habit.Points_Award__c;        
        }
        else {
            contact.Total_Earned_Points__c -= habit.Points_Award__c;        
        }

        habit.Status__c = 'Completed';
        update habit;
        update contact;
        return habit;
    }

}