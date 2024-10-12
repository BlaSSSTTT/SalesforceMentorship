@isTest
private class TestPlannedSalesTrigger {

    @isTest
    static void singleCarTest() {
        Account account = new Account(
            Name = 'Test',
            BillingStreet = '123 Main St',
            BillingCity = 'Test City',
            BillingState = 'CA',
            BillingPostalCode = '12345',
            BillingCountry = 'USA'
        );
        insert account;
        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = Date.newInstance(2022, 1 , 1), StageName = 'Prospecting', Pricebook2Id = Test.getStandardPricebookId(), AccountId = account.Id);
        insert opp;

        Product2 car = new Product2(Name = 'New', Condition__c = 'New', Brand__c = 'Mercedes', Model__c = 'x', Final_Sale_Price__c = 10000, Mileage__c=0, VIN_Number__c='werwere');
        insert car;

        PricebookEntry pbe = new PricebookEntry(Product2Id = car.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 10000, IsActive = true);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, UnitPrice = 10000, Quantity = 1, PricebookEntryId = pbe.Id, Product2Id = car.id);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;

        Planned_Sales__c ps = new Planned_Sales__c(Name = 'Test', Car_Type__c = 'New', Month__c = 1, Year__c = 2022, Total_Amount_Earned__c = 0, Count_of_Cars_Sold__c = 0);
        
       
        Test.startTest();
        insert ps;
        Test.stopTest();

        ps = [SELECT Id, Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Id = :ps.Id];

        System.Assert.areEqual(1, ps.Count_of_Cars_Sold__c);
        System.Assert.areEqual(10000, ps.Total_Amount_Earned__c);
    }
    @isTest
    static void OpportunityNotClosedWonTest() {
        Account account = new Account(Name = 'Test', BillingStreet = '123 Main St', BillingCity = 'Test City', BillingState = 'CA', BillingPostalCode = '12345', BillingCountry = 'USA');
        insert account;

        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = Date.newInstance(2022, 1 , 1), StageName = 'Negotiation', Pricebook2Id = Test.getStandardPricebookId(), AccountId = account.Id);
        insert opp;

        Product2 car = new Product2(Name = 'New', Condition__c = 'New', Brand__c = 'Mercedes', Model__c = 'x', Final_Sale_Price__c = 10000, Mileage__c=0, VIN_Number__c='werwere');
        insert car;

        PricebookEntry pbe = new PricebookEntry(Product2Id = car.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 10000, IsActive = true);
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, UnitPrice = 10000, Quantity = 1, PricebookEntryId = pbe.Id, Product2Id = car.id);
        insert oli;

        
        opp.StageName = 'Closed Lost';  
        update opp;
        Planned_Sales__c ps = new Planned_Sales__c(Name = 'Test', Car_Type__c = 'New', Month__c = 1, Year__c = 2022, Total_Amount_Earned__c = 0, Count_of_Cars_Sold__c = 0);
               
        Test.startTest();
            insert ps; 
        Test.stopTest();
        ps = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Id = :ps.Id];
        System.Assert.areEqual(0, ps.Count_of_Cars_Sold__c);
        System.Assert.areEqual(0, ps.Total_Amount_Earned__c);
    }
    @isTest
    static void MultipleCarsSameMonthTest() {
        

        Account account = new Account(Name = 'Test Account', BillingStreet = '123 Main St', BillingCity = 'Test City', BillingState = 'CA', BillingPostalCode = '12345', BillingCountry = 'USA');
        insert account;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.newInstance(2022, 1 , 1), StageName = 'Prospecting', Pricebook2Id = Test.getStandardPricebookId(), AccountId = account.Id);
        insert opp;

        Product2 car1 = new Product2(Name = 'New Car 1', Condition__c = 'New', Brand__c = 'BMW', Model__c = 'X1', Final_Sale_Price__c = 30000, Mileage__c = 0, VIN_Number__c = 'VIN123');
        Product2 car2 = new Product2(Name = 'New Car 2', Condition__c = 'New', Brand__c = 'Audi', Model__c = 'Q3', Final_Sale_Price__c = 40000, Mileage__c = 0, VIN_Number__c = 'VIN456');
        insert new List<Product2> {car1, car2};

        PricebookEntry pbe1 = new PricebookEntry(Product2Id = car1.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 30000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = car2.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 40000, IsActive = true);
        insert new List<PricebookEntry> {pbe1, pbe2};

        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, UnitPrice = 30000, Quantity = 1, PricebookEntryId = pbe1.Id, Product2Id = car1.Id);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, UnitPrice = 40000, Quantity = 1, PricebookEntryId = pbe2.Id, Product2Id = car2.Id);
        insert new List<OpportunityLineItem> {oli1, oli2};

        
        opp.StageName = 'Closed Won';
        update opp;
        
        
        Planned_Sales__c ps = new Planned_Sales__c(Name = 'Test', Car_Type__c = 'New', Month__c = 1, Year__c = 2022, Total_Amount_Earned__c = 0, Count_of_Cars_Sold__c = 0);
        
        Test.startTest();
        insert ps;
        Test.stopTest();
        ps = [SELECT Count_of_Cars_Sold__c, Total_Amount_Earned__c FROM Planned_Sales__c WHERE Id = :ps.Id];
        
        System.Assert.areEqual(2, ps.Count_of_Cars_Sold__c);
        System.Assert.areEqual(70000, ps.Total_Amount_Earned__c);  // 30000 + 40000 = 70000
    }
}