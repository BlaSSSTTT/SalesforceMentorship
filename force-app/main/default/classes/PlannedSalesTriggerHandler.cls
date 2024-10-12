public with sharing class PlannedSalesTriggerHandler {
    public static void SetAmountAndCountFields(List<Planned_Sales__c> plannedSalesList, List<Planned_Sales__c> plannedSalesOldList) {
        try{
            if(plannedSalesOldList != null){
                plannedSalesList = filter(plannedSalesList, plannedSalesOldList);
            }
            if(plannedSalesList.size() == 0){
                return;
            }
            List<Integer> opportunityMonths = new List<Integer>();
            List<Integer> opportunityYears = new List<Integer>();
            Set<String> carTypeSet = new Set<String>();
            Set<Id> carIds = new Set<Id>();
            Map<Id, Product2> mapCars = new Map<Id, Product2>();
            Set<Id> oppIds = new Set<Id>();
            Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
            List<Date> dateRange = new List<Date>();
            
            for(Planned_Sales__c ps : plannedSalesList){
                ps.Total_Amount_Earned__c = 0;
                ps.Count_of_Cars_Sold__c = 0;
                if(ps.Month__c!=null && ps.Year__c !=null && ps.Car_Type__c!=null){
                    opportunityMonths.add(Integer.valueOf(ps.Month__c));
                    opportunityYears.add(Integer.valueOf(ps.Year__c));
                    carTypeSet.add(ps.Car_Type__c);
                }                
            }  
            String query = 'SELECT Id, Name, CloseDate FROM Opportunity WHERE StageName = \'Closed Won\' AND (';
            List<String> conditions = new List<String>();

            for (Integer i = 0; i < opportunityYears.size(); i++) {
                conditions.add('(CALENDAR_YEAR(CloseDate) = ' + opportunityYears[i] + ' AND CALENDAR_MONTH(CloseDate) = ' + opportunityMonths[i] + ')');
            }

            query += String.join(conditions, ' OR ')+')';
            List<Opportunity> opportunities = Database.query(query);
            
            for (Opportunity opp : opportunities) {
                oppIds.add(opp.Id);
                mapOpps.put(opp.Id, opp);
            }

            List<OpportunityLineItem> oliList = [
                SELECT Product2Id, OpportunityId
                FROM OpportunityLineItem 
                WHERE OpportunityId IN :oppIds
            ];
            
            for(OpportunityLineItem oli : oliList) {
                carIds.add(oli.Product2Id);
            }
            List<Product2> carsList = [
                SELECT Id, Final_Sale_Price__c, Condition__c
                FROM Product2
                WHERE Id IN :carIds
            ];
            for(Product2 car : carsList) {
                mapCars.put(car.Id, car);
            }
            for(Planned_Sales__c ps: plannedSalesList){
                for(OpportunityLineItem oli : oliList){
                    if(ps.Month__c!=null && ps.Year__c !=null && ps.Car_Type__c!=null){
                        Product2 car = mapCars.get(oli.Product2Id);
                        Opportunity opp = mapOpps.get(oli.OpportunityId);
                        if(
                            car.Condition__c!=null &&
                            ps.Car_Type__c == car.Condition__c &&
                            ps.Month__c == opp.CloseDate.Month() &&
                            ps.Year__c == opp.CloseDate.Year()
                        ){
                            ps.Total_Amount_Earned__c += car.Final_Sale_Price__c;
                            ps.Count_of_Cars_Sold__c++;
                        }
                    }   
                }
            }
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    private static List<Planned_Sales__c> filter(List<Planned_Sales__c> oldlist, List<Planned_Sales__c> newlist){
        List<Planned_Sales__c> filtered = new List<Planned_Sales__c>();
        for(Integer i = 0; i < newlist.size(); i++){
            if(oldlist[i].Month__c != newlist[i].Month__c ||
               oldlist[i].Year__c != newlist[i].Year__c ||
             oldlist[i].Car_Type__c != newlist[i].Car_Type__c){
                filtered.add(newlist[i]);
            }
        }
        return filtered;
    }
}