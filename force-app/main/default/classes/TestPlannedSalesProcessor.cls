@isTest
public with sharing class TestPlannedSalesProcessor {
    @isTest
    public static void testPlannedSalesProcessor() {
        List<Planned_Sales__c> plannedSalesList = new List<Planned_Sales__c>();
        for(Integer i=2020;i<2024;i++){
            for(Integer j=1;j<13;j++){
                Planned_Sales__c ps = new Planned_Sales__c();
                ps.Name = 'Test Plan'+i+j;
                ps.Month__c = j;
                ps.Year__c = i;
                ps.Planned_Total_Amount__c = 10;
                ps.Total_Amount_Earned__c = 0;
                plannedSalesList.add(ps);
            }
        }
        insert plannedSalesList;        
        
        Id jobId;
    
        Test.startTest();
  
        jobId = System.schedule('Planned Sales Schedulable', '0 0 0 ? * * *', new PlannedSalesSchedul());
  
        Test.stopTest(); 

        List<AsyncApexJob> batchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'PlannedSalesSchedul'];        
        System.assertEquals(1, batchJobs.size(), 'Unexpected number of batch jobs ran: ' + batchJobs);
        System.assertEquals('Queued', batchJobs[0].Status, 'Job planned with an unexpected status.');
    }
}