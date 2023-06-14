Global class runPartProduct Implements schedulable{
    global void execute(schedulableContext sc){
        
        List<SQX_Part__c> partsToUpdate = new List<SQX_Part__c>();
        
        // Retrieve all parts without a product
        List<SQX_Part__c> partsWithoutProduct = [SELECT Id, Name, Part_Number__c, Product__c 
                                                 FROM SQX_Part__c WHERE Active__c = true AND Product__c = null];
        
        if (!partsWithoutProduct.isEmpty()) {
            For(SQX_Part__c prt: partsWithoutProduct){
                String productName = prt.Name;
                String productCode = prt.Part_Number__c;
                system.debug('partsWithoutProduct: '+partsWithoutProduct.size());
                system.debug('partsWithoutProduct: '+partsWithoutProduct);
                
                // Search for a matching product by name
                List<Product2> matchingProducts = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name = :productName LIMIT 1];
                if (!matchingProducts.isEmpty()) {
                    System.debug('Found a matching product: '+matchingProducts[0].Name);
                    // Found a matching product, update the Part with the product reference
                    prt.Product__c = matchingProducts[0].Id;
              		  }else {
                    System.debug('Not Found a matching product');
                    // Create a new product record using the mapping details
                    Product2 newProduct = new Product2(Name = productName, ProductCode = productCode);
                    insert newProduct;
                    
                    // Update part with the new product reference
                    prt.Product__c = newProduct.Id;
                    
                    //existingProducts.put(productName + productCode, newProduct);
                    
                }
                partsToUpdate.add(prt);
            }
            update partsToUpdate;
            system.debug('Update Action Perform: '+partsToUpdate);
        }
    }      
}
/*This schedule to be call from Anonymous Window
 * 
runPartProduct run= new runPartProduct();  //This will call schedulable class
string cronExp='0 30 14 * * ?';

system.schedule('Myjob', cronExp, run);
*
*/