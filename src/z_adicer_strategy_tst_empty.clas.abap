CLASS z_adicer_strategy_tst_empty DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_adicer_strategy .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_ADICER_STRATEGY_TST_EMPTY IMPLEMENTATION.


  METHOD zif_adicer_strategy~decide_on_result.
    RETURN.
  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_roll.
    RETURN.
  ENDMETHOD.
ENDCLASS.
