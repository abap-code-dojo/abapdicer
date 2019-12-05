CLASS ltcl_dice DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA f_cut TYPE REF TO zif_adicer_dice_engine.
    METHODS:
      setup,
      check_between_1_and_6 FOR TESTING.
ENDCLASS.


CLASS ltcl_dice IMPLEMENTATION.

  METHOD check_between_1_and_6.
    DATA randomresult TYPE i.
    DATA is_between_1_and_6 TYPE abap_bool.
    DO 1000 TIMES.
      randomresult = f_cut->generate_random( ).
      is_between_1_and_6 = COND #( WHEN randomresult BETWEEN 1 AND 6
      THEN abap_true
      ELSE abap_false ).
      cl_abap_unit_assert=>assert_equals(
        EXPORTING
          act                  = is_between_1_and_6
          exp                  = abap_true    ).
    ENDDO.
  ENDMETHOD.

  METHOD setup.
    f_cut = z_adicer_dice_engine=>factory( seed = 1 ).

  ENDMETHOD.

ENDCLASS.
