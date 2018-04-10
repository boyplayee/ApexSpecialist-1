@isTest
public class MaintainanceRequestTriggerTest {
    
    public static final Integer maintenanceRequestCount = 300;
    public static final Integer negMaintenanceRequestCount = 10;
    
	@isTest
    static void TestTriggerFires() {
        // get contact we're using for testing
        Contact testContact = [SELECT Id FROM Contact WHERE FirstName = 'Test' and LastName = 'Request' and AccountId = '0011I00000C3hA0'];
        
        // get the maintenance requests we created and close them
        List<Case> testRequests = GetTestRequestsBeforeUpdate(testContact);
        for (Case c :testRequests){
            c.Status = 'Closed';
        }
        
        // we'll use date to help find our new maintenance requests
        DateTime saveDate = Date.today();
        
        Test.startTest();       
        update testRequests;        
        Test.stopTest();
        
        List<Case> testRequestsAfterUpdate = GetTestRequestsAfterUpdate(saveDate);
        System.assertEquals(300, testRequestsAfterUpdate.size());
        
        List<Case> badRequests = new List<Case>();
        for(Case after :testRequestsAfterUpdate)
        {
            if ((after.Vehicle__c != 'a001I000004OIqC') || (after.Equipment__c != '01t1I000001KHsWQAW') || (after.Date_Due__c != Date.Today().addDays(45))){
                badRequests.add(after);
            }
        }
        
		System.assertEquals(0, badRequests.size());        
        
    }
    
    @isTest
    static void TestTriggerNotFires() {
        // get contact we're using for testing
        Contact testContact = [SELECT Id FROM Contact WHERE FirstName = 'Test' and LastName = 'Request' and AccountId = '0011I00000C3hA0'];
        
        // get the maintenance requests we created and close them
        List<Case> testRequests = GetTestRequestsBeforeUpdate(testContact);
        for (Case c :testRequests){
            c.Status = 'Closed';
        }
        
        // we'll use date to help find our new maintenance requests
        DateTime saveDate = Date.today();
        
        Test.startTest();       
        update testRequests;        
        Test.stopTest();
        
        List<Case> testRequestsAfterUpdate = GetTestRequestsAfterUpdate(saveDate);        
       	System.assertEquals(310, testRequests.size()); 
        System.assertEquals(300, testRequestsAfterUpdate.size());
    }
    
    @testsetup
    public static void initializeTestData() {
        CreateTestRequests(maintenanceRequestCount, negMaintenanceRequestCount);
    }
    
    public static void CreateTestRequests(Integer newRequestsCount, Integer newNegRequestsCount) {       
        Contact reqContact = new Contact(
        	FirstName = 'Test',
            LastName = 'Request',
            AccountId = '0011I00000C3hA0'
        );
        
        insert reqContact;

        List<Case> requestList = new List<Case>();
        for(Integer i = 0; i < newRequestsCount; i++) {
            requestList.add(new Case(
        	Priority = 'High',
            Status = 'Working',
            Vehicle__c = 'a001I000004OIqC',
            Subject = 'Test my trigger' + String.ValueOf(i),
            Equipment__c = '01t1I000001KHsWQAW',
            Type = 'Repair',
            ContactId = reqContact.id
            ));
        }
        
        for(Integer i = 0; i < newNegRequestsCount; i++) {
            requestList.add(new Case(
        	Priority = 'High',
            Status = 'Working',
            Vehicle__c = 'a001I000004OIqC',
            Subject = 'Test my trigger' + String.ValueOf(i),
            Equipment__c = '01t1I000001KHsWQAW',
            Type = 'Electrical',
            ContactId = reqContact.id
            ));
        }        
        
        Insert requestList;
    }
    
    public static List<Case> GetTestRequestsBeforeUpdate(Contact testContact)
    {
        List<Case> testRequestsBeforeUpdate = [SELECT Id, Status FROM Case WHERE Status = 'Working' AND ContactId = :testContact.Id];
        return testRequestsBeforeUpdate;               
    }
    
    public static List<Case> GetTestRequestsAfterUpdate(DateTime byDate)
    {
        List<Case> testRequestsAfterUpdate = [SELECT Id, Type, Subject, Equipment__c, Vehicle__c, Status, Date_Due__c FROM Case WHERE Status = 'New' and Subject = 'Future routine checkup' and CreatedDate >= :byDate];
        return testRequestsAfterUpdate;          
    }
}