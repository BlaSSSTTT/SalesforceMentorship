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

        Test.startTest();
        Database.executeBatch(new PlannedSalesProcessor(), 200); 
        Test.stopTest();
        Integer invocations = Limits.getEmailInvocations();
        System.assertEquals(0, invocations, 'Email has not been sent');
    }
}