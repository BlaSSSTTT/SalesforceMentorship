public with sharing class CarController {
    @AuraEnabled(cacheable=true)
    public static List<Decimal> getYears() {
        try{
            List<Decimal> years = CarService.getYears();
            return years;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getBrands(Decimal year) {
        try{
            if(year == null){
                return null;
            }
            List<String> brands = CarService.getBrands(year);
            return brands;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getModels(Decimal year, String Brand) {
        try{
            if(year == null || Brand == null){
                return null;
            }
            List<String> model = CarService.getModels(year, Brand);
            return model;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getCars(Decimal year, String Brand, String Model) {
        try{
            if(year == null || Brand == null || Model == null){
                return null;
            }
            List<String> cars = CarService.getCars(year, Brand, Model);
            return cars;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled(cacheable=true)
    public static Product2 getCar(Decimal year, String brand, String model, String name) {
        try{
            if(year == null || Brand == null || Model == null || name == null){
                return null;
            }
            Product2 car = CarService.getCar(year, Brand, Model, name);
            return car;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return null;
        
    }
}