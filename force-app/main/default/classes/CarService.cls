public with sharing class CarService {    
    public static List<Decimal> getYears() {
        Set<Decimal> years = new Set<Decimal>();
        
        List<Product2> cars = [SELECT Year_of_Manufacture__c FROM Product2 ORDER BY Year_of_Manufacture__c];
        
        for(Product2 car : cars) {
            years.add(car.Year_of_Manufacture__c);
        }
        
        return new List<Decimal>(years);
    }
    public static List<String> getBrands(Decimal year) {
        Set<String> brands = new Set<String>();
        
        List<Product2> cars = [SELECT Brand__c FROM Product2 WHERE Year_of_Manufacture__c =:year];
        
        for(Product2 car : cars) {
            brands.add(car.Brand__c);
        }
        
        return new List<String>(brands);
    }
    public static List<String> getModels(Decimal year, String Brand) {
        Set<String> models = new Set<String>();
        
        List<Product2> cars = [SELECT Model__c FROM Product2 WHERE Brand__c =:Brand AND Year_of_Manufacture__c =:year];
        
        for(Product2 car : cars) {
            models.add(car.Model__c);
        }
        
        return new List<String>(models);
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getCars(Decimal year, String Brand, String Model) {

        Set<String> names = new Set<String>();
        
        List<Product2> cars = [SELECT Name FROM Product2 WHERE Brand__c =:Brand AND Model__c =:Model AND Year_of_Manufacture__c =:year];
        
        for(Product2 car : cars) {
            names.add(car.Name);
        }
        
        return new List<String>(names);
    }
    @AuraEnabled(cacheable=true)
    public static Product2 getCar(Decimal year, String brand, String model, String name) {
        
        return [SELECT Id, Name,Brand__c,Model__c,Sale_Price__c,Seating_Capacity__c,Engine_Power__c,Fuel_Type__c,Range__c, Safety_Rating__c,	Top_Speed__c,	Torque_Nm__c,Transmission_Type__c,Weight_Kg__c
         FROM Product2 WHERE Brand__c =:brand AND Model__c =:model AND Year_of_Manufacture__c =:year AND Name =:name LIMIT 1];
        
    }
}