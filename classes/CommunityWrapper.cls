public class CommunityWrapper {
	public class ResponseWrap {
		@AuraEnabled public Boolean isError;
		@AuraEnabled public String message;
		@AuraEnabled public Object result;
		public ResponseWrap(Boolean isError, String message) {
			this.isError = isError;
			this.message = message;
		}
		public ResponseWrap(Boolean isError, String message, Object result) {
			this.isError = isError;
			this.message = message;
			this.result = result;
		}
	}

	public class PicklistEntry {
		@AuraEnabled public String label;
		@AuraEnabled public String value;
		public PicklistEntry(String label, String value) {
			this.label = label;
			this.value = value;
		}
	}

	public class CustomSobject {
		@AuraEnabled public String Id;
		@AuraEnabled public String Name;
		public CustomSobject(String Id, String Name) {
			this.Id = Id;
			this.Name = Name;
		}
	}

	// Related file or attachment wrapper class
	public class relatedFile {
		public String PathOnClient;
		public String Title;
		public Blob VersionData;
	}
}