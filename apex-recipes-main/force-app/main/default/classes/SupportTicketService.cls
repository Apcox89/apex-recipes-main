public with sharing class SupportTicketService {
    public static List<Support_Ticket__c> getOpenTickets(Integer maxRows) {
        Integer safeMax = (maxRows == null || maxRows <= 0) ? 20 : Math.min(maxRows, 200);

        return [
            SELECT Id, Name, Status__c, Priority__c, Description__c, Closed_On__c, CreatedDate
            FROM Support_Ticket__c
            WHERE Status__c != 'Closed'
            ORDER BY CreatedDate DESC
            LIMIT :safeMax
        ];
    }

    public static void closeTicket(Id ticketId) {
        Support_Ticket__c t = [
            SELECT Id, Status__c, Closed_On__c
            FROM Support_Ticket__c
            WHERE Id = :ticketId
            LIMIT 1
        ];

        t.Status__c = 'Closed';
        if (t.Closed_On__c == null) {
            t.Closed_On__c = System.now();
        }
        update t;
    }
}