class ZCL_ZSALESORDERDET_DPC_EXT definition
  public
  inheriting from ZCL_ZSALESORDERDET_DPC
  create public .

public section.
protected section.

  methods SALESHEADERSET_GET_ENTITY
    redefinition .
  methods SALESHEADERSET_GET_ENTITYSET
    redefinition .
  methods SALESITEMSET_GET_ENTITY
    redefinition .
  methods SALESITEMSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSALESORDERDET_DPC_EXT IMPLEMENTATION.


  method SALESHEADERSET_GET_ENTITY.
    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = 'Orderno' ]-value OPTIONAL ).
    SELECT SINGLE
           FROM vbak
           FIELDS
           vbeln,
           vkorg,
           vtweg,
           spart
           WHERE vbeln EQ @lv_vbeln
           INTO @DATA(ls_vbak).
    IF sy-subrc EQ 0.
     er_entity-orderno = ls_vbak-vbeln.
     er_entity-salesorg = ls_vbak-vkorg.
     er_entity-distrib = ls_vbak-vtweg.
     er_entity-division = ls_vbak-spart.
    ENDIF.
    CLEAR lv_vbeln.
  endmethod.


  METHOD salesheaderset_get_entityset.

    SELECT FROM vbak
           FIELDS
           vbeln,
           vkorg,
           vtweg,
           spart
           INTO TABLE @DATA(lt_vbak).
    IF sy-subrc EQ 0.
      et_entityset = VALUE #( FOR ls_vbak IN lt_vbak
                            ( Orderno = ls_vbak-vbeln
                              Salesorg = ls_vbak-vkorg
                              Distrib = ls_vbak-vtweg
                              Division = ls_vbak-spart  )  ).

    ENDIF.
  ENDMETHOD.


  METHOD salesitemset_get_entity.
    TRY.
        CALL METHOD me->salesheaderset_get_entity
          EXPORTING
            iv_entity_name     = iv_entity_name
            iv_entity_set_name = iv_entity_set_name
            iv_source_name     = iv_source_name
            it_key_tab         = it_key_tab
*           io_request_object  =
*           io_tech_request_context =
            it_navigation_path = it_navigation_path
          IMPORTING
            er_entity          = DATA(ls_entity)
*           es_response_context     =
          .
      CATCH /iwbep/cx_mgw_busi_exception.
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    DATA(lv_posnr) = VALUE #( it_key_tab[ name = 'Item' ]-value OPTIONAL ).

    SELECT SINGLE
           FROM vbap
           FIELDS
           vbeln,
           posnr,
           matnr,
           pstyv
           WHERE vbeln EQ @ls_entity-orderno
             AND posnr EQ @lv_posnr
           INTO @DATA(ls_vbap).
    IF sy-subrc EQ 0.
      er_entity-orderno = ls_vbap-vbeln.
      er_entity-item = ls_vbap-posnr.
      er_entity-material = ls_vbap-matnr.
      er_entity-itemcat = ls_vbap-pstyv.
    ENDIF.
    CLEAR: ls_entity,
    lv_posnr.
  ENDMETHOD.


  METHOD salesitemset_get_entityset.
    TRY.
*Fetching Sales order no from header or Principal Entity
        CALL METHOD me->salesheaderset_get_entity
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
*--Pass Order no to VBAP to fetch item details
    SELECT FROM vbap
           FIELDS
           vbeln,
           posnr,
           matnr,
           pstyv
           WHERE vbeln EQ @ls_entity-orderno
           INTO TABLE @DATA(lt_vbap).
    IF sy-subrc EQ 0.
      et_entityset = VALUE #( FOR ls_vbap IN lt_vbap
                              ( Orderno  = ls_vbap-vbeln
                                Item     = ls_vbap-posnr
                                Material = ls_vbap-matnr
                                Itemcat  = ls_vbap-pstyv ) ).
    ENDIF.
    CLEAR: ls_entity.
  ENDMETHOD.
ENDCLASS.
