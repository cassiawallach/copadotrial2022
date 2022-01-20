public  with sharing class SalesforceCampaignTriggerHelper {
    
    public static void updateCampaignName(Campaign newCamp){
        
        if( newCamp.StartDate != Null){
            DateTime d = newCamp.StartDate;
            String dateStr =  d.format('MM/dd/yyyy');
            newCamp.Name  = newCamp.Fiscal_Year__c.right(2)+'.'+newCamp.Timeframe__c+'.'+newCamp.Region__c+'.'+newCamp.Type.substringAfter('-').replaceAll( '\\s+', '')+': '+newCamp.Name__c;
        }else{
             newCamp.Name  = newCamp.Fiscal_Year__c.right(2)+'.'+newCamp.Timeframe__c+'.'+newCamp.Region__c+'.'+newCamp.Type.substringAfter('-').replaceAll( '\\s+', '')+': '+newCamp.Name__c;
        }
        
    }
    public static void setCampaignName(Campaign oldCamp,Campaign newCamp){
        DateTime d = newCamp.StartDate;
        String dateStr =  d.format('MM/dd/yyyy') ;
        if((oldCamp.Timeframe__c != newCamp.Timeframe__c ||
            oldCamp.StartDate  != newCamp.StartDate  ||
            oldCamp.Region__c  != newCamp.Region__c  ||
            oldCamp.Fiscal_Year__c  != newCamp.Fiscal_Year__c  ||
            oldCamp.Name__c  != newCamp.Name__c ||
            oldCamp.Name  != newCamp.Name ||
            oldCamp.Type  != newCamp.Type) && newCamp.StartDate != Null){
                newCamp.Name  = newCamp.Fiscal_Year__c.right(2) +'.'+ newCamp.Timeframe__c +'.'+ newCamp.Region__c +'.'+ newCamp.Type.substringAfter('-').replaceAll( '\\s+', '') +': '+ newCamp.Name__c;
            }else{
                newCamp.Name  = newCamp.Fiscal_Year__c.right(2) +'.'+ newCamp.Timeframe__c +'.'+ newCamp.Region__c +'.'+ newCamp.Type.substringAfter('-').replaceAll( '\\s+', '') +': '+ newCamp.Name__c;
            }
       
    }
}