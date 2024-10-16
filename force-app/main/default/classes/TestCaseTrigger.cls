@isTest
private class TestCaseTrigger {

    @testSetup
    static void setupTestData() {
        List<Product2> cars = new List<Product2>();
        cars.add(new Product2(Name = 'Car A', VIN_Number__c = '12345', Brand__c = '1', Model__c='1', Condition__c='New', Mileage__c=0));
        cars.add(new Product2(Name = 'Car B', VIN_Number__c = '67890', Brand__c = '1', Model__c='1', Condition__c='New', Mileage__c=0));
        insert cars;
    }
    
    @isTest
    static void testAfterInsertFromEmail() {
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(Subject = 'Issue with VIN-12345', SuppliedEmail = 'test@example.com', Origin = 'Email'));
        caseList.add(new Case(Subject = 'General Issue', SuppliedEmail = '', Origin = 'Email'));
        insert caseList;

        List<Car_Service__c> services = [SELECT Id, Name, Car__c, Case__c, Date__c FROM Car_Service__c];
        System.assertEquals(1, services.size(), 'One Car_Service__c record should be created for the email case with VIN.');
        System.assertEquals('Issue with VIN-12345 12345', services[0].Name, 'Checking the name of the service record.');
    }

    @isTest
    static void testAfterInsertFromWeb() {
        Case webCase = new Case(Subject = 'Service Request', Origin = 'Web Car Service', Car_Vin_Code__c = '67890', SuppliedEmail = 'customer@example.com');
        insert webCase;

        List<Car_Service__c> services = [SELECT Id, Name, Car__c, Case__c, Date__c FROM Car_Service__c WHERE Case__c = :webCase.Id];
        System.assertEquals(1, services.size(), 'One Car_Service__c record should be created for the web case.');
    }

    @isTest
    static void testNoCarServiceRecordForNonVinCase() {
        Case caseWithoutVin = new Case(Subject = 'General Case', SuppliedEmail = 'customer@example.com', Origin = 'Email');
        insert caseWithoutVin;

        List<Car_Service__c> services = [SELECT Id FROM Car_Service__c WHERE Case__c = :caseWithoutVin.Id];
        System.assertEquals(0, services.size(), 'No Car_Service__c record should be created for a case without a VIN.');
    }
}
