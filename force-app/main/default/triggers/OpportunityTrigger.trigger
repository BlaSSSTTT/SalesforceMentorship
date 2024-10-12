trigger OpportunityTrigger on Opportunity (before insert, before update, before delete) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.UpdatePlannedSales(Trigger.new);
            OpportunityTriggerHandler.UpdateCarStatus(Trigger.new);
        }else if(Trigger.isDelete){
            OpportunityTriggerHandler.UpdatePlannedSales(Trigger.old);
        }else if(Trigger.isInsert){
            OpportunityTriggerHandler.UpdateCarStatus(Trigger.new);
        }
        
    }
}