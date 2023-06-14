@isTest
public class runPartProduct_Test {
    @isTest
    static void RunPartProduct_TestAdmin() {
        // Create test data
        Product2 prd = new Product2(Name = 'Test123', ProductCode = 'TEST123');
        insert prd;       
        
        SQX_Part__c prt1= new SQX_Part__c(name='test1',Part_Number__c='1',Active__c = true);
        insert prt1;
        
        SQX_Part__c prt2= new SQX_Part__c(name='Test123',Part_Number__c='TEST123',Active__c = true);
        insert prt2;
        
        
        String productName = prt2.Name;
        String productCode = prt2.Part_Number__c;
        
        Product2 prd2 = new Product2(Name = productName, ProductCode = productCode);
        insert prd2; 
        
        SQX_Part__c prt3= new SQX_Part__c(name='test3',Part_Number__c='3', Product__c=prd2.ID);
        insert prt3;
        
        Test.startTest();
        
        // Call the schedulable class as an admin user
        System.runAs(new User(Id = UserInfo.getUserId(), ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id)) {
            
            System.schedule('Test Schedule', '0 0 6 * * ?', new runPartProduct());
        }
               
        // Retrieve the updated parts
        List<SQX_Part__c> updatedParts = [SELECT Id, Name, Part_Number__c, Product__c FROM SQX_Part__c WHERE Id =: prt3.Id];
                                          
                                          
        
        runPartProduct run= new runPartProduct();
        run.execute(null);
              
        string cronExp='0 0 6 * * ?';

        system.schedule('jobName', cronExp, run);
        
        
        
        // Assertions
        
        System.assertNotEquals(prd.Id, prt1.Product__c);
        System.assertNotEquals(prd.Id, prt2.Product__c);
        
        Test.stopTest();
         
        
    }
    
   @isTest
    static void RunPartProduct_TestStandardUser() {
        // Create test data
        Product2 prd = new Product2(Name = 'Test123', ProductCode = 'TEST123');
        insert prd;       
        
        SQX_Part__c prt1= new SQX_Part__c(name='test1',Part_Number__c='1');
        insert prt1;
        
        SQX_Part__c prt2= new SQX_Part__c(name='Test123',Part_Number__c='TEST123');
        insert prt2;
        
        
        String productName = prt2.Name;
        String productCode = prt2.Part_Number__c;
        
        Product2 prd2 = new Product2(Name = productName, ProductCode = productCode);
        insert prd2; 
        
        SQX_Part__c prt3= new SQX_Part__c(name='test3',Part_Number__c='3', Product__c=prd2.ID);
        insert prt3;
        
        Test.startTest();
        
        // Call the schedulable class as a standard user
        System.runAs(new User(Id = UserInfo.getUserId(), ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id)) {
            
            System.schedule('Test Schedule', '0 0 6 * * ?', new runPartProduct());
        }
        
        Test.stopTest();
        
        // Retrieve the updated parts
        List<SQX_Part__c> updatedParts = [SELECT Id, Name, Part_Number__c, Product__c
                                          FROM SQX_Part__c
                                          WHERE Id =:prt3.ID];
        
        runPartProduct run= new runPartProduct();
        run.execute(null);
        //test.setMock(schedulableContext.class, run); 
        string cronExp='0 0 6 * * ?';

        system.schedule('jobName', cronExp, run);
        
        // Assertions
        System.assertNotEquals(prd.Id, prt1.Product__c);
        System.assertNotEquals(prd.Id, prt2.Product__c);
    }
    }