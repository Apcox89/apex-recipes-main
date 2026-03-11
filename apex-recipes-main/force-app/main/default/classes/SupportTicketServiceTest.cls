@IsTest
private class SupportTicketServiceTest {
    @IsTest
    static void testGetOpenTicketsAndCloseTicket() {
        Support_Ticket__c t1 = new Support_Ticket__c(
            Status__c = 'New',
            Priority__c = 'High',
            Description__c = 'Portal login failure'
        );
        insert t1;

        Test.startTest();
        List<Support_Ticket__c> openTickets = SupportTicketService.getOpenTickets(10);
        SupportTicketService.closeTicket(t1.Id);
        Test.stopTest();

        System.assert(openTickets.size() > 0, 'Should return at least one open ticket');

        Support_Ticket__c refreshed = [
            SELECT Status__c, Closed_On__c
            FROM Support_Ticket__c
            WHERE Id = :t1.Id
        ];
        System.assertEquals('Closed', refreshed.Status__c);
        System.assertNotEquals(null, refreshed.Closed_On__c);
    }

    @IsTest
    static void testGetHighPriorityOpenTickets() {
        Support_Ticket__c highOpen = new Support_Ticket__c(
            Status__c = 'New',
            Priority__c = 'High',
            Description__c = 'High priority open ticket'
        );
        Support_Ticket__c highClosed = new Support_Ticket__c(
            Status__c = 'Closed',
            Priority__c = 'High',
            Description__c = 'High priority closed ticket'
        );
        Support_Ticket__c lowOpen = new Support_Ticket__c(
            Status__c = 'In Progress',
            Priority__c = 'Low',
            Description__c = 'Low priority open ticket'
        );
        insert new List<Support_Ticket__c>{ highOpen, highClosed, lowOpen };

        Test.startTest();
        List<Support_Ticket__c> results = SupportTicketService.getHighPriorityOpenTickets(10);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return only high-priority open tickets');
        System.assertEquals('High', results[0].Priority__c);
        System.assertNotEquals('Closed', results[0].Status__c);
        System.assertEquals(highOpen.Id, results[0].Id);
    }
}