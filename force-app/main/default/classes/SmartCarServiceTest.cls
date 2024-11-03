@IsTest
private class SmartCarServiceTest {

    private class SmartCarHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);

            if (req.getEndpoint().endsWith('/vehicles')) {
                res.setBody('{"vehicles": ["9f8bdde4-4b36-4f4c-9c1e-49c2671c410b"]}');
            } else if (req.getEndpoint().contains('/battery')) {
                res.setBody('{"percentRemaining": 0.75, "range": 239.8}');
            } else if (req.getEndpoint().contains('/odometer')) {
                res.setBody('{"distance": 55079.55}');
            } else if (req.getEndpoint().contains('/tires/pressure')) {
                res.setBody('{"backLeft": 219.3, "backRight": 219.3, "frontLeft": 219.3, "frontRight": 219.3}');
            } else if (req.getEndpoint().contains('/location')) {
                res.setBody('{"latitude": 37.7749, "longitude": -122.4194}');
            }else if (req.getEndpoint().contains('/vehicles/9f8bdde4-4b36-4f4c-9c1e-49c2671c410b')) {
                res.setBody('{"make": "TESLA", "model": "Model 3", "year": 2022}');
            } else {
                res.setStatusCode(404);
                res.setBody('{"message": "Not found"}');
            }
            return res;
        }
    }

    @IsTest
    static void testGetVehicle() {
        Test.setMock(HttpCalloutMock.class, new SmartCarHttpMock());

        Vehicle vehicle = SmartCarService.getVehicle();
        System.debug(vehicle);
        System.assertNotEquals(null, vehicle, 'Vehicle should not be null');
        System.assertEquals('TESLA', vehicle.make, 'Vehicle make should be TESLA');
        System.assertEquals('Model 3', vehicle.model, 'Vehicle model should be Model 3');
        System.assertEquals(2022, vehicle.year, 'Vehicle year should be 2022');
        
        System.assertNotEquals(null, vehicle.batteryInfo, 'Battery info should not be null');
        System.assertEquals(0.75, vehicle.batteryInfo.percentRemaining, 'Battery percent remaining should be 0.75');
        System.assertEquals(239.8, vehicle.batteryInfo.range, 'Battery range should be 239.8');
        
        System.assertNotEquals(null, vehicle.distanceInfo, 'Distance info should not be null');
        System.assertEquals(55079.55, vehicle.distanceInfo.distance, 'Distance should be 55079.55');
        
        System.assertNotEquals(null, vehicle.tirePressure, 'Tire pressure should not be null');
        System.assertEquals(219.3, vehicle.tirePressure.backLeft, 'Back left tire pressure should be 219.3');
        System.assertEquals(219.3, vehicle.tirePressure.backRight, 'Back right tire pressure should be 219.3');
        System.assertEquals(219.3, vehicle.tirePressure.frontLeft, 'Front left tire pressure should be 219.3');
        System.assertEquals(219.3, vehicle.tirePressure.frontRight, 'Front right tire pressure should be 219.3');
    }


    private class SmartCarHttpMockNoVehicles implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().endsWith('/vehicles')) {
                res.setStatusCode(200);
                res.setBody('{"vehicles": []}');
            }
            return res;
        }
    }

    @IsTest
    public static void testGetVehicleNoVehicles() {
        Test.setMock(HttpCalloutMock.class, new SmartCarHttpMockNoVehicles());

        try {
            Vehicle vehicle = SmartCarService.getVehicle();
            System.assertEquals(null, vehicle.id, 'Vehicle should not be retrieved');
        } catch (Exception e) {
            System.assertEquals('У вас немає машин', e.getMessage(), 'Expected exception message for no vehicles');
        }
    }
}
