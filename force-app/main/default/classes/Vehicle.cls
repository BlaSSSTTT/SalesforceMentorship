public class Vehicle {
    @AuraEnabled public String id{get;set;}
    @AuraEnabled public String make{get;set;}
    @AuraEnabled public String model{get;set;}
    @AuraEnabled public Decimal year{get;set;}
    @AuraEnabled public BatteryInfo batteryInfo{get;set;}
    @AuraEnabled public DistanceInfo distanceInfo{get;set;}
    @AuraEnabled public TirePressure tirePressure{get;set;}
    @AuraEnabled public String description{get;set;}
}