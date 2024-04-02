trigger TaskTrigger on Task (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        TaskTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}