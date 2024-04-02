public class AccountTriggerHandler {
    public static void handleAfterInsert(List<Account> newAccounts) {
        List<Task> tasksToInsert = new List<Task>();
        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : newAccounts) {
            // Create a task associated with the new account
            Task newTask = new Task(
                Subject = 'Review Account - ' + acc.AccountNumber,
                WhatId = acc.Id,
                ActivityDate = Date.today().addDays(7),
                OwnerId = acc.OwnerId,
                Status = 'Not Started'
            );
            tasksToInsert.add(newTask);

            // Update the account to be inactive
            Account accountToUpdate = new Account(Id = acc.Id, Active__c = false);
            accountsToUpdate.add(accountToUpdate);
        }

        // Insert tasks and update accounts
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
