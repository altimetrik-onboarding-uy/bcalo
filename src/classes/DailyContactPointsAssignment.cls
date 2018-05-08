global class DailyContactPointsAssignment implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new DailyTaskCalculation());
    }
}