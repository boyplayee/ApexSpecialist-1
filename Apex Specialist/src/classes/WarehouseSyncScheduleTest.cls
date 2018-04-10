@isTest
private class WarehouseSyncScheduleTest {
    @isTest
    static void testScheduler() {
        String CRON_EXP = '0 0 1 * * ?';
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobId = System.schedule('testWarehouseSyncSchedule', CRON_EXP, new WarehouseSyncSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

		System.assertNotEquals(null, ct);     
    }
}