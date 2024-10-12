public with sharing class OpportunityTriggerHandler {
    public static void UpdatePlannedSales(List<Opportunity> opportunities){
        try{
            Set<Id> opportunityIds = new Set<Id>();       
            Set<Id> carIds = new Set<Id>();
            Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
            Map<Id, Product2> mapCars = new Map<Id, Product2>();
            Set<Integer> opportunityMonths = new Set<Integer>();
            Set<Integer> opportunityYears = new Set<Integer>();
            Set<String> carTypeSet = new Set<String>();

            //get id of closed win opp
            for (Opportunity opp : opportunities) {
                if(opp.StageName == 'Closed Won'){
                    opportunityIds.add(opp.Id);
                    mapOpps.put(opp.Id, opp);
                    opportunityMonths.add(Integer.valueOf(opp.CloseDate.Month()));
                    opportunityYears.add(Integer.valueOf(opp.CloseDate.Year()));
                }            
            }

            //get oli of this opps
            List<OpportunityLineItem> oliList = [
                SELECT Product2Id, OpportunityId
                FROM OpportunityLineItem 
                WHERE OpportunityId IN :opportunityIds
            ];        
            for (OpportunityLineItem oli : oliList) {
                carIds.add(oli.Product2Id);
            }
            List<Product2> carsList = [
                SELECT Condition__c, Id, Final_Sale_Price__c
                FROM Product2
                WHERE Id IN :carIds
            ];
            for (Product2 car : carsList) {
                mapCars.put(car.Id, car);
                carTypeSet.add(car.Condition__c);
            }
            //get all needed planned sales
            List<Planned_Sales__c> plannedSalesToUpdate = [
                SELECT Id,Car_Type__c,Month__c,Total_Amount_Earned__c,Count_of_Cars_Sold__c, Year__c
                FROM Planned_Sales__c 
                WHERE Month__c IN :opportunityMonths and Year__c IN :opportunityYears and Car_Type__c IN :carTypeSet
            ];
            //add to all oli Amount and count of oli
            for(OpportunityLineItem oli : oliList){
                for(Planned_Sales__c ps: plannedSalesToUpdate){
                    Opportunity opp = mapOpps.get(oli.OpportunityId);
                    Product2 car = mapCars.get(oli.Product2Id);
                    if(ps.Total_Amount_Earned__c == null){
                        ps.Total_Amount_Earned__c = 0;
                    }
                    if(ps.Count_of_Cars_Sold__c == null){
                        ps.Count_of_Cars_Sold__c = 0;
                    }
                    if(
                        ps.Car_Type__c.trim().toLowerCase() == car.Condition__c.trim().toLowerCase() &&
                        ps.Month__c == opp.CloseDate.Month() &&
                        ps.Year__c == opp.CloseDate.Year()
                    ){
                        ps.Total_Amount_Earned__c += car.Final_Sale_Price__c;
                        ps.Count_of_Cars_Sold__c++;
                    }
                    
                }
            }
            update plannedSalesToUpdate;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    public static void UpdateCarStatus(List<Opportunity> opportunities){
        Map<Id, String> opportunityIdAndValToUpdate = new Map<Id, String>();
        List<Id> oppIds = new List<Id>();
        Set<Id> carIds = new Set<Id>();
        for(Opportunity opp: opportunities){
            oppIds.add(opp.Id);
            if(opp.StageName == 'Contract Sent'){
                opportunityIdAndValToUpdate.put(opp.id,'Reserved');
            }else if(opp.StageName == 'Closed Won'){
                opportunityIdAndValToUpdate.put(opp.id,'Sold');
            }else {
                opportunityIdAndValToUpdate.put(opp.id,'Available');
            }
        }
        List<OpportunityLineItem> oliList = [
            SELECT Product2Id,OpportunityId
            FROM OpportunityLineItem 
            WHERE OpportunityId IN :oppIds
        ];
        for(OpportunityLineItem oli : oliList) {
            carIds.add(oli.Product2Id);
        }
        List<Product2> carsList = [
            SELECT Car_Status__c, Id, RecordTypeId
            FROM Product2
            WHERE Id IN :carIds
        ];
        Id newRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Sold' AND SObjectType = 'Product2' LIMIT 1].Id;
        for (OpportunityLineItem oli : oliList) {
            for (Product2 car : carsList) {
                if(oli.Product2Id == car.Id){
                    car.Car_Status__c = opportunityIdAndValToUpdate.get(oli.OpportunityId);
                    if(car.Car_Status__c == 'Sold'){
                        car.RecordTypeId = newRecordTypeId;
                    }
                    
                    break;
                }
            }
        }

        update carsList;
    }
}