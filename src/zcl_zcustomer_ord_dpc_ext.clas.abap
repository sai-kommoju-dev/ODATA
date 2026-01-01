class ZCL_ZCUSTOMER_ORD_DPC_EXT definition
  public
  inheriting from ZCL_ZCUSTOMER_ORD_DPC
  create public .

public section.
protected section.

  methods CUSTOMERSET_GET_ENTITY
    redefinition .
  methods CUSTOMERSET_GET_ENTITYSET
    redefinition .
  methods ORDERSSET_GET_ENTITY
    redefinition .
  methods ORDERSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZCUSTOMER_ORD_DPC_EXT IMPLEMENTATION.


  METHOD customerset_get_entity.

    DATA(lv_kunnr) = VALUE #( it_key_tab[ name = 'CustID' ]-value OPTIONAL ).
    IF lv_kunnr IS NOT INITIAL.
      SELECT SINGLE
              FROM kna1
              FIELDS
              kunnr,
              name1
              WHERE kunnr EQ @lv_kunnr
              INTO @DATA(ls_kna1).
      IF sy-subrc EQ 0.
        er_entity-custid = ls_kna1-kunnr.
        er_entity-name   = ls_kna1-name1.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method CUSTOMERSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->CUSTOMERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.


  method ORDERSSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ORDERSSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  endmethod.


  METHOD ordersset_get_entityset.
    DATA(lv_custid) = VALUE #( it_key_tab[ name = 'CustID' ]-value OPTIONAL ).
    IF lv_custid IS NOT INITIAL.
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
               kunnr
               WHERE kunnr EQ @ls_entity-custid
               INTO TABLE @DATA(lt_orders).
        IF sy-subrc EQ 0.
          et_entityset = VALUE #( FOR ls_order IN lt_orders
                                      ( orderid = ls_order-vbeln
                                        salesorg = ls_order-vkorg
                                        custid = ls_order-kunnr  ) ).
        ENDIF.

      ENDIF.
    ELSE.
      SELECT FROM vbak
             FIELDS
             vbeln,
             vkorg,
             kunnr
             INTO TABLE @DATA(lt_vbak).
      IF sy-subrc EQ 0.
        et_entityset = VALUE #( FOR ls_vbak IN lt_vbak
                                    ( OrderID = ls_vbak-vbeln
                                      Salesorg = ls_vbak-vkorg
                                      CustID   = ls_vbak-kunnr ) ).

      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
