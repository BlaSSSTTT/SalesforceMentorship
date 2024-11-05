public class PlannedSalesProcessor implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id,Name, Planned_Total_Amount__c, Total_Amount_Earned__c, Month__c, Year__c FROM Planned_Sales__c '
        );
    }
    

    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Planned_Sales__c> plannedSales = (List<Planned_Sales__c>) scope;
        List<Planned_Sales__c> plannedSalesToSendMessage = new List<Planned_Sales__c>();
        for(Planned_Sales__c plannedSale : plannedSales) {
            if(plannedSale.Planned_Total_Amount__c > plannedSale.Total_Amount_Earned__c) {
                plannedSalesToSendMessage.add(plannedSale);
            }
        }
        System.enqueueJob(new SendEmailQueueable(plannedSalesToSendMessage));
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Batch processing completed.');
    }
}