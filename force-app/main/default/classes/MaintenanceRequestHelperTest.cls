@isTest
public with sharing class MaintenanceRequestHelperTest {
    @TestSetup
    static void makeData(){
        Vehicle__c vehicle = new Vehicle__c();
        insert vehicle;
        list<Case> cases = new List<Case>();
        List<Product2> products = new List<Product2>();
        Products.add(new Product2());
        List<Equipment_Maintenance_Item__c> equipmentItems = new List<Equipment_Maintenance_Item__c>();
        for (integer i=0; i< 300; i++){
            cases.add(new Case(Type = 'Routine Maintenance',
                                Status = 'New',
                                Origin = 'Phone',
                                Vehicle__c = vehicle.Id,
                                Subject = 'SomeSubject',
                                Date_Reported__c = Date.today()));
        }
        insert cases;

        for (integer i=0; i< 300; i++){
            products.add(new Product2(Name = 'Product '+i,
                                        Replacement_Part__c = true));
        }
        insert products;
        
        for (integer i=0; i< 300; i++){
            equipmentItems.add(new Equipment_Maintenance_Item__c(
                                        Equipment__c = products[i].Id,
                                        Maintenance_Request__c = cases[i].Id));
        }
        insert equipmentItems;
    }
    @isTest public static void test(){
        List<Case> casesBefore = new List<Case>();
        for(Case c : [SELECT Id FROM Case]){
            c.Status = 'Closed';
            casesBefore.add(c);
        }
        update casesBefore;
        List<Case> casesAfter = [SELECT Id, Vehicle__c, (select Id from Equipment_Maintenance_Items__r) 
                            FROM Case WHERE status = 'New'];
        for(Case c : casesAfter){
            System.assertEquals(300, casesAfter.size());
            System.assertEquals(1, c.Equipment_Maintenance_Items__r.size());
            System.assertNotEquals(null, c.Vehicle__c);
        }
    }
}