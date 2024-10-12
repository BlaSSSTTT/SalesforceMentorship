@isTest
private class TestOpportunityLineItemTrigger {

    @isTest
    static void testTriggerWithReservedCar() {
        Product2 reservedCar = new Product2(Name = 'Reserved Car', Car_Status__c = 'Reserved', Brand__c = '1', Model__c = '1',VIN_Number__c='12345', Condition__c='New',Mileage__c=0);
        insert reservedCar;

        Opportunity opportunity = new Opportunity(Name = 'Prospecting Opportunity', CloseDate = Date.today(), StageName = 'Prospecting', Pricebook2Id = Test.getStandardPricebookId());
        insert opportunity;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opportunity.Id, Product2Id = reservedCar.Id, UnitPrice = 10000, Quantity = 1);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(oli, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assertEquals('Warning! This Opportunity has reserved or sold cars. You are not able to move forward with it, until you remove those cars, or they are back available.', result.getErrors()[0].getMessage());
    }

    @isTest
    static void testTriggerWithAvailableCar() {
        Product2 availableCar = new Product2(Name = 'Available Car', Car_Status__c = 'Available', Brand__c = '1', Model__c = '1',VIN_Number__c='12345', Condition__c='New',Mileage__c=0);
        insert availableCar;

        Opportunity opportunity = new Opportunity(Name = 'Prospecting Opportunity', CloseDate = Date.today(), StageName = 'Prospecting', Pricebook2Id = Test.getStandardPricebookId());
        insert opportunity;
        PricebookEntry pbe = new PricebookEntry(Product2Id = availableCar.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 10000, IsActive = true);
        insert pbe;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opportunity.Id, Product2Id = availableCar.Id, PricebookEntryId = pbe.Id, UnitPrice = 10000, Quantity = 1);
        
        Test.startTest();
        insert oli;
        Test.stopTest();

        oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opportunity.Id];
        System.assertNotEquals(null, oli.Id);
    }
}