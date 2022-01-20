/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AvaTaxClient {
    global AvaTaxClient(String appName, String appVersion, String machineName, AVA_MAPPER.AvaTaxEnvironment environment) {

    }
    global AVA_MAPPER.TransactionModel CommitTransaction(String companyCode, String transactionCode, AVA_MAPPER.DocumentType documentType, AVA_MAPPER.CommitTransactionModel model) {
        return null;
    }
    global AVA_MAPPER.FetchResultCertificateModel CreateCertificates(Integer companyId, Boolean preValidatedExemptionReason, List<AVA_MAPPER.CertificateModel> model) {
        return null;
    }
    global AVA_MAPPER.FetchResultCustomerModel CreateCustomers(Integer companyId, List<AVA_MAPPER.CustomerModel> model) {
        return null;
    }
    global AVA_MAPPER.TransactionModel CreateOrAdjustTransaction(String include, AVA_MAPPER.CreateOrAdjustTransactionModel model) {
        return null;
    }
    global AVA_MAPPER.TransactionModel CreateTransaction(String include, AVA_MAPPER.CreateTransactionModel model) {
        return null;
    }
    global AVA_MAPPER.FileResult DownloadCertificateImage(Integer companyId, Integer id, Integer page, AVA_MAPPER.CertificatePreviewType type) {
        return null;
    }
    global AVA_MAPPER.CertificateModel GetCertificate(Integer companyId, Integer id, String include) {
        return null;
    }
    global AVA_MAPPER.CustomerModel GetCustomer(Integer companyId, String customerCode, String include) {
        return null;
    }
    global AVA_MAPPER.FetchResultSubscriptionModel GetMySubscription() {
        return null;
    }
    global AVA_MAPPER.FetchResultTaxCodeModel GetTaxCodeByCompanyIdTaxCodeId(Integer taxCodeId, Integer companyId, String filter, String include, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.TransactionModel GetTransactionByCode(String companyCode, String transactionCode, String include) {
        return null;
    }
    global AVA_MAPPER.FetchResultCustomerModel LinkCustomersToCertificate(Integer companyId, Integer id, AVA_MAPPER.LinkCustomersModel model) {
        return null;
    }
    global AVA_MAPPER.FetchResultExemptionReasonModel ListCertificateExemptReasons(String filter, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.FetchResultExposureZoneModel ListCertificateExposureZones(String filter, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.FetchResultIsoCountryModel ListCountries() {
        return null;
    }
    global AVA_MAPPER.FetchResultEntityUseCodeModel ListEntityUseCodes() {
        return null;
    }
    global AVA_MAPPER.FetchResultTaxCodeModel ListTaxCodes(String filter, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.FetchResultTaxCodeModel ListTaxCodesByCompanyId(Integer companyId, String filter, String include, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.FetchResultCompanyModel QueryCompanies(String include, String filter, Integer top, Integer skip, String orderBy) {
        return null;
    }
    global AVA_MAPPER.CustomerModel UpdateCustomer(Integer companyId, String customerCode, AVA_MAPPER.CustomerModel model) {
        return null;
    }
    global String UploadCertificateImage(Integer companyId, Integer id, AVA_MAPPER.FileResult file) {
        return null;
    }
    global AVA_MAPPER.TransactionModel VoidTransaction(String companyCode, String transactionCode, AVA_MAPPER.DocumentType documentType, AVA_MAPPER.VoidTransactionModel model) {
        return null;
    }
    global AVA_MAPPER.AvaTaxClient WithSecurity(Integer accountId, String licenseKey) {
        return null;
    }
    global AVA_MAPPER.AvaTaxClient WithSecurity(String username, String password) {
        return null;
    }
    global AVA_MAPPER.AddressResolutionModel resolveAddressPost(AVA_MAPPER.AddressValidationInfo model) {
        return null;
    }
    global AVA_MAPPER.FileResult restCallForFile(String method, String relativePath, Object model) {
        return null;
    }
    global System.HttpResponse restCallForList(String method, String relativePath, Object model) {
        return null;
    }
    global AVA_MAPPER.CertificateModel updateCertificate(Integer companyId, Integer id, AVA_MAPPER.CertificateModel model) {
        return null;
    }
}
