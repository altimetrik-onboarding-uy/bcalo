@isTest
public class DailyContactPointsAssignmentTest {

    public static String CRON_EXP = '0 0 13 * * ?';

    @isTest
    private static void scheduleJobTest() {
        Test.startTest();
        String jobId = System.schedule('TestDailyContactPointsAssignment', CRON_EXP, new DailyContactPointsAssignment());
        Test.stopTest();
        System.assert(jobId != null);
    }
}