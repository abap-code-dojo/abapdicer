CLASS z_adicer_strategy_tst_5ofakind DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_adicer_strategy .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_adicer_strategy_tst_5ofakind IMPLEMENTATION.


  METHOD zif_adicer_strategy~decide_on_result.
    score_cell = zif_adicer_scoresheet=>lower_abapdicer.
  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_roll.
  ENDMETHOD.
ENDCLASS.
