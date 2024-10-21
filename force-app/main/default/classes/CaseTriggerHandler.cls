public with sharing class CaseTriggerHandler extends TriggerHandler {
    public override void afterInsert(){
        List<Case> fromWeb = new List<Case>();
        List<Case> fromEmail = new List<Case>();
        for(Case case1 : (List<Case>)Trigger.new){
            if(case1.Origin == 'Web Car Service') {
                fromWeb.add(case1);
            }
            if(case1.Origin == 'Email') {
                fromEmail.add(case1);
            }
        }
        fromEmail(fromEmail);
        fromWeb(fromWeb);
    }
    public void fromEmail(List<Case> cases1){
        Map<String, Case> cases = new Map<String, Case>();
        Set<Id> casesId = new Set<Id>();
        for (Case caseRecord : cases1) {
            if(caseRecord.Subject.contains('VIN-')) {
                casesId.add(caseRecord.Id);
                String vinCode = caseRecord.Subject.substringAfterLast('VIN-');
                cases.put(vinCode, caseRecord);
            }
        }

        List<Product2> cars = [
            SELECT Id, VIN_Number__c FROM Product2 WHERE VIN_Number__c in :cases.keySet()
        ];
        
        if(cars.size() > 0) {
            
            List<Car_Service__c> services = new List<Car_Service__c>();
            Map<Id,Car_Service__c> servicesMap = new Map<Id,Car_Service__c>();
            for(Product2 car : cars) {
                Case case1 = cases.get(car.VIN_Number__c);
                Car_Service__c service = new Car_Service__c(Name = case1.subject+' '+car.VIN_Number__c);
                service.Car__c = car.Id;
                service.Case__c = case1.Id;
                service.Date__c =  Date.today();
                servicesMap.put(case1.Id, service);
                
                services.add(service);
            }
            insert services;

        }       
    }
    public void fromWeb(List<Case> cases){
        sendEmail(cases);
        createCarServices(cases);      
    }
    private void SendEmail(List<Case> cases){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [
            SELECT Id, Name, Subject, HtmlValue, Body 
            FROM EmailTemplate 
            WHERE DeveloperName = 'Car_Servise_Notification' 
            LIMIT 1
        ];

        for(Case case1 : cases) {            
            if (String.isNotBlank(case1.SuppliedEmail) ){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
                email.setTemplateId(emailTemplate.Id);
            
                email.setTargetObjectId(case1.Id); 
            
                email.setWhatId(case1.Id);
            
                email.setReplyTo(case1.SuppliedEmail); 
                
                emails.add(email);
            }           
        }
        Messaging.sendEmail(emails);
    }
    private void createCarServices(List<Case> cases){
        Map<String, Case> carCodes = new Map<String, Case>(); 
        Map<Id, Contact> contacts = new Map<Id, Contact>();
        for(Case case1 : cases) {
            carCodes.put(case1.Car_Vin_Code__c, case1);
        }
        List<Product2> cars = [SELECT Id, VIN_Number__c FROM Product2 WHERE VIN_Number__c IN :carCodes.keySet()];
        if(cars.size() < 1) {return;}

        List<Car_Service__c> services = new List<Car_Service__c>();
        for(Product2 car : cars) {
            Case case2 = carCodes.get(car.VIN_Number__c);
            Car_Service__c service = new Car_Service__c();
            service.Name = case2.SuppliedName;
            service.Case__c = case2.Id;
            service.Car__c = car.Id;
            service.Description__c = case2.Description;
            service.Date__c = System.today();
            services.add(service);
        }
        insert services;        
    }
}