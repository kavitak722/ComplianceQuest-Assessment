@isTest
private class TestAccountTrigger {
    
    @isTest
    static void testAccountTrigger() {
        // Test data setup
        Account testAccount = new Account(
            Name = 'Test Account',
            OwnerId = UserInfo.getUserId()
        );
        insert testAccount;

        // Verify task creation
        List<Task> tasks = [SELECT Subject, WhatId, ActivityDate, OwnerId, Status FROM Task];
        System.assertEquals(1, tasks.size(), 'One task should have been created');
        Task createdTask = tasks[0];
        System.assertEquals('Review Account - ' + testAccount.AccountNumber, createdTask.Subject, 'Task subject should be correct');
        System.assertEquals(testAccount.Id, createdTask.WhatId, 'Task should be associated with the test account');
        System.assertEquals(Date.today().addDays(7), createdTask.ActivityDate, 'Task activity date should be 7 days from today');
        System.assertEquals(UserInfo.getUserId(), createdTask.OwnerId, 'Task owner should be the same as account owner');
        System.assertEquals('Not Started', createdTask.Status, 'Task status should be Not Started');

        // Verify account update
        testAccount = [SELECT Active__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(false, testAccount.Active__c, 'Account should be inactive after trigger execution');
    }
}
