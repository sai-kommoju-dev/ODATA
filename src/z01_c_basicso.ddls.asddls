@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view'
@Metadata.ignorePropagatedAnnotations: false
@OData.publish: true
@OData.entitySet.name: 'BasicSO'
@OData.entityType.name: 'BasicSOType'
define view entity Z01_C_BasicSO as select from vbak
association [1..*] to vbap as _Items
on $projection.vbeln = _Items.vbeln
{
  key vbeln,
      erdat,
      auart,
      _Items 
}
