class Z_ADICER_STRATEGY_TST_CHANCE definition
  public
  final
  create public .

public section.

  interfaces ZIF_ADICER_STRATEGY .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_ADICER_STRATEGY_TST_CHANCE IMPLEMENTATION.


  METHOD zif_adicer_strategy~decide_on_result.
    score_cell = zif_adicer_scoresheet=>lower_chance.
  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_roll.
  ENDMETHOD.
ENDCLASS.
