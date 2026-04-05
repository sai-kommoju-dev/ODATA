@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Article CDS view'
@Metadata.ignorePropagatedAnnotations: false
@OData.publish: true
@OData.entityType.name: 'ArticleType'
@OData.entitySet.name: 'ArticleA'
define view entity z01_C_Article as select from SEPM_I_Product
association [1] to Z01_C_Supplier as _Supplier
on $projection.SupplierUUID = _Supplier.BusinessPartnerUUID
{
   key ProductUUID,
   Product,
   ProductType,
   Price,
   Currency,
   Height,
   Width,
   Depth,
   DimensionUnit,
   ProductPictureURL,
   ProductValueAddedTax,
   SupplierUUID,
   Weight,
   WeightUnit,
   /* Associations */
   _Supplier
}
