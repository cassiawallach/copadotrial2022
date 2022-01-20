/**
 * An apex page controller that provides the preview of certification badges on Twitter and Linkedin
 */
public class BadgePreviewController {

	public String title { get; set;}
   	public String description { get; set;}
   	public String badgeImageUrlPath { get; set; }
	public String linkType { get; set; }
	public String redirectUrl { get; set; }

	/**
	 * Constructor to set the values for title, badgeImageUrlPath, description, redirectUrl based on query params.
	 */
	public badgePreviewController() {
		setDefaultValues();
		linkType = ApexPages.currentPage().getParameters().get('ty');
		String badgeName = ApexPages.currentPage().getParameters().get('name');
		if('badge'.equalsIgnoreCase(linkType) && !String.isBlank(badgeName)) {
			List<Community_Badge_Social_Sharing__mdt> communityBadgeSocialSharing = [SELECT Title__c, Description__c, Redirect_URL__c , Unique_Name__c FROM Community_Badge_Social_Sharing__mdt WHERE Unique_Name__c = :badgeName.replace('_', ' ') LIMIT 1];
			if(!communityBadgeSocialSharing.isEmpty()) {
				title = communityBadgeSocialSharing[0].Title__c;
				description = communityBadgeSocialSharing[0].Description__c;
				badgeImageUrlPath = '/s/sfsites/c/resource/Community/CommunityResources/badges/' + badgeName + '.png';
				redirectUrl = communityBadgeSocialSharing[0].Redirect_URL__c;
			}
		}
	}
	/**
	 * Set default values for title, badgeImageUrlPath, and redirectUrl
	 */
	private void setDefaultValues() {
		title = 'Copado';
		badgeImageUrlPath = '/s/sfsites/c/resource/Community/CommunityResources/copadoIcons/FaviconIcon.png';
		redirectUrl = System.Label.Copado_Community_URL;
	}
}