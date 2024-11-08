public with sharing class CarController {
    @AuraEnabled(cacheable=true)
    public static List<Decimal> getYears() {
        try{
            return CarService.getYears();
        }catch(Exception e){
            throw new AuraHandledException('Failed to get years: ' + e.getMessage());
        }
        
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getBrands(Decimal year) {
        if(year == null){
            throw new AuraHandledException('Given data can`t be empty');
        }
        try{    
            return CarService.getBrands(year);
        }catch(Exception e){
            throw new AuraHandledException('Failed to get brands: ' + e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getModels(Decimal year, String Brand) {
        if(year == null || Brand == null || String.isEmpty(Brand.trim())){
            throw new AuraHandledException('Given data can`t be empty');
        }
        try{
            return CarService.getModels(year, Brand);
        }catch(Exception e){
            throw new AuraHandledException('Failed to get models: ' + e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getCars(Decimal year, String Brand, String Model) {
        if(year == null || Brand == null || Model == null  || String.isEmpty(Brand.trim()) || String.isEmpty(Model.trim())){
            throw new AuraHandledException('Given data can`t be empty');
        }
        try{
            return CarService.getCars(year, Brand, Model);
        }catch(Exception e){
            throw new AuraHandledException('Failed to get car`s names: ' + e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Product2 getCar(Decimal year, String brand, String model, String name) {
        if(year == null || Brand == null || Model == null || name == null 
        || String.isEmpty(brand.trim()) || String.isEmpty(model.trim()) || String.isEmpty(name.trim())){
            throw new AuraHandledException('Given data can`t be empty');
        }
        try{            
            return CarService.getCar(year, Brand, Model, name);
        }catch(Exception e){
            throw new AuraHandledException('Failed to get car: ' + e.getMessage());
        }
        
    }
}