@isTest
private class TestCarTrigger {

    @isTest
    static void testSetCarNotActiveWithSoldCar() {
        Product2 car = new Product2(Name = 'Car1', Car_Status__c = 'Available', Brand__c = '1', Model__c = '1',VIN_Number__c='12345', Condition__c='New',Mileage__c=0);
        insert car;
        
        PricebookEntry pbe = new PricebookEntry(Product2Id = car.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 10000, IsActive = true);
        insert pbe;
        
        Test.startTest();
        car.Car_Status__c = 'Sold';
        update car;
        Test.stopTest();

        PricebookEntry updatedPbe = [SELECT Id, IsActive FROM PricebookEntry WHERE Id = :pbe.Id];
        System.assertEquals(false, updatedPbe.IsActive);
    }
    
    @isTest
    static void testSetCarNotActiveWithNonSoldCar() {
        Product2 availableCar = new Product2(Name = 'Car2', Car_Status__c = 'Available', Brand__c = '1', Model__c = '1',VIN_Number__c='12345', Condition__c='New',Mileage__c=0);
        insert availableCar;

        PricebookEntry pbe = new PricebookEntry(Product2Id = availableCar.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 15000, IsActive = true);
        insert pbe;
        
        Test.startTest();

        availableCar.Car_Status__c = 'Reserved';
        update availableCar;
        Test.stopTest();

        PricebookEntry updatedPbe = [SELECT Id, IsActive FROM PricebookEntry WHERE Id = :pbe.Id];
        System.assertEquals(true, updatedPbe.IsActive);
    }
}