public with sharing class OpportunityLineItemTriggerHandler {
    public static void MarkReserverOrSoldCars(List<OpportunityLineItem> opportunityLineItems){
        Set<Id> carIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        for (OpportunityLineItem oli : opportunityLineItems) {
            carIds.add(oli.Product2Id);
            opportunityIds.add(oli.OpportunityId);           
        }
        Map<Id, Product2> carsMap = new Map<Id, Product2>([SELECT Car_Status__c, Name, Id FROM Product2 WHERE Id IN :carIds]);
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>([SELECT StageName, Id FROM Opportunity WHERE Id IN :opportunityIds]);
        for (OpportunityLineItem oli : opportunityLineItems) {
            Product2 car = carsMap.get(oli.Product2Id);
            Opportunity opp = opportunitiesMap.get(oli.OpportunityId);
            if((car.Car_Status__c =='Reserved' || car.Car_Status__c == 'Sold') ){
                oli.addError('Warning! This Opportunity has reserved or sold cars. You are not able to move forward with it, until you remove those cars, or they are back available.');
            }
           
        }
        
    }
}