public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders() {
        // TODO: Complete the method to update workorders
        List<Case> cases = [select Status, Type, Id, Vehicle__c, 
                       (select Id, Equipment__r.Maintenance_Cycle__c 
                        from Equipment_Maintenance_Items__r
                        order by Equipment__r.Maintenance_Cycle__c) 
                        from Case where Id in :trigger.New];
    	List<Case> newCases = new List<Case>();
    	List<Equipment_Maintenance_Item__c> equipmentItems = new List<Equipment_Maintenance_Item__c>();
    	for (Case c : cases){
        if(c.Status == 'Closed' && 
        (c.Type == 'Repair' || c.Type == 'Routine Maintenance')){
            Case newCase = new Case(Type = 'Routine Maintenance',
                                    Status = 'New',
                                    Origin = 'Phone',
                                    Vehicle__c = c.Vehicle__c,
                                    Subject = 'SomeSubject',
                                    Date_Reported__c = Date.today());
            
            integer minMaintenanceCycle = (integer)(c.Equipment_Maintenance_Items__r[0].Equipment__r.Maintenance_Cycle__c == null 
                                                    ? 0 : c.Equipment_Maintenance_Items__r[0].Equipment__r.Maintenance_Cycle__c);
            newCase.Date_Due__c = newCase.Date_Reported__c.addDays(minMaintenanceCycle);
            newCases.add(newCase);
            
            
        }
    }
    insert newCases;
    for(Case c : newCases){
        for(Equipment_Maintenance_Item__c equipmentItem : cases[newCases.indexOf(c)].Equipment_Maintenance_Items__r){
                equipmentItem.Maintenance_Request__c = c.Id;
                equipmentItems.add(equipmentItem);
            }
    }
    update equipmentItems;
    }        
    
}