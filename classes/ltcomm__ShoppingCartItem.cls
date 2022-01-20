/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ShoppingCartItem {
    @AuraEnabled
    global String backgroundImage;
    @AuraEnabled
    global Decimal cost;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Decimal discount;
    @AuraEnabled
    global Boolean hasAssignment;
    @AuraEnabled
    global Id itemId;
    @AuraEnabled
    global String itemType;
    @AuraEnabled
    global Integer maxQuantity;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id orderId;
    @AuraEnabled
    global Decimal points;
    @AuraEnabled
    global Integer quantity;
    global ShoppingCartItem(Id itemId, Integer quantity, Decimal discount) {

    }
    global ShoppingCartItem(Id itemId, String itemType, Integer quantity) {

    }
    global ShoppingCartItem(Id itemId, Integer maxQuantity, String name, String description, String backgroundImage) {

    }
    global void mergeShoppingCart(ltcomm.ShoppingCartItem minorShoppingCartItem) {

    }
}
