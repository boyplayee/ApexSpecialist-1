trigger MaintenanceRequest on Case (after update) {
    List<Case> updatedRequests = new List<Case>();
    for(Case c: Trigger.new) {
        if(c.Status == 'Closed' && (c.Type == 'Repair' || c.Type == 'Routine Maintenance')) {
            updatedRequests.add(c);
        }
    }
    MaintenanceRequestHelper.updateWorkOrders(updatedRequests);  
}