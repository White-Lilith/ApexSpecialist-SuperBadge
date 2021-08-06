public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    public static void execute(QueueableContext qc){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.262837836.1779026755.1624865411-1289941387.1624348990');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            List<Equipment> givenEquipments = (List<Equipment>)JSON.deserialize(response.getBody(), List<Equipment>.class);
            List<Product2> equipments = new List<Product2>();
            for(Equipment equipment : givenEquipments){
                equipments.add(new Product2(Id = equipment.id,
                                Name = equipment.name,
                                Replacement_Part__c = true,
                                QuantityUnitOfMeasure = equipment.quantity,
                                Cost__c = equipment.cost,
                                Maintenance_Cycle__c = equipment.maintenanceperiod,
                                Lifespan_Months__c = equipment.lifespan,
                                Warehouse_SKU__c = equipment.sku));
            }
            upsert equipments;
        }
    } 
}