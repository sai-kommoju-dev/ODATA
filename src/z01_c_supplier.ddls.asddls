@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business partner- Supplier'
@Metadata.ignorePropagatedAnnotations: false
@OData.publish: true
@OData.entityType.name: 'SupplierType'
@OData.entitySet.name: 'Supplier'

define view entity Z01_C_Supplier
  as select from SEPM_I_BusinessPartner
  association [0..*] to z01_C_Article as _Article
  on $projection.BusinessPartnerUUID = _Article.SupplierUUID
{
  key BusinessPartnerUUID,
      BusinessPartner,
      BusinessPartnerRole,
      Currency,
      CompanyName,
      LegalForm,
      EmailAddress,
      FaxNumber,
      PhoneNumber,
      URL,
//*--Association--*      
      _Article
}
