/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LMSCheckoutPlugins {
    global LMSCheckoutPlugins() {

    }
global interface Pricing {
    redwing.LMSCheckoutPlugins.PricingConfig getTrainingPlansPricing(Set<Id> param0);
}
global class PricingConfig {
    global Map<Id,redwing.LMSCheckoutPlugins.PricingDetails> itemsPricing {
        get;
        set;
    }
    global PricingConfig() {

    }
}
global class PricingDetails {
    global Decimal appliedDiscount {
        get;
        set;
    }
    global Decimal cost {
        get;
        set;
    }
    global String currencyCode {
        get;
        set;
    }
    global String currencySymbol {
        get;
        set;
    }
    global PricingDetails() {

    }
}
}
