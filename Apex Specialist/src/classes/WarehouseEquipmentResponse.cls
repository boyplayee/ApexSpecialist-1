public class WarehouseEquipmentResponse {
	public string id;
    public decimal cost;
    public decimal lifespan;
    public decimal maintenanceperiod;
    public string name;
    public decimal quantity;
    public boolean replacement;
    public string sku;
    
    public List<WarehouseEquipmentResponse> parse(String response) {
        return (List<WarehouseEquipmentResponse>)JSON.deserialize(response, List<WarehouseEquipmentResponse>.class);
    }
}