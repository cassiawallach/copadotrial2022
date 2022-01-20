/*
    JNC
    Silver Softworks
    12/06/2018
*/
public abstract with sharing class SelectorBase {
	abstract List<Schema.SObjectField> GetFields();

	public List<String> GetFieldNamesList()
    {
        List<String> fieldNamesSet = new List<String>();
        
        for (Schema.SObjectField field : GetFields())
		{
			fieldNamesSet.add(field.getDescribe().getName());
		}
            
        return fieldNamesSet;
    }
    
    public String GetFieldNamesString()
    {
        return String.Join(GetFieldNamesList(), ',');
    }
}