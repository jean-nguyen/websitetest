/* update for git hub second time */
/* update for git hub second time */
public class CloneSingleRecord { 
    @AuraEnabled
    public static String cloneAnySobjet(String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         String objectAPIName = 'ITSAC_Request__c';
        /*
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : schemaMap.Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
*/
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){
            if(schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().get(s).getDescribe().isAccessible()){
                soqlQuery +=  + s+',';
            }
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery'+soqlQuery);
        SObject record = Database.query(soqlQuery);
        SObject clondedParentRecordID= record.clone(false, false, false, false);
        try{
            insert clondedParentRecordID ;
            return clondedParentRecordID.id ;
        }catch(Exception e){
            return '' ;
        }
        
    }
    
    @AuraEnabled
    public static String cloneAnySobject(String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String objectAPIName = 'ITSAC_Request__c';
        /*
        
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : schemaMap.Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
*/
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){
            if(schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().get(s).getDescribe().isAccessible()){
                soqlQuery +=  + s+',';
            }
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery'+soqlQuery);
        SObject record = Database.query(soqlQuery);
        SObject clondedParentRecordID= record.clone(false, false, false, false);
        try{
            insert clondedParentRecordID ;
            
            return clondedParentRecordID.id ;           
            
        }catch(Exception e){
            return '' ;
        }
        
    }
    @AuraEnabled
    public static String cloneObjectAndRelated(String recordId, String objectAPIName){
        //Savepoint sp = Database.setSavepoint();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();       
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){
            if(schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().get(s).getDescribe().isAccessible()){
                soqlQuery +=  + s+',';
            }
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery'+soqlQuery);
        SObject record = Database.query(soqlQuery);
        SObject clondedParentRecordID= record.clone(false, false, false, false);
        try{
            insert clondedParentRecordID ;
            
            List<ITSAC_Request_Skill__c> CloneSkillList = new List<ITSAC_Request_Skill__c>();                           
            for( ITSAC_Request_Skill__c sk : [SELECT Id, Name,Skills_and_Experience__c,Type__c,Years_of_Experience__c  From ITSAC_Request_Skill__c where solicitation__c =: recordId ] ){
                ITSAC_Request_Skill__c CloneSkill = sk.clone(false);
                CloneSkill.Solicitation__c = clondedParentRecordID.id;
                CloneSkillList.add(CloneSkill);                
            }
            /*
            for( ITSAC_Request_Skill__c sk : [SELECT Id, Name,Skills_and_Experience__c,Type__c,Years_of_Experience__c  From ITSAC_Request_Skill__c where solicitation__c =: recordId ] ){
                ITSAC_Request_Skill__c CloneSkill = new ITSAC_Request_Skill__c();               
                CloneSkill.Solicitation__c = clondedParentRecordID.id;
                CloneSkill.Type__c = sk.Type__c;
                CloneSkill.Skills_and_Experience__c = sk.Skills_and_Experience__c;
                CloneSkill.Years_of_Experience__c = sk.Years_of_Experience__c;
                CloneSkillList.add(CloneSkill);
            } */
            insert CloneSkillList;  
            return clondedParentRecordID.id ;           
            
        }catch(Exception e){
            //Database.rollback(sp);
            //ApexPages.addMessages(e);
            return null ;
        }
        
    }
    
    @AuraEnabled
    public static ITSAC_Request__c getSolicitation(String solicitationId){        
        return  [SELECT Id, 
                                          Name,                                          
                                          Title__c,
                                          Level__c, 
                                          Technology_Type__c,
                                          NTE_Rate__c,
                                          Num_of_Positions__c,
                                          Estimated_hours__c,
                                          No_of_Resumes_Allowed_Per_Vendor__c,
                                          number_of_Selected_Contracts__c,                                          
                                          Working_Title__c,
                                          Status__c ,
                                          Estimated_Start_Date__c,
                                          Estimated_End_Date__c,
                                          Work_Hours_Start__c,
                                          Work_Hours_End__c,
                                          Parttime__c, 
                                          Working_Location__c,
                                          Description_of_Duties__c,
                                          Special_Requirements__c,
                                          Additional_Terms_and_Conditions__c
                                    FROM ITSAC_Request__c WHERE Id =: solicitationId limit 1]; 
    }
    
}