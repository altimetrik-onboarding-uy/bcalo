public class TaskWithStatusController {

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