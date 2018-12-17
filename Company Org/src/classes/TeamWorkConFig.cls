public with sharing class TeamWorkConFig {
    // thrown when their is no config
    public class NoConfigException extends Exception{}
    
    public static TeamWork_Configuration__c Configuration {
        get {
            if ( Configuration == null ) {
                Map<String, TeamWork_Configuration__c> allOneKeyCfg = TeamWork_Configuration__c.getAll();
                
                if (allOneKeyCfg != null && !allOneKeyCfg.isEmpty()) {
                    Configuration =  allOneKeyCfg.values()[0];
                } else {
                    throw new NoConfigException('No configuration found for Movex SOAP config');
                }
            }
            return Configuration;
            
        } private set;
    }
}