/**
 * Class TriggerFactory
 *
 * Used to instantiate and execute Trigger Handlers associated with sObjects.
 */
public with sharing class TriggerFactory
{
    /**
     * Public static method to create and execute a trigger handler
     *
     * Arguments:   Schema.sObjectType soType - Object type to process (SObject.sObjectType)
     *
     * Throws a TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType)
    {
        // Get a handler appropriate to the object being processed
        ITrigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     * private static method to control the execution of the handler
     *
     * Arguments:   ITrigger handler - A Trigger Handler to execute
     */ 
    private static void execute(ITrigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        
        // Perform any post processing
        handler.andFinally();
    }
    
    /**
     * private static method to get the appropriate handler for the object type.
     * Modify this method to add any additional handlers.
     *
     * Arguments:   Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
     *
     * Returns:     ITrigger - A trigger handler if one exists or null.
     */
    @TestVisible
    private static ITrigger getHandler(Schema.sObjectType soType)
    {
        if (soType == Account.sObjectType) {
            return new AccountHandler();
        }
        if (soType == Contact.sObjectType) {
            return new ContactTriggerHandler();
        }
        if (soType == Psydo_Case__c.sObjectType) {
            return new PsydoCaseTriggerHandler();
        }
        if (soType == Contract_Line_Item__c.sObjectType) {
            return new ContractLineItemTriggerHandler();
        }
        if (soType == Case.sObjectType) {
            return new CaseTriggerHandler();
        }
        if (soType == SBQQ__Quote__c.sObjectType){
            return new CPQQuoteTriggerHandler();
        }
        if (soType == Task.sObjectType){
            return new TaskTriggerHandler();
        }
        if (soType == EmailMessage.sObjectType){
            return new EmailMessageTriggerHandler();
        }
        if (soType == Order.sObjectType){
            return new OrderTriggerHandler();
        }
        if (soType == copado__Release__c.sObjectType){
            return new ReleaseTriggerHandler();
        }
        if (soType == Salesforce_Org__c.sObjectType){
            return new SalesforceOrgHandler();
        }
        if (soType == Demo__c.sObjectType){
            return new MeetingTriggerHandler();
        }
        if (soType == sfLma__License__c.sObjectType){
            return new LicenseHandler();
        }
        if (soType == Academy_Certification_Student__c.sObjectType){
            return new AcademyCertificationStudentHandler();
        }
        if (soType == Academy_Certification_Delivery__c.sObjectType){
            return new AcademyCertificationDeliveryHandler();
        }
        if (soType == amc__Time_Log__c.sObjectType){
            return new MC_TimeLogTriggerHandler();
        }
        if (soType == Playground_Job__c.sObjectType){
            return new PlaygroundJobTriggerHandler();
        }
        if (soType == Lead.sObjectType){
            return new LeadTriggerHandler();
        }
        if (soType == ltcomm__Learning_Order__c.sObjectType){
            return new LearningOrderTriggerHandler();
        }


        if (soType == OpportunityLineItem.sObjectType){
            return new OpportunityLineItemTriggerHandler();
        }
        if (soType == Opportunity.sObjectType){
            return new OpportunityTriggerHandler();
        }
         if (soType == redwing__ILT_Roster__c.sObjectType){
            return new ILT_RosterTriggerHandler();  
        }
        if (soType == Step_Execution__c.sObjectType){
           return new StepExecutionTriggerHelper();
        }
        if (soType == copado1p__Platform_Job_Execution__c.sObjectType){
            return new PlatformJobExecutionTriggerHelper();
        }
        if (soType == Interactive_Validation_Step_Execution__c.sObjectType){
            return new InteractiveValidStepExeTriggerHelper();
        }
        if (soType == kugo2p__SalesOrder__c.sObjectType){
            return new KugamonOrderTriggerHandler();
        }
        if (soType == Campaign.sObjectType){
            return new SalesforceCampaignTriggerHandler();
        }
        if (soType == Validation_Execution__c.sObjectType){
            return new ValidationExecutionTriggerHelper();
        }
        if (soType == Configuration_Execution__c.sObjectType){
            return new ConfigExecutionTriggerHelper();
        }
        if (soType == Configuration_Step__c.sObjectType){
           return new ConfigurationStepTriggerHelper();
        }

        return null;
    }
}