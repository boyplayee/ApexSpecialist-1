public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> addRequests){
        Set<Id> WorkPartIds = new Set<Id>();
        // get all the ids for the equipment to be serviced
        for (Case c: addRequests) {
            WorkPartIds.add(c.Equipment__c);         
        }
        
        // fetch equipment id with the shortest maintenance cycle
        Map<Id, AggregateResult> maintenanceCycles = New Map<Id, AggregateResult>([SELECT Id, MIN(Equipment__r.Maintenance_Cycle__c) MaintenanceCycle FROM Case WHERE Equipment__c <> null AND Equipment__r.Id IN :WorkPartIds GROUP BY Id]); 
        
        List<Case> casesToAdd = new List<Case>();        
        for (Case c: addRequests) {
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Equipment__c = c.Equipment__c;
            newCase.Date_Reported__c = Date.today();
            newCase.Status = 'New';
            newCase.Origin = 'Automated';
            newCase.Subject = 'Future routine checkup';
            sObject shortestCycle = maintenanceCycles.get(c.Id);
            if (shortestCycle != null){
            	Decimal daysToAddDecimal = (Decimal)shortestCycle.get('MaintenanceCycle');
            	Integer daysToAdd = daysToAddDecimal.intValue();
            	Date dueDate = Date.Today().addDays(daysToAdd); 
            	newCase.Date_Due__c = dueDate;               
            }

            casesToAdd.add(newCase);
        }
        insert casesToAdd;
    }        
    
}