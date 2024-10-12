public with sharing class CarTriggerHandler {
    public static void SetCarNotActive(List<Product2> carsInTriggerContext){
        Set<Id> soldProductIds = new Set<Id>();
        for(Product2 car: carsInTriggerContext){
            if (car.Car_Status__c == 'Sold') {
                soldProductIds.add(car.Id);
            }
        }
        List<PricebookEntry> pricebookEntriesToUpdate = [
            SELECT Id, IsActive 
            FROM PricebookEntry 
            WHERE Product2Id IN :soldProductIds AND IsActive = true
        ];

        for (PricebookEntry pbe : pricebookEntriesToUpdate) {
            pbe.IsActive = false;
        }

        update pricebookEntriesToUpdate;
    }
}