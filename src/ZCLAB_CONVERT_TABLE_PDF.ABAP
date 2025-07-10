class ZCLAB_CONVERT_TABLE_PDF definition
  public
  final
  create public .

public section.

  methods M_GERAR_PDF
    importing
      value(I_TABLE) type STANDARD TABLE
    returning
      value(R_PDF) type SOLIX_TAB .
  methods M_GET_MENSAGEM
    returning
      value(R_MENSAGEM) type BAPIRET2 .
  methods M_GET_BIN_FILE
    returning
      value(R_BIN_FILE) type XSTRING .
protected section.
private section.

  data WA_PRIPAR type PRI_PARAMS .
  data WA_ARCPAR type ARC_PARAMS .
  data WA_MENSAGEM type BAPIRET2 .
  data V_SPOOLID type RSPOID .
  data V_BIN_FILE type XSTRING .

  methods M_PRINT_PARAMETERS
    returning
      value(R_VALIDACAO) type CHAR3 .
  methods M_FACTORY_OBJ
    changing
      !CH_TABLE type STANDARD TABLE
    returning
      value(R_VALIDACAO) type ABAP_BOOL .
  methods M_CONVERT_PDF
    importing
      !I_TABLE type STANDARD TABLE
    returning
      value(R_PDF) type SOLIX_TAB .
ENDCLASS.



CLASS ZCLAB_CONVERT_TABLE_PDF IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCLAB_CONVERT_TABLE_PDF->M_CONVERT_PDF
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TABLE                        TYPE        STANDARD TABLE
* | [<-()] R_PDF                          TYPE        SOLIX_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_convert_pdf.

    DATA:vl_of_bytes    TYPE i,
         vl_no_of_bytes TYPE i,
         vl_pages       TYPE i,
         vl_pdf_spoolid TYPE tsp01-rqident,
         vl_jobname     TYPE tbtcjob-jobname,
         vl_jobcount    TYPE tbtcjob-jobcount.

    CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
      EXPORTING
        src_spoolid          = v_spoolid
        no_dialog            = 'X'
        no_background        = ' '
        pdf_destination      = 'X'
        get_size_from_format = 'X'
      IMPORTING
        pdf_bytecount        = vl_no_of_bytes
        pdf_spoolid          = vl_pdf_spoolid
        btc_jobname          = vl_jobname
        btc_jobcount         = vl_jobcount
        list_pagecount       = vl_pages
        bin_file             = v_bin_file.

    r_pdf = cl_document_bcs=>xstring_to_solix( v_bin_file ).

    CHECK r_pdf IS INITIAL.

    wa_mensagem-type    = 'E'.
    wa_mensagem-message = 'Erro no M_CONVERT_PDF'.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCLAB_CONVERT_TABLE_PDF->M_FACTORY_OBJ
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CH_TABLE                       TYPE        STANDARD TABLE
* | [<-()] R_VALIDACAO                    TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_factory_obj.

    DATA: ol_display TYPE REF TO cl_salv_display_settings.

    TRY.
        cl_salv_table=>factory(
        EXPORTING
        list_display = if_salv_c_bool_sap=>false
        IMPORTING
        r_salv_table = DATA(ol_final_display)
        CHANGING
        t_table = ch_table ).

      CATCH cx_salv_msg.

        wa_mensagem-type    = 'E'.
        wa_mensagem-message = 'Erro no M_FACTORY_OBJ'.

    ENDTRY.

* Obtém as configurações de exibição
    ol_display = ol_final_display->get_display_settings( ).

* Ativa o padrão listrado
    ol_display->set_striped_pattern( value = cl_salv_display_settings=>true ).

    ol_final_display->display( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCLAB_CONVERT_TABLE_PDF->M_GERAR_PDF
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TABLE                        TYPE        STANDARD TABLE
* | [<-()] R_PDF                          TYPE        SOLIX_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_gerar_pdf.

    DATA(vl_validacao) = m_print_parameters( ).

    CHECK wa_mensagem-type NE 'E'.

    IF vl_validacao IS NOT INITIAL AND sy-subrc IS INITIAL.
      wa_pripar-prrel = space.
      wa_pripar-primm = space.
      NEW-PAGE PRINT ON NEW-SECTION PARAMETERS wa_pripar ARCHIVE PARAMETERS wa_arcpar NO DIALOG.
    ENDIF.

    m_factory_obj( CHANGING ch_table = i_table ).

    NEW-PAGE PRINT OFF.

    CALL FUNCTION 'ABAP4_COMMIT_WORK'.

    v_spoolid = sy-spono.

    CHECK wa_mensagem-type NE 'E'.

    r_pdf = m_convert_pdf( i_table ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCLAB_CONVERT_TABLE_PDF->M_GET_BIN_FILE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_BIN_FILE                     TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_get_bin_file.

    r_bin_file = v_bin_file.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCLAB_CONVERT_TABLE_PDF->M_GET_MENSAGEM
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_MENSAGEM                     TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_get_mensagem.

    r_mensagem = wa_mensagem.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCLAB_CONVERT_TABLE_PDF->M_PRINT_PARAMETERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_VALIDACAO                    TYPE        CHAR3
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD m_print_parameters.

    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        layout                 = 'X_65_132'
        line_count             = 65
        line_size              = 132
        no_dialog              = 'X'
      IMPORTING
        out_archive_parameters = wa_arcpar
        out_parameters         = wa_pripar
        valid                  = r_validacao.

    CHECK r_validacao IS INITIAL.

    wa_mensagem-type = 'E'.
    wa_mensagem-message = 'Erro no M_PRINT_PARAMETERS'.

  ENDMETHOD.
ENDCLASS.
