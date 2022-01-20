/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AddressResolutionModel extends AVA_MAPPER.ErrorResult {
    global AVA_MAPPER.AddressInfo address {
        get;
        set;
    }
    global AVA_MAPPER.CoordinateInfo coordinates {
        get;
        set;
    }
    global List<AVA_MAPPER.AvaTaxMessage> messages {
        get;
        set;
    }
    global AVA_MAPPER.ResolutionQuality resolutionQuality {
        get;
        set;
    }
    global List<AVA_MAPPER.TaxAuthorityInfo> taxAuthorities {
        get;
        set;
    }
    global List<AVA_MAPPER.ValidatedAddressInfo> validatedAddresses {
        get;
        set;
    }
    global AddressResolutionModel() {

    }
}
