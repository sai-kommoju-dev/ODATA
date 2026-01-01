class ZCL_ZMATERIAL_DATA_DPC_EXT definition
  public
  inheriting from ZCL_ZMATERIAL_DATA_DPC
  create public .

public section.
protected section.

  methods MATERIALSET_GET_ENTITY
    redefinition .
  methods MATERIALSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMATERIAL_DATA_DPC_EXT IMPLEMENTATION.


  METHOD materialset_get_entity.
**TRY.
*CALL METHOD SUPER->MATERIALSET_GET_ENTITY
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
    DATA(lv_matnr) = VALUE #( it_key_tab[ name = 'Matnr' ]-value OPTIONAL ).
 IF lv_matnr IS NOT INITIAL.
    SELECT SINGLE FROM mara
           FIELDS
           matnr,
           mtart,
           matkl,
           meins
           WHERE matnr EQ @lv_matnr
           INTO @DATA(ls_mara).

    IF sy-subrc EQ 0.
      er_entity-matnr = ls_mara-matnr.
      er_entity-mtart = ls_mara-mtart.
      er_entity-matkl = ls_mara-matkl.
      er_entity-meins = ls_mara-meins.
    ENDIF.
ENDIF.
  ENDMETHOD.


  METHOD materialset_get_entityset.
    DATA(lv_matnr) = VALUE #( it_key_tab[ name = 'Matnr' ]-value OPTIONAL ).
    DATA(lv_top) = io_tech_request_context->get_top( ).
    DATA(lv_skip) = io_tech_request_context->get_skip( ).
    IF lv_matnr IS NOT INITIAL.
      SELECT SINGLE FROM mara
             FIELDS
             matnr,
             mtart,
             matkl,
             meins
             WHERE matnr EQ @lv_matnr
             INTO @DATA(ls_mara).

      IF sy-subrc EQ 0.
        et_entityset = VALUE #( ( Matnr = ls_mara-matnr
                                  Mtart = ls_mara-mtart
                                  Matkl = ls_mara-matkl
                                  Meins = ls_mara-meins ) ).
      ENDIF.
    ELSE.
      SELECT FROM mara
             FIELDS
             matnr,
             mtart,
             matkl,
             meins
             INTO TABLE @et_entityset.
      IF sy-subrc EQ 0.
        IF it_order IS NOT INITIAL.


        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
