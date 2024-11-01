public with sharing class SmartCarController {
    @AuraEnabled(cacheable=true)
    public static Vehicle getMyVehicle(){
        try {
            return SmartCarService.getVehicle();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Location getCarLocation(String id){
        if(id == null || String.isEmpty(id.trim())){
            throw new IllegalArgumentException('Invalid id');
        }
        try {
            return SmartCarService.getLocation(id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}