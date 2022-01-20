@isTest
private class TestCopadoMonitorComponentController {
    @isTest static void test_method_one() {

        // there is no way to unencrypt the token, so the only test we can do is this
        CopadoMonitorComponentController controller = new CopadoMonitorComponentController();
        System.assertNotEquals(null, controller.getRefreshToken());
    }
}