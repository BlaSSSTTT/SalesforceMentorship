public class SendEmailQueueable implements Queueable {
    List<Planned_Sales__c> plannedSales;
    List<String> emailAddresses;
    public SendEmailQueueable (List<Planned_Sales__c> plannedSales){
        this.plannedSales = plannedSales;
        String groupName = 'Salesforce_Admin_Group';
        Group targetGroup = [SELECT Id FROM Group WHERE DeveloperName  = :groupName LIMIT 1];
        List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :targetGroup.Id];
        Set<Id> groupMemberID = new Set<Id>();
        for(GroupMember gm : groupMembers) {
             groupMemberID.add(gm.UserOrGroupId);
        }
        List<String> emailAddresses = new List<String>();
        List<User> users = [SELECT Id,Email FROM User WHERE Id = :groupMemberID];
        for (User user : users) {            
            if (user.Id != null) {
                emailAddresses.add(user.Id);
            }
        }
        this.emailAddresses = emailAddresses;
    }

    public void execute(QueueableContext context) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        System.debug(emailAddresses);
        message.toAddresses = emailAddresses;
        message.optOutPolicy = 'FILTER';
        message.subject = 'Notification that some planned sales is underperforming';
        String body = '';
            
            
        for(Planned_Sales__c plannedSale : plannedSales){
            body+= 'Id:' +plannedSale.Id+', Name:'+plannedSale.Name+', Month:'+plannedSale.Month__c+', Year:'+plannedSale.Year__c+', Planned Total Amount:'+plannedSale.Planned_Total_Amount__c+', Total Amount Earned:'+plannedSale.Total_Amount_Earned__c+'\n';
        }
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages = 
            new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                + results[0].errors[0].message);
        }
    }
}