public with sharing class WarehouseCalloutService {
	
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout = true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            List<Product2> addEquipment = new List<Product2>();
            WarehouseEquipmentResponse wqr = new WarehouseEquipmentResponse();
            List<WarehouseEquipmentResponse> parsedEquipment = wqr.parse(response.getBody());
            for(WarehouseEquipmentResponse r :parsedEquipment){
                Product2 thisProduct = new Product2(
                	Warehouse_SKU__c = r.sku,
                    Maintenance_Cycle__c = r.maintenanceperiod,
                    Cost__c = r.cost,
                    Lifespan_Months__c = r.lifespan,
                    Name = r.name,
                    Current_Inventory__c = r.quantity,
                    Replacement_Part__c = r.replacement                    
                );
             addEquipment.add(thisProduct);
            }
            upsert addEquipment;
        }
    }
}