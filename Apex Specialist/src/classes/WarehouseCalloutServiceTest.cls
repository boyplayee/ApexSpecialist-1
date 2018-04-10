@isTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest
    static void testGetWarehouseCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        
        List<Product2> updatedProducts = [SELECT Id, Warehouse_SKU__c, Maintenance_Cycle__c, Cost__c, Lifespan_Months__c, Name, Current_Inventory__c, Replacement_Part__c FROM Product2 WHERE Warehouse_SKU__c IN ('100080','100081','100082')];
        System.assertEquals(3, updatedProducts.size());
        List<CronTrigger> testTrigger = [SELECT Id, State, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.Name = 'WarehouseSyncJob'];
        System.assertEquals(1, testTrigger.size());
    }    
}