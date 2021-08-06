@IsTest
public class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @TestSetup
    static void makeData(){
        Product2 equipment = new Product2(Name = 'G');
        insert equipment;
    }
    @isTest static void testGetCallout(){
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        string updatedEquipmentName = 'Generator 1000 kW';
        System.enqueueJob(new WarehouseCalloutService());
        test.StopTest();
        system.assert([select Name from Product2][1].get('Name') == updatedEquipmentName);
    }

}