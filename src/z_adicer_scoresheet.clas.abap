class Z_ADICER_SCORESHEET definition
  public
  final
  create protected .

public section.

  interfaces ZIF_ADICER_SCORESHEET .

  aliases SCORESHEET
    for ZIF_ADICER_SCORESHEET~SCORESHEET .

  methods CONSTRUCTOR .
  class-methods GET_INSTANCE
    returning
      value(SCORE_SHEET) type ref to ZIF_ADICER_SCORESHEET .
protected section.

  methods GET_VALUE_FOR_ROLL
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !KIND type ZADICER_SCORE_CELL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_UPPER
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !KIND type ZADICER_SCORE_CELL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_X_OFAKIND
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !COUNT type I
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_FULL_HOUSE
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !KIND type ZADICER_SCORE_CELL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_ABAPDICER
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_LOW_STRAIGHT
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_HIGH_STRAIGHT
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(VALUE) type I .
  methods GET_VALUE_FOR_CHANCE
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(VALUE) type I .
private section.

  methods GET_SCORE
    importing
      !KIND type ZADICER_SCORE_CELL
    returning
      value(SCORE) type I .
  methods COUNT_DICE
    importing
      !ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !KIND type ZADICER_SCORE_CELL
    returning
      value(COUNT) type I .
  methods INIT_SCORESHEET .
ENDCLASS.



CLASS Z_ADICER_SCORESHEET IMPLEMENTATION.


  METHOD constructor.
    me->init_scoresheet( ).
  ENDMETHOD.


  METHOD count_dice.
    count = REDUCE #( INIT result = 0 FOR dice IN roll WHERE ( value = kind ) NEXT result = result + 1 ).
  ENDMETHOD.


  METHOD get_instance.

    score_sheet = NEW z_adicer_scoresheet( ).

  ENDMETHOD.


  METHOD get_score.

    score = zif_adicer_scoresheet~scoresheet[ kind = kind ]-value.
    IF score = zif_adicer_scoresheet=>empty.
      score = 0.
    ENDIF.

  ENDMETHOD.


  METHOD get_value_for_abapdicer.

    DATA current_kind TYPE zadicer_score_cell.

    DO 6 TIMES.
      current_kind = sy-index.
      DATA(current_count) = count_dice( kind = current_kind roll = roll ).
      IF current_count = 5.
        value = 50.
        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD get_value_for_chance.

    value = REDUCE #( INIT result = 0 FOR dice IN roll NEXT result = result + dice-value ).

  ENDMETHOD.


  METHOD get_value_for_full_house.

    DATA current_kind TYPE zadicer_score_cell.
    DATA two TYPE i.
    DATA three TYPE i.
    DO 6 TIMES.
      current_kind = sy-index.
      DATA(count) = count_dice( kind = current_kind roll = roll ).
      CASE count.
        WHEN 2.
          two   = count * current_kind.
        WHEN 3.
          three = count * current_kind.
        WHEN OTHERS.
          EXIT. "from do
      ENDCASE.
    ENDDO.

    IF two > 0 AND three > 0.
      value = 25.
    ELSE.
      value = 0.
    ENDIF.

  ENDMETHOD.


  METHOD GET_VALUE_FOR_HIGH_STRAIGHT.

    DATA current_kind TYPE zadicer_score_cell.
    DATA failed TYPE flag.

    DO 5 TIMES.
      current_kind = sy-index.
      DATA(current_count) = count_dice( kind = current_kind roll = roll ).
      IF current_count <> 1.
        failed = abap_true.
        EXIT.
      ENDIF.
    ENDDO.

    IF failed = abap_false.
      value = 40.
    ENDIF.

  ENDMETHOD.


  METHOD get_value_for_low_straight.

    IF  line_exists( roll[ value = 1 ] )
    AND line_exists( roll[ value = 2 ] )
    AND line_exists( roll[ value = 3 ] )
    AND line_exists( roll[ value = 4 ] ).
      value = 30.
    ELSEIF
        line_exists( roll[ value = 2 ] )
    AND line_exists( roll[ value = 3 ] )
    AND line_exists( roll[ value = 4 ] )
    AND line_exists( roll[ value = 5 ] ).
      value = 30.
    ELSEIF
        line_exists( roll[ value = 3 ] )
    AND line_exists( roll[ value = 4 ] )
    AND line_exists( roll[ value = 5 ] )
    AND line_exists( roll[ value = 6 ] ).
      value = 30.
    ENDIF.

  ENDMETHOD.


  METHOD get_value_for_roll.

    CASE kind.
      WHEN zif_adicer_scoresheet=>upper_aces
        OR zif_adicer_scoresheet=>upper_twos
        OR zif_adicer_scoresheet=>upper_threes
        OR zif_adicer_scoresheet=>upper_fours
        OR zif_adicer_scoresheet=>upper_fives
        OR zif_adicer_scoresheet=>upper_sixes.
        value = get_value_for_upper( kind = kind roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_3_ofakind.
        value = get_value_for_x_ofakind( count = 3 roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_4_ofakind.
        value = get_value_for_x_ofakind( count = 4 roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_abapdicer.
        value = get_value_for_abapdicer( roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_full_house.
        value = get_value_for_full_house( roll = roll kind = kind ).

      WHEN zif_adicer_scoresheet=>lower_small_straight.
        value = get_value_for_low_straight( roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_large_straight.
        value = get_value_for_high_straight( roll = roll ).

      WHEN zif_adicer_scoresheet=>lower_chance.
        value = get_value_for_chance( roll = roll ).

    ENDCASE.

  ENDMETHOD.


  METHOD get_value_for_upper.

    value = REDUCE #( INIT result = 0 FOR dice IN roll WHERE ( value = kind ) NEXT result = result + dice-value ).

  ENDMETHOD.


  METHOD get_value_for_x_ofakind.

    DATA current_kind TYPE zadicer_score_cell.
    DATA total TYPE i.
    DATA x_of_a_kind_flag TYPE flag.

    DO 6 TIMES.
      current_kind = sy-index.
      DATA(current_count) = count_dice( kind = current_kind roll = roll ).
      IF current_count >= count.
        x_of_a_kind_flag = abap_true.
      ENDIF.
      total = total + ( current_count * current_kind ).
    ENDDO.

    IF x_of_a_kind_flag = abap_true.
      value = total.
    ELSE.
      value = 0.
    ENDIF.

  ENDMETHOD.


  METHOD init_scoresheet.

    scoresheet = VALUE #( value = zif_adicer_scoresheet~empty
        ( kind = zif_adicer_scoresheet~upper_aces )
        ( kind = zif_adicer_scoresheet~upper_twos )
        ( kind = zif_adicer_scoresheet~upper_threes )
        ( kind = zif_adicer_scoresheet~upper_fours )
        ( kind = zif_adicer_scoresheet~upper_fives )
        ( kind = zif_adicer_scoresheet~upper_sixes )
        ( kind = zif_adicer_scoresheet~upper_bonus )
        ( kind = zif_adicer_scoresheet~lower_3_ofakind )
        ( kind = zif_adicer_scoresheet~lower_4_ofakind )
        ( kind = zif_adicer_scoresheet~lower_full_house )
        ( kind = zif_adicer_scoresheet~lower_small_straight )
        ( kind = zif_adicer_scoresheet~lower_large_straight )
        ( kind = zif_adicer_scoresheet~lower_abapdicer )
        ( kind = zif_adicer_scoresheet~lower_chance )
        ( kind = zif_adicer_scoresheet~result_upper )
        ( kind = zif_adicer_scoresheet~result_lower )
        ( kind = zif_adicer_scoresheet~result_total )
       ).

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~ask_cell_value.

    TRY.
        score = zif_adicer_scoresheet~scoresheet[ kind = kind ]-value.
      CATCH cx_sy_itab_line_not_found.
        score = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD ZIF_ADICER_SCORESHEET~CHECK_CELL_EMPTY.

    IF zif_adicer_scoresheet~ask_cell_value( kind ) = zif_adicer_scoresheet=>empty.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~check_finish.

    IF line_exists( zif_adicer_scoresheet~scoresheet[ value = zif_adicer_scoresheet~empty ] ).
      result = abap_false.
    ELSE.
      result = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_adicer_scoresheet~get_number_of_abapdicers.

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~get_readable_scoresheet.

    readable_scoresheet = VALUE #(
       ( pos =  1 kind = zif_adicer_scoresheet~upper_aces            kind_text = 'Aces'                 value = get_score( zif_adicer_scoresheet~upper_aces ) )
       ( pos =  2 kind = zif_adicer_scoresheet~upper_twos            kind_text = 'Twos'                 value = get_score( zif_adicer_scoresheet~upper_twos ) )
       ( pos =  3 kind = zif_adicer_scoresheet~upper_threes          kind_text = 'Threes'               value = get_score( zif_adicer_scoresheet~upper_threes ) )
       ( pos =  4 kind = zif_adicer_scoresheet~upper_fours           kind_text = 'Fours'                value = get_score( zif_adicer_scoresheet~upper_fours ) )
       ( pos =  5 kind = zif_adicer_scoresheet~upper_fives           kind_text = 'Fives'                value = get_score( zif_adicer_scoresheet~upper_fives ) )
       ( pos =  6 kind = zif_adicer_scoresheet~upper_sixes           kind_text = 'Sixes'                value = get_score( zif_adicer_scoresheet~upper_sixes ) )
       ( pos =  7 kind = zif_adicer_scoresheet~upper_bonus           kind_text = 'Bonus +35, if >=63'   value = get_score( zif_adicer_scoresheet~upper_bonus ) )
       ( pos =  8 kind = zif_adicer_scoresheet~result_upper          kind_text = 'Result upper section' value = get_score( zif_adicer_scoresheet~result_upper ) )

       ( pos =  9 kind = zif_adicer_scoresheet~lower_3_ofakind       kind_text = '3 of a kind'          value = get_score( zif_adicer_scoresheet~lower_3_ofakind ) )
       ( pos = 10 kind = zif_adicer_scoresheet~lower_4_ofakind       kind_text = '4 of a kind'          value = get_score( zif_adicer_scoresheet~lower_4_ofakind ) )
       ( pos = 11 kind = zif_adicer_scoresheet~lower_full_house      kind_text = 'Full house      25'   value = get_score( zif_adicer_scoresheet~lower_full_house ) )
       ( pos = 12 kind = zif_adicer_scoresheet~lower_small_straight  kind_text = 'Low straight    30'   value = get_score( zif_adicer_scoresheet~lower_small_straight ) )
       ( pos = 13 kind = zif_adicer_scoresheet~lower_large_straight  kind_text = 'High straight   40'   value = get_score( zif_adicer_scoresheet~lower_large_straight ) )
       ( pos = 14 kind = zif_adicer_scoresheet~lower_abapdicer       kind_text = 'abapDicer       50'   value = get_score( zif_adicer_scoresheet~lower_abapdicer ) )
       ( pos = 15 kind = zif_adicer_scoresheet~lower_chance          kind_text = 'Chance'               value = get_score( zif_adicer_scoresheet~lower_chance ) )
       ( pos = 16 kind = zif_adicer_scoresheet~result_lower          kind_text = 'Result lower section' value = get_score( zif_adicer_scoresheet~result_lower ) )
       ( pos = 17 kind = zif_adicer_scoresheet~result_total          kind_text = 'Grand total'          value = get_score( zif_adicer_scoresheet~result_total ) )

       ).

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~get_result.

    "Check if we can add the bonus
    DATA(result_upper) = REDUCE i( INIT points = 0
          FOR cell IN scoresheet
          WHERE ( kind >= zif_adicer_scoresheet~upper_aces
              AND kind <= zif_adicer_scoresheet~upper_sixes
              AND value <> zif_adicer_scoresheet=>empty )
           NEXT points = points + cell-value ).
    IF result_upper >= 63.
      scoresheet[ kind = zif_adicer_scoresheet~upper_bonus ]-value = 35.
    ENDIF.

    "Calculate result of upper section
    scoresheet[ kind = zif_adicer_scoresheet~result_upper ]-value =
       REDUCE i( INIT points = 0
           FOR cell IN scoresheet
           WHERE ( kind >= zif_adicer_scoresheet~upper_aces
               AND kind <= zif_adicer_scoresheet~upper_bonus
               AND value <> zif_adicer_scoresheet=>empty )
            NEXT points = points + cell-value ).

    "Calculate result of lower section
    scoresheet[ kind = zif_adicer_scoresheet~result_lower ]-value =
       REDUCE i( INIT points = 0
           FOR cell IN scoresheet
           WHERE ( kind >= zif_adicer_scoresheet~lower_3_ofakind
               AND kind <= zif_adicer_scoresheet~lower_chance
               AND value <> zif_adicer_scoresheet=>empty )
            NEXT points = points + cell-value ).

    "Calculate total result
    scoresheet[ kind = zif_adicer_scoresheet~result_total ]-value
     = scoresheet[ kind = zif_adicer_scoresheet~result_upper ]-value
     + scoresheet[ kind = zif_adicer_scoresheet~result_lower ]-value.

    "Return result
    result = scoresheet[ kind = zif_adicer_scoresheet~result_total ]-value.

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~get_scoresheet.
    scoresheet = me->zif_adicer_scoresheet~scoresheet.
  ENDMETHOD.


  METHOD zif_adicer_scoresheet~get_scoresheet_in_line.

    score_line-upper_aces            = get_score( zif_adicer_scoresheet~upper_aces ).
    score_line-upper_twos            = get_score( zif_adicer_scoresheet~upper_twos ).
    score_line-upper_threes          = get_score( zif_adicer_scoresheet~upper_threes ).
    score_line-upper_fours           = get_score( zif_adicer_scoresheet~upper_fours ).
    score_line-upper_fives           = get_score( zif_adicer_scoresheet~upper_fives ).
    score_line-upper_sixes           = get_score( zif_adicer_scoresheet~upper_sixes ).
    score_line-upper_bonus           = get_score( zif_adicer_scoresheet~upper_bonus ).
    score_line-upper_result          = get_score( zif_adicer_scoresheet~result_upper ).
    score_line-lower_3ofakind        = get_score( zif_adicer_scoresheet~lower_3_ofakind ).
    score_line-lower_4ofakind        = get_score( zif_adicer_scoresheet~lower_4_ofakind ).
    score_line-lower_full_house      = get_score( zif_adicer_scoresheet~lower_full_house ).
    score_line-lower_low_straight    = get_score( zif_adicer_scoresheet~lower_small_straight ).
    score_line-lower_high_straight   = get_score( zif_adicer_scoresheet~lower_large_straight ).
    score_line-lower_abapdicer       = get_score( zif_adicer_scoresheet~lower_abapdicer ).
    score_line-lower_chance          = get_score( zif_adicer_scoresheet~lower_chance ).
    score_line-lower_result          = get_score( zif_adicer_scoresheet~result_lower ).
    score_line-grand_total           = get_score( zif_adicer_scoresheet~result_total ).

  ENDMETHOD.


  METHOD zif_adicer_scoresheet~receive_decision.
    " Where do we put game rules ?

    READ TABLE zif_adicer_scoresheet~scoresheet
    ASSIGNING FIELD-SYMBOL(<cell>)
    WITH KEY kind = decision.
    IF sy-subrc > 0.
      "decision made is not valid
      RAISE EXCEPTION TYPE zcx_adicer_invalid_decision.

    ELSEIF <cell>-value <> zif_adicer_scoresheet=>empty
    AND    decision     <> zif_adicer_scoresheet=>lower_abapdicer.
      "cell already in placed before
      RAISE EXCEPTION TYPE zcx_adicer_cell_already_taken.
    ELSE.
      "get value for current dice roll
      DATA(value) = get_value_for_roll(
        EXPORTING
          roll = dice_results
          kind = <cell>-kind ).
      IF  decision = zif_adicer_scoresheet=>lower_abapdicer.
        "special treatment abapDicer 5-of-a-kind
        IF <cell>-value = zif_adicer_scoresheet=>empty.
          "if cell was empty (-1) set new value
          <cell>-value = value.
          ADD 1 TO zif_adicer_scoresheet~number_of_5_of_a_kind.
        ELSE.
          IF value > 0.
            "plus special case: if there is abapDicer then points are +100
            "but method for setting score cannot know.
            ADD 100 TO <cell>-value.
            ADD 1 TO zif_adicer_scoresheet~number_of_5_of_a_kind.
          ELSE.
            "strategy said 5-of-a-kind but it wasn't and 5-of-a-kind already set
            "so: discard existing cell results... sorry, but that's the game...
            READ TABLE zif_adicer_scoresheet~scoresheet
            ASSIGNING FIELD-SYMBOL(<discard_cell>)
            WITH KEY kind = zif_adicer_scoresheet=>empty.
            IF sy-subrc = 0.
              <discard_cell>-value = 0.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        "set cell value for any other than 5-of-a-kind
        <cell>-value = value.
      ENDIF.
    ENDIF.

    "return score
    score = zif_adicer_scoresheet~get_result( ).


  ENDMETHOD.
ENDCLASS.
