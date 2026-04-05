@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Customer orders'
@Metadata.ignorePropagatedAnnotations: false
define view entity Z01_C_CustomerOrders as select from kna1
association [0..*] to vbak as _Orders
on $projection.kunnr = _Orders.kunnr
{
 key kunnr,
     name1,
     land1,
//Association     
     _Orders.vbeln
    
}
