public with sharing class SmartCarService {
    private static String getVehicleId(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SmartCar_Cred/vehicles');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            List<Object> vehicles = (List<Object>) jsonResponse.get('vehicles');

            if (!vehicles.isEmpty()) {
                System.debug(vehicles[0]);
                return (String)vehicles[0];
            }else{
                throw new SearchException('У вас немає машин');
            } 
        } else {
            throw new CalloutException('Помилка: ' + response.getStatus());
        }
    }
    public static Vehicle getVehicle(){
        try{
            String id = getVehicleId();

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SmartCar_Cred/vehicles/' + id);
            req.setMethod('GET');

            Http http = new Http();
            HTTPResponse response = http.send(req);
            //if(response.getStatusCode() != 200){throw new CalloutException('Помилка: ' + response.getStatus());}

            String jsonResponsee = response.getBody();
            Vehicle vehicle = (Vehicle) JSON.deserialize(jsonResponsee, Vehicle.class);
       
            vehicle.BatteryInfo =  getBattery(id);
            vehicle.DistanceInfo = getOdometer(id);
            vehicle.TirePressure = getTirePressure(id);

            return vehicle;
        }catch(Exception e){
            Vehicle vehicle = new Vehicle();
            vehicle.description = e.getMessage();
            return vehicle;
        }
    }
    private static BatteryInfo getBattery(String id){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SmartCar_Cred/vehicles/' + id +'/battery');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String jsonResponsee = response.getBody();
        BatteryInfo batteryInfo = (BatteryInfo) JSON.deserialize(jsonResponsee, BatteryInfo.class);
        return batteryInfo;
    }
    public static Location getLocation(String id){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SmartCar_Cred/vehicles/' + id + '/location');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String jsonResponsee = response.getBody();
        Location location = (Location) JSON.deserialize(jsonResponsee, Location.class);
        return location;
    }
    private static DistanceInfo getOdometer(String id){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SmartCar_Cred/vehicles/' + id + '/odometer');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String jsonResponsee = response.getBody();
        DistanceInfo distanceInfo = (DistanceInfo) JSON.deserialize(jsonResponsee, DistanceInfo.class);
        return distanceInfo;
    }
    private static TirePressure getTirePressure(String id){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SmartCar_Cred/vehicles/' + id + '/tires/pressure');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String jsonResponsee = response.getBody();
        TirePressure tirePressure = (TirePressure) JSON.deserialize(jsonResponsee, TirePressure.class);
        return tirePressure;
    }
 }