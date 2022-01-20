global class SalesforceInvoiceEmailService implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        //The email should have an attachment which is the invoice PDF
        if(email.binaryAttachments==null || email.binaryAttachments.size()==0){
            result.success = false;
            result.message = 'The email does not have an attachment.';
            system.debug('##### '+result.message);
            return result;
        }

        String emailBody = email.plainTextBody;
        String[] bodySplit = emailBody.split('\n');

        String customerName = '';
        String sfdcAccountNumber = '';
        String sfdcContractNumber = '';
        Date invoiceDate = null; 
        Date invoiceDueDate = null;
        String invoiceNumber = '';
        Double invoiceAmount = 0.0;

        try{
            for(String s : bodySplit){
                if(s.startsWithIgnoreCase('Account Name')){
                    customerName = s.split(':')[1].deleteWhitespace();
                    system.debug('customerName: '+customerName);
                }
                if(s.startsWithIgnoreCase('Account Number')){
                    sfdcAccountNumber = s.split(':')[1].deleteWhitespace();
                    system.debug('sfdcAccountNumber: '+sfdcAccountNumber);
                }
                if(s.startsWithIgnoreCase('Contract Number')){
                    sfdcContractNumber = s.split(':')[1].deleteWhitespace();
                    system.debug('sfdcContractNumber: '+sfdcContractNumber);
                }
                if(s.startsWithIgnoreCase('Invoice Date')){
                    invoiceDate = parseDate(s.split(':')[1].deleteWhitespace());
                    system.debug('invoiceDate: '+invoiceDate);
                }
                if(s.startsWithIgnoreCase('Invoice Due Date')){
                    invoiceDueDate = parseDate(s.split(':')[1].deleteWhitespace());
                    system.debug('invoiceDueDate: '+invoiceDueDate);
                }
                if(s.startsWithIgnoreCase('Invoice Number')){
                    invoiceNumber = s.split(':')[1].deleteWhitespace();
                    system.debug('invoiceNumber: '+invoiceNumber);
                }
                if(s.startsWithIgnoreCase('Invoice Amount')){
                    String tmp = s.split(':')[1].deleteWhitespace().replace('EUR','');
                    invoiceAmount = parseStringToDouble(tmp);
                    system.debug('invoiceAmount: '+invoiceAmount);
                }
            }

        
            //Find a customer account with matching SFDC Account Number
            List<Account> accounts = [select Id, Name, SFDC_Account_Number__c from Account where SFDC_Account_Number__c=:sfdcAccountNumber];
            if(accounts.size()==0){
                result.success = false;
                result.message = 'The Account for Account Number "'+sfdcAccountNumber+'" could not be found.';
                system.debug('##### '+result.message);
                return result;
            }

            //Find a contract with matching SFDC contract number.
            List<Order> orders = [select Id, Name, OrderReferenceNumber from Order where OrderReferenceNumber=:sfdcContractNumber];
            if(orders.size()==0){
                result.success = false;
                result.message = 'The Order for Order Number "'+sfdcContractNumber+'" could not be found.';
                system.debug('##### '+result.message);
                return result;
            }

            //Find Salesforce.com account
            List<Account> sfdcAccounts = [select Id, Name from Account where Name='salesforce.com EMEA Limited'];
            if(sfdcAccounts.size()==0){
                result.success = false;
                result.message = 'The salesforce.com account "salesforce.com EMEA Limited" could not be found.';
                system.debug('##### '+result.message);
                return result;
            }

            // Create the Payable Invoice
            Payable_Invoice__c payableInvoice = new Payable_Invoice__c(Account__c=sfdcAccounts[0].Id, Order__c=orders[0].Id);
            payableInvoice.CurrencyIsoCode = 'EUR';
            payableInvoice.Invoice_Amount__c = invoiceAmount;
            payableInvoice.Related_Customer__c = accounts[0].Id;
            payableInvoice.Name = invoiceNumber;
            payableInvoice.External_Id__c = invoiceNumber;
            payableInvoice.Invoice_Date__c = invoiceDate;
            payableInvoice.Invoice_Due_Date__c = invoiceDueDate;
            Schema.SObjectField f = Payable_Invoice__c.External_Id__c;
			Database.UpsertResult ur = Database.upsert(payableInvoice, f, false);
	
            if(ur.isCreated()==true){
                Attachment attachment = new Attachment(ParentId=payableInvoice.Id);
                attachment.Name = 'SFDC Invoice - '+invoiceNumber+'.pdf';
                attachment.Body = email.binaryAttachments[0].Body;
                insert attachment;
			}
            result.success = true;
        }
        catch(Exception e){
            result.success = false;
            result.message = e.getMessage();
            system.debug('##### '+result.message);
        }
        return result;
    }
    public static Date parseDate(String sd){
        String stringDate = sd.substring(6,10) + '-' + 
                            sd.substring(3,5) + '-' +
                            sd.substring(0,2) + ' ';
        Date d = Date.valueOf(stringDate);
        System.debug('Created date: '+String.valueOf(d)+' from String:'+sd);
        return d;
    }
    public static Double parseStringToDouble(String s){
        String doubleString = s.replace(',', '');
        Double d = Double.valueOf(doubleString);
        return d;
    }
    public static String getTestEmail(){
        return 'Dear Philipp Rackwitz,\n'+
            '\n'+
            'Please find attached a detailed invoice on your account that will be due on 27/06/2015. \n'+
            '\n'+
            'The invoice summary is as follows: \n'+
            '\n'+
            'Account Name:                    2U - !Hub\n'+
            'Account Number:                  4-396489\n'+
            'Contract Number:                 01086425\n'+
            '\n'+
            'Invoice Date:                    28/05/2015\n'+
            'Invoice Due Date:                27/06/2015\n'+
            'Invoice Number:                  07081129\n'+
            'Invoice Amount:                  EUR 1,045.00\n'+
            '\n'+
            'We appreciate your timely payment.\n'+
            '\n'+
            'Please do not respond to this email.\n'+
            '\n'+
            'Sincerely, \n'+
            'The salesforce.com Billing Department \n'+
            '\n'+
            '\n'+
            'For answers to frequently asked billing questions, please visit our Billing FAQ at: \n'+
            'http://www.salesforce.com/company/faq.jsp \n'+
            '\n'+
            '\n'+
            'To log a case regarding a billing query, please click here: \n'+
            'https://www.salesforce.com/form/contact/billing-contact.jsp \n'+
            '\n'+
            '\n'+
            'contact customer service at +44 1753 422153 for any questions.\n'+
            '';
    }
}