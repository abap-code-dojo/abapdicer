class Z_ADICER_STRATEGY_JCK definition
  public
  create public .

public section.

  interfaces ZIF_ADICER_STRATEGY .
protected section.

  data ABAP_DICER type ZADICER_SCORE_CELL .
  data ABAPDICER_COUNT type I .
private section.
ENDCLASS.



CLASS Z_ADICER_STRATEGY_JCK IMPLEMENTATION.


  method ZIF_ADICER_STRATEGY~DECIDE_ON_RESULT.
    score_cell = zif_adicer_scoresheet=>lower_abapdicer. "abapdicer
  endmethod.


  METHOD zif_adicer_strategy~decide_on_roll.

    TYPES: BEGIN OF decision,
             kind  TYPE zadicer_score_cell,
             count TYPE i,
           END OF decision,
           decisions TYPE STANDARD TABLE OF decision WITH EMPTY KEY.
    DATA decision_table TYPE decisions.
    TYPES: BEGIN OF ts_my_dice_roll,
             value TYPE i,
           END OF ts_my_dice_roll.
    DATA my_dice_roll TYPE STANDARD TABLE OF ts_my_dice_roll.

    my_dice_roll = CORRESPONDING #( dice_roll ).
    SORT my_dice_roll BY value ASCENDING.

    DATA(duplicate_dice) = my_dice_roll.


*** First check if two or more same ***
    DELETE ADJACENT DUPLICATES FROM duplicate_dice COMPARING value.
    DESCRIBE TABLE duplicate_dice LINES DATA(tab_lines).
    IF tab_lines < 5. "Great found two or more same
      LOOP AT my_dice_roll INTO DATA(ls_pick_out).
*       read table
      ENDLOOP.
    ELSE. "Do i Choose one or throw again?

    ENDIF.






  ENDMETHOD.
ENDCLASS.
