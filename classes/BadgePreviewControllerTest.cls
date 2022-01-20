/**
 * An apex page controller that provides the preview of certification badges on Twitter and Linkedin
 */
@IsTest
public class BadgePreviewControllerTest {
	@IsTest
	public static void testBadgePreviewController() {
		PageReference pageRef = Page.BadgePreview;
		test.setCurrentPage(pageRef);
		pageRef.getParameters().put('ty','badge');
		pageRef.getParameters().put('name','CONSULTANT');
		BadgePreviewController controller = new BadgePreviewController();
		System.assertEquals('badge', controller.linkType);
		System.assert(!String.isBlank(controller.title));
		System.assert(!String.isBlank(controller.description));
		System.assert(!String.isBlank(controller.badgeImageUrlPath));
		System.assert(!String.isBlank(controller.redirectUrl));
	}
}