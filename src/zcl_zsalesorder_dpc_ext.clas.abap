class ZCL_ZSALESORDER_DPC_EXT definition
  public
  inheriting from ZCL_ZSALESORDER_DPC
  create public .

public section.
protected section.

  methods SALESHEADERSET_GET_ENTITY
    redefinition .
  methods SALESITEMSET_GET_ENTITYSET
    redefinition .
  methods SALESITEMSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSALESORDER_DPC_EXT IMPLEMENTATION.


  METHOD salesheaderset_get_entity.
*--Get Sales order ID
    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = 'OrderID' ]-value OPTIONAL ).
    IF lv_vbeln IS NOT INITIAL.
      SELECT SINGLE
             FROM vbak
             FIELDS
             vbeln,
             vbtyp,
             vkorg
             WHERE vbeln EQ @lv_vbeln
             INTO @DATA(ls_vbak).
      IF sy-subrc EQ 0.
        er_entity-orderid = ls_vbak-vbeln.
        er_entity-ordertyp = ls_vbak-vbtyp.
        er_entity-salesorg = ls_vbak-vkorg.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD salesitemset_get_entity.
    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = 'OrderID' ]-value OPTIONAL ).
    DATA(lv_posnr) = VALUE #( it_key_tab[ name = 'Item' ]-value OPTIONAL ).
    IF lv_vbeln IS NOT INITIAL AND
       lv_posnr IS NOT INITIAL.
      SELECT SINGLE FROM vbap
             FIELDS
             vbeln,
             posnr,
             matnr,
             kwmeng,
             vrkme
             WHERE vbeln EQ @lv_vbeln
                AND posnr EQ @lv_posnr
             INTO @DATA(ls_vbap).
      IF sy-subrc EQ 0.
        er_entity-orderid = ls_vbap-vbeln.
        er_entity-item = ls_vbap-posnr.
        er_entity-material = ls_vbap-matnr.
        er_entity-quantity = ls_vbap-kwmeng.
        er_entity-uom = ls_vbap-vrkme.
      ENDIF.
     ENDIF.
    ENDMETHOD.


  METHOD salesitemset_get_entityset.
    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = 'OrderID' ]-value OPTIONAL ).
    IF lv_vbeln IS NOT INITIAL.
      SELECT FROM vbap
             FIELDS
             vbeln,
             posnr,
             matnr,
             kwmeng,
             vrkme
             WHERE vbeln EQ @lv_vbeln
             INTO TABLE @DATA(lt_vbap).
      IF sy-subrc EQ 0.
        et_entityset = VALUE #( FOR ls_vbap IN lt_vbap
                                 ( orderid = ls_vbap-vbeln
                                   item = ls_vbap-posnr
                                   material = ls_vbap-matnr
                                   quantity = ls_vbap-kwmeng
                                   uom = ls_vbap-vrkme ) ).
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
