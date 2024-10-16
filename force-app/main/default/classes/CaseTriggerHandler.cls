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
                Integer startIndex = caseRecord.Subject.indexOf('VIN-')+4;
                Integer endIndex = caseRecord.Subject.indexOf(' ', startIndex);
                if (endIndex == -1) {
                    endIndex = caseRecord.Subject.length();
                }                
                String vinCode = caseRecord.Subject.substring(startIndex, endIndex);
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

            List<EmailMessage> email = [SELECT Id FROM EmailMessage WHERE ParentId IN :casesId];
            System.debug(email);
            Map<Id, Case> emailIds = new Map<Id, Case>();
            for(EmailMessage emailRecord : email){
                for(Case caseRecord : cases1){
                    if(caseRecord.Id == emailRecord.ParentId){
                        emailIds.put(emailRecord.Id, caseRecord);
                    }
                }
            }
            List<Attachment> attachments = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId IN :emailIds.keySet()];
            List<Attachment> newAttachments = new List<Attachment>();
            Map<Id, Attachment> attachmentMap = new Map<Id, Attachment>();
            for (EmailMessage emailRecord : email) {
                
                for (Attachment attachment : attachments) {
                    if (attachment.ParentId == emailRecord.Id) {
                        Case case1 = emailIds.get(attachment.ParentId);
                        Car_Service__c service = servicesMap.get(case1.Id);
                        Attachment newAttachment = new Attachment();
                        newAttachment.Body = attachment.Body;
                        newAttachment.Name = attachment.Name;
                        newAttachment.ParentId = service.Id;  
                        
                        newAttachments.add(newAttachment);
                        break; 
                    }
                }
            }
            insert newAttachments;

            // List<ContentDocumentLink> doclinkL = new List<ContentDocumentLink>();
            // List<ContentDocumentLink> doclinks = [
            //     SELECT ContentDocumentId, LinkedEntityId 
            //     FROM ContentDocumentLink 
            //     WHERE LinkedEntityId in :casesId
            // ];
            // System.debug(doclinks);
            // for (Case caseRecord : cases1) {
            //     Car_Service__c service = servicesMap.get(caseRecord.Id);
            //     for (ContentDocumentLink dlink : doclinks) {
            //         if (dlink.LinkedEntityId == caseRecord.Id) {
            //             ContentDocumentLink doclink = new ContentDocumentLink();
            //             doclink.ContentDocumentId = dlink.ContentDocumentId;
            //             doclink.LinkedEntityId = service.Id;
            //             doclink.ShareType = 'V';
            //             doclink.Visibility = 'InternalUsers';
            //             doclinkL.add(doclink);
            //         }
            //     }
            // }
            // insert doclinkL;

        }       
    }
    public void fromWeb(List<Case> cases){
        Map<String, Case> carCodes = new Map<String, Case>(); 
        Map<Id, Contact> contacts = new Map<Id, Contact>();
        List<Contact> contactsToInsert = new List<Contact>();
        for(Case case1 : cases) {
            if (String.isNotBlank(case1.SuppliedEmail)){
                carCodes.put(case1.Car_VIN_Code__c, case1);
                Contact contact = new Contact();
                contact.Email = case1.SuppliedEmail;
                contact.LastName = String.valueOf(System.now().getTime());

                contactsToInsert.add(contact);
                contacts.put(case1.Id, contact);
            }
        }
        insert contactsToInsert;
        for(Case case1 : cases) {
            carCodes.put(case1.Car_Vin_Code__c, case1);
            if (String.isNotBlank(case1.SuppliedEmail) ){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
                email.setTemplateId('00XQy000007Stgf');
            
                email.setTargetObjectId(contacts.get(case1.Id).Id); 
            
                email.setWhatId(case1.Id);
            
                email.setSenderDisplayName('Sender Name'); 
            
                email.setReplyTo(case1.SuppliedEmail); 
            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
            
            
        }
        List<Product2> cars = [SELECT Id, VIN_Number__c FROM Product2 WHERE VIN_Number__c IN :carCodes.keySet()];
        if(cars.size() > 0) {
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
    
}