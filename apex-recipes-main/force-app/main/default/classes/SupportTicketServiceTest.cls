@IsTest
private class SupportTicketServiceTest {
    @IsTest
    static void testGetOpenTicketsAndCloseTicket() {
        Support_Ticket__c t1 = new Support_Ticket__c(
            Name = 'TKT-TEST-1',
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
}