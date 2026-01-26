class ZCL_ZCUST_ORDERS_DPC_EXT definition
  public
  inheriting from ZCL_ZCUST_ORDERS_DPC
  create public .

public section.
protected section.

  methods CUSTOMERSET_GET_ENTITY
    redefinition .
  methods ORDERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZCUST_ORDERS_DPC_EXT IMPLEMENTATION.


  METHOD customerset_get_entity.
    DATA(lv_kunnr) = VALUE #( it_key_tab[ name = 'CustId' ]-value OPTIONAL ).
*--Fetch Customer details
    SELECT SINGLE
           FROM kna1
           FIELDS
           kunnr,
           land1,
           name1
           WHERE kunnr EQ @lv_kunnr
           INTO @DATA(ls_cust).
      IF sy-subrc EQ 0.
       er_entity-custid = ls_cust-kunnr.
       er_entity-country = ls_cust-land1.
       er_entity-name = ls_cust-name1.

      ENDIF.
  ENDMETHOD.


  METHOD orderset_get_entityset.
    TRY.
        CALL METHOD me->customerset_get_entity
          EXPORTING
            iv_entity_name     = iv_entity_name
            iv_entity_set_name = iv_entity_set_name
            iv_source_name     = iv_source_name
            it_key_tab         = it_key_tab
            it_navigation_path = it_navigation_path
          IMPORTING
            er_entity          = DATA(ls_entity).
      CATCH /iwbep/cx_mgw_busi_exception.
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    IF ls_entity IS NOT INITIAL.
      SELECT FROM vbak
             FIELDS
             vbeln,
             vkorg,
             kunnr,
             vbtyp
             WHERE kunnr EQ @ls_entity-custid
             INTO TABLE @DATA(lt_order).
      IF sy-subrc EQ 0.
        et_entityset = CORRESPONDING #( lt_order ).
        et_entityset = VALUE #( FOR ls_ord IN lt_order
                                       ( OrderId = ls_ord-vbeln
                                         Salesorg = ls_ord-vkorg
                                         Customer = ls_ord-kunnr
                                         Ordertype = ls_ord-vbtyp ) ).

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
