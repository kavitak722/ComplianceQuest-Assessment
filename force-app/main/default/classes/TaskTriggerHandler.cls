public class TaskTriggerHandler {
    public static void handleAfterUpdate(Map<Id, Task> newTasksMap, Map<Id, Task> oldTasksMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();

        for (Task newTask : newTasksMap.values()) {
            Task oldTask = oldTasksMap.get(newTask.Id);
            // Check if task status is changed to 'Completed'
            if (newTask.Status == 'Completed' && (oldTask == null || oldTask.Status != 'Completed')) {
                // Get the corresponding account Id
                accountIdsToUpdate.add(newTask.WhatId);
            }
        }

        if (!accountIdsToUpdate.isEmpty()) {
            // Query accounts to update
            List<Account> accounts = [SELECT Id, Description FROM Account WHERE Id IN :accountIdsToUpdate];
            for (Account acc : accounts) {
                // Set account as active
                acc.Active__c = true;
                // Transfer task comments to account description
                for (Task newTask : newTasksMap.values()) {
                    if (newTask.WhatId == acc.Id && !String.isBlank(newTask.Description)) {
                        acc.Description = newTask.Description;
                    }
                }
                accountsToUpdate.add(acc);
            }

            // Update accounts
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}
