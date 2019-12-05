class Z_ADICER_STRATEGY_TST_5OFAKIND definition
  public
  final
  create public .

public section.

  interfaces ZIF_ADICER_STRATEGY .
protected section.
private section.
ENDCLASS.



CLASS Z_ADICER_STRATEGY_TST_5OFAKIND IMPLEMENTATION.


  METHOD zif_adicer_strategy~decide_on_result.
    score_cell = zif_adicer_scoresheet=>lower_abapdicer.
  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_roll.
  ENDMETHOD.
ENDCLASS.
