class Z_ADICER_STRATEGY_ENNO definition
  public
  create public .

public section.

  interfaces ZIF_ADICER_STRATEGY .
  PROTECTED SECTION.

    DATA favorite_kind TYPE zadicer_score_cell .
    DATA abapdicer_count TYPE i .
private section.

  methods KEEP_ALL_DICE
    changing
      !DICE_ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL .
  methods KEEP_DICE_VALUE
    importing
      !VALUE type ZADICER_SCORE_CELL
    changing
      !DICE_ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL .
ENDCLASS.



CLASS Z_ADICER_STRATEGY_ENNO IMPLEMENTATION.


  METHOD keep_all_dice.

    LOOP AT dice_roll ASSIGNING FIELD-SYMBOL(<dice>).
      <dice>-keep = abap_true.
    ENDLOOP.

  ENDMETHOD.


  METHOD keep_dice_value.

    LOOP AT dice_roll ASSIGNING FIELD-SYMBOL(<dice>)
    WHERE value = value.
      <dice>-keep = abap_true.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_result.
    score_cell = favorite_kind.
  ENDMETHOD.


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

    "prepare own dice roll to detect straights
    my_dice_roll = CORRESPONDING #( dice_roll ).
    SORT my_dice_roll BY value ASCENDING.
    DELETE ADJACENT DUPLICATES FROM my_dice_roll COMPARING value.

    "set default decision to CHANCE if no other fits
    favorite_kind = zif_adicer_scoresheet=>lower_chance.

    "build decision table: count number of each cube
    "1,2,2,5,5
    "will be
    " 1: 1
    " 2: 2
    " 3: 0
    " 4: 0
    " 5: 2
    " 6: 0
    decision_table = VALUE #(
      ( kind = 1 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 1 ) NEXT count = count + 1 ) )
      ( kind = 2 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 2 ) NEXT count = count + 1 ) )
      ( kind = 3 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 3 ) NEXT count = count + 1 ) )
      ( kind = 4 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 4 ) NEXT count = count + 1 ) )
      ( kind = 5 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 5 ) NEXT count = count + 1 ) )
      ( kind = 6 count = REDUCE i( INIT count = 0 FOR dice IN dice_roll WHERE ( value = 6 ) NEXT count = count + 1 ) )
      ).

    "sort descending by number of cubes
    " 2: 2
    " 5: 2
    " 1: 1
    " 3: 0
    " 4: 0
    " 6: 0

*    SORT decision_table BY
*      count DESCENDING "most values on top
*      kind DESCENDING. "high values on top
    SORT decision_table BY
      count DESCENDING "most values on top
      kind ASCENDING. "high values on top


    DATA(max) = decision_table[ 1 ].

    IF max-count = 5.
      "yeaaah: abapDicer!! set all dice to KEEP
      favorite_kind = zif_adicer_scoresheet=>lower_abapdicer.
      keep_all_dice( CHANGING dice_roll = dice_roll ).
      ADD 1 TO abapdicer_count.
      RETURN.
    ENDIF.


    IF  decision_table[ 1 ]-count = 1
    AND decision_table[ 2 ]-count = 1
    AND decision_table[ 3 ]-count = 1
    AND decision_table[ 4 ]-count = 1
    AND decision_table[ 5 ]-count = 1.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_large_straight ).
        favorite_kind = zif_adicer_scoresheet=>lower_large_straight.
        keep_all_dice( CHANGING dice_roll = dice_roll ).
        RETURN.
      ENDIF.
    ELSEIF lines( my_dice_roll ) = 4
    AND my_dice_roll[ 1 ]-value = 1
    AND my_dice_roll[ 2 ]-value = 2
    AND my_dice_roll[ 3 ]-value = 3
    AND my_dice_roll[ 4 ]-value = 4.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_small_straight ).
        favorite_kind = zif_adicer_scoresheet=>lower_small_straight.
        keep_all_dice( CHANGING dice_roll = dice_roll ).
        RETURN.
      ENDIF.
    ELSEIF lines( my_dice_roll ) = 4
    AND my_dice_roll[ 1 ]-value = 2
    AND my_dice_roll[ 2 ]-value = 3
    AND my_dice_roll[ 3 ]-value = 4
    AND my_dice_roll[ 4 ]-value = 5.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_small_straight ).
        favorite_kind = zif_adicer_scoresheet=>lower_small_straight.
        keep_all_dice( CHANGING dice_roll = dice_roll ).
        RETURN.
      ENDIF.

    ELSEIF  decision_table[ 1 ]-count = 3
    AND     decision_table[ 2 ]-count = 2.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_full_house ).
        favorite_kind = zif_adicer_scoresheet=>lower_full_house.
        keep_all_dice( CHANGING dice_roll = dice_roll ).
        RETURN.
      ENDIF.

    ELSEIF decision_table[ 1 ]-count = 4.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_4_ofakind ).
        IF round <= 2.
          "try to gain 5-of-a-kind with next throws
          keep_dice_value(
            EXPORTING
              value = decision_table[ 1 ]-kind
            CHANGING
              dice_roll = dice_roll ).
        ELSE.
          "take 4-of-akind
          favorite_kind = zif_adicer_scoresheet=>lower_4_ofakind.
          keep_all_dice( CHANGING dice_roll = dice_roll ).
        ENDIF.
        RETURN.
      ENDIF.

    ELSEIF decision_table[ 1 ]-count = 3.
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_3_ofakind ).
        favorite_kind = zif_adicer_scoresheet=>lower_3_ofakind.
        keep_all_dice( CHANGING dice_roll = dice_roll ).
        RETURN.
      ENDIF.
    ENDIF.


    "check and set upper section
    IF scoresheet->ask_cell_value( kind = max-kind ) = zif_adicer_scoresheet=>empty.
      favorite_kind = max-kind.
      LOOP AT dice_roll ASSIGNING FIELD-SYMBOL(<dice>).
        IF <dice>-value = max-kind.
          "keep all dice with this max value
          <dice>-keep = abap_true.
        ELSE.
          <dice>-keep = abap_false.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
