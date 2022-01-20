/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Transformer {
    global Transformer() {

    }
    global static Map<String,zealynxsf.Transformer.MapResource> queryMappingFor(SObject fromObject, SObject toObject) {
        return null;
    }
    global static Map<String,zealynxsf.Transformer.MapResource> queryMappingFor(Schema.SObjectType fromObject, Schema.SObjectType toObject) {
        return null;
    }
    global static Map<String,zealynxsf.Transformer.MapResource> queryMappingFor(String fromObject, String toObject) {
        return null;
    }
    global static Id saveMetadata(List<zealynxsf.Transformer.MapResource> maps) {
        return null;
    }
    global static List<SObject> transform(List<SObject> fromRecords, String transformToSobjectType) {
        return null;
    }
    global static SObject transform(SObject fromObject, SObject toObject, Map<String,Schema.SObjectField> fromFieldMap, Map<String,Schema.SObjectField> toFieldMap, Map<String,zealynxsf.Transformer.MapResource> maps) {
        return null;
    }
global class MapResource {
    global String defaultValue;
    global String fromField;
    global String fromObject;
    global String fromType;
    global String toField;
    global String toObject;
    global String toType;
    global MapResource() {

    }
    global MapResource(zealynxsf__Mapping__mdt m) {

    }
    global Metadata.CustomMetadata toCustomMetadata() {
        return null;
    }
}
}
