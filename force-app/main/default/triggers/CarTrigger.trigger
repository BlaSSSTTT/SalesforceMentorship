trigger CarTrigger on Product2 (before insert, before update) {
    if(Trigger.isBefore ) {
        if(Trigger.isInsert || Trigger.isUpdate){
            CarTriggerHandler.SetCarNotActive(Trigger.new);
        }
    }

}