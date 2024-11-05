public class SendEmailQueueable implements Queueable {
    List<Planned_Sales__c> plannedSales;
    List<String> emailAddresses;
    public SendEmailQueueable (List<Planned_Sales__c> plannedSales){
        System.debug('13123123123');
        this.plannedSales = plannedSales;
        String groupName = 'Salesforce_Admin_Group';
        System.debug(groupName);
        Group targetGroup = [SELECT Id FROM Group WHERE DeveloperName  = :groupName LIMIT 1];
        System.debug(targetGroup);
        List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :targetGroup.Id];
        System.debug(groupMembers);
        Set<Id> groupMemberID = new Set<Id>();
        for(GroupMember gm : groupMembers) {
             groupMemberID.add(gm.UserOrGroupId);
        }
        List<String> emailAddresses = new List<String>();
        List<User> users = [SELECT Id,Email FROM User WHERE Id = :groupMemberID];
        System.debug(users);
        for (User user : users) {            
            if (user.Id != null) {
                emailAddresses.add(user.Id);
            }
        }
        this.emailAddresses = emailAddresses;
    }

    public void execute(QueueableContext context) {
        System.debug('Starting email sending process');
        // Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // email.setToAddresses(emailAddresses);
        // email.setSubject('Notification that some planned sales is underperforming');


        // String body = '';
            
            
        // for(Planned_Sales__c plannedSale : plannedSales){
        //     body+= 'Id:' +plannedSale.Id+', Name:'+plannedSale.Name+', Month:'+plannedSale.Month__c+', Year:'+plannedSale.Year__c+', Planned Total Amount:'+plannedSale.Planned_Total_Amount__c+', Total Amount Earned:'+plannedSale.Total_Amount_Earned__c+'\n';
        // }
        // email.setPlainTextBody(body);
        // try {
        //     Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
        //     System.debug('Email sent successfully.');
        // } catch (Exception e) {
        //     System.debug('Failed to send email: ' + e.getMessage());
        // }
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