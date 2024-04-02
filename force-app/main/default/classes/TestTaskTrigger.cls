@isTest
private class TestTaskTrigger {
    @isTest
    static void testTaskTrigger() {
        // Test data setup
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        // Create a task with status Not Started
        Task testTask = new Task(
            Subject = 'Test Task',
            WhatId = testAccount.Id,
            Status = 'Not Started'
        );
        insert testTask;

        // Verify that the account is not updated initially
        testAccount = [SELECT Active__c, Description FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(false, testAccount.Active__c, 'Account should not be active initially');
        System.assertEquals(null, testAccount.Description, 'Account description should be null initially');

        // Update the task status to Completed
        testTask.Status = 'Completed';
        testTask.Description = 'Task Description';
        update testTask;

        // Verify that the account is updated correctly
        testAccount = [SELECT Active__c, Description FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(true, testAccount.Active__c, 'Account should be active after task completion');
        System.assertEquals('Task Description', testAccount.Description, 'Account description should be updated with task description');
    }
}
