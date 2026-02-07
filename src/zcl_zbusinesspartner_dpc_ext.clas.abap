class ZCL_ZBUSINESSPARTNER_DPC_EXT definition
  public
  inheriting from ZCL_ZBUSINESSPARTNER_DPC
  create public .

public section.
protected section.

  methods BUSINESSPARTNERS_GET_ENTITYSET
    redefinition .
  methods PRODUCTSET_GET_ENTITYSET
    redefinition .
  methods BUSINESSPARTNERS_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZBUSINESSPARTNER_DPC_EXT IMPLEMENTATION.


  METHOD businesspartners_get_entity.
    DATA: ls_bp_id      TYPE bapi_epm_bp_id,
          ls_headerdata TYPE bapi_epm_bp_header,
          lt_return     TYPE TABLE OF bapiret2.

* Get key fields from request
    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = er_entity
    ).
    ls_bp_id-bp_id = er_entity-businesspartnerid.

* Get data
    CALL FUNCTION 'BAPI_EPM_BP_GET_DETAIL'
      EXPORTING
        bp_id      = ls_bp_id
      IMPORTING
        headerdata = ls_headerdata
      TABLES
        return     = lt_return.

    IF lt_return IS NOT INITIAL.
      " Message Container
      mo_context->get_message_container( )->add_messages_from_bapi( lt_return ).
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = mo_context->get_message_container( ).
    ENDIF.

* Map properties from the back-end to output response structure
    er_entity = VALUE #(
                  businesspartnerid   = ls_headerdata-bp_id
                  businesspartnerrole = ls_headerdata-bp_role
                  emailaddress        = ls_headerdata-email_address
                  companyname         = ls_headerdata-company_name
                  currencycode        = ls_headerdata-currency_code
                  city                = ls_headerdata-city
                  street              = ls_headerdata-street
                  country             = ls_headerdata-country
                  addresstype         = ls_headerdata-address_type ).
  ENDMETHOD.


  METHOD businesspartners_get_entityset.
    DATA: lt_headerdata TYPE TABLE OF bapi_epm_bp_header,
          lt_return     TYPE TABLE OF bapiret2.

* Get data
    CALL FUNCTION 'BAPI_EPM_BP_GET_LIST'
      TABLES
        bpheaderdata = lt_headerdata
        return       = lt_return.

    IF lt_return IS NOT INITIAL.
      "Message Container
      mo_context->get_message_container( )->add_messages_from_bapi( lt_return ).
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = mo_context->get_message_container( ).
    ENDIF.

* Map properties from the back-end to output response structure
    et_entityset = VALUE #( FOR header IN lt_headerdata
                     ( businesspartnerid   = header-bp_id
                       businesspartnerrole = header-bp_role
                       emailaddress        = header-email_address
                       companyname         = header-company_name
                       currencycode        = header-currency_code
                       city                = header-city
                       street              = header-street
                       country             = header-country
                       addresstype         = header-address_type ) ).

  ENDMETHOD.


METHOD productset_get_entityset.
  DATA: lt_headerdata TYPE TABLE OF bapi_epm_product_header,
        lt_return     TYPE TABLE OF bapiret2.

  DATA: ls_bp_id           TYPE bapi_epm_bp_id,
        ls_bp_headerdata   TYPE bapi_epm_bp_header,
        lt_so_supplier     TYPE TABLE OF
          bapi_epm_supplier_name_range,
        ls_businesspartner TYPE
         zcl_zbusinesspartner_mpc=>ts_businesspartner.

* Get key for navigation source
  CASE io_tech_request_context->get_source_entity_type_name( ).
    WHEN zcl_zbusinesspartner_mpc=>gc_businesspartner.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_businesspartner
      ).
      ls_bp_id-bp_id = ls_businesspartner-businesspartnerid.

      CALL FUNCTION 'BAPI_EPM_BP_GET_DETAIL'
        EXPORTING
          bp_id      = ls_bp_id
        IMPORTING
          headerdata = ls_bp_headerdata
        TABLES
          return     = lt_return.

      IF lt_return IS NOT INITIAL.
        " Message Container
        mo_context->get_message_container( )->add_messages_from_bapi( lt_return ).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_container = mo_context->get_message_container( ).
      ENDIF.
      lt_so_supplier = VALUE #( (
                         sign   = 'I'
                         option = 'EQ'
                         low    = ls_bp_headerdata-company_name ) ).
  ENDCASE.

* Get data
  CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
    TABLES
      headerdata            = lt_headerdata
      selparamsuppliernames = lt_so_supplier
      return                = lt_return.
  IF lt_return IS NOT INITIAL.
    " Message Container
    mo_context->get_message_container( )->add_messages_from_bapi( lt_return ).
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid            = /iwbep/cx_mgw_busi_exception=>business_error
        message_container = mo_context->get_message_container( ).
  ENDIF.

* Fill response data
  "  er_entity = CORRESPONDING #( ls_headerdata ).

  et_entityset = VALUE #( FOR ls_header IN lt_headerdata
                                ( ProductID = ls_header-product_id
                                  name = ls_header-name
                                  suplierid = ls_header-supplier_id
                                  price = ls_header-price ) ).

ENDMETHOD.
ENDCLASS.
