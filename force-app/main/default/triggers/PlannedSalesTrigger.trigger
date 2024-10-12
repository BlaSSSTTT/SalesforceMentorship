trigger PlannedSalesTrigger on Planned_Sales__c (before insert, before update) { 
    if(Trigger.isBefore ) {
        if(Trigger.isInsert || Trigger.isUpdate){
            PlannedSalesTriggerHandler.SetAmountAndCountFields(Trigger.new, Trigger.old);
        }
        
    }

}