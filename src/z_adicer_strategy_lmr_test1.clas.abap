CLASS z_adicer_strategy_lmr_test1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_adicer_strategy .


  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_dice,
        diceid TYPE i,
        value  TYPE i,
        keep   TYPE abap_bool,
      END OF ts_dice .
    TYPES:
      BEGIN OF tt_dice_roll,
        ts_dice TYPE SORTED TABLE OF ts_dice WITH UNIQUE KEY diceid,
      END OF tt_dice_roll .
    TYPES:
      tt_roll TYPE SORTED TABLE OF ts_dice WITH UNIQUE KEY diceid .

    DATA _scoresheet TYPE REF TO zif_adicer_scoresheet .
    DATA _dice_roll TYPE tt_roll .

    METHODS check_kniffel .
    METHODS check_small_street .
    METHODS check_large_street .
    METHODS check_four_a_kind .
    METHODS check_three_a_kind .
    METHODS check_ones
      RETURNING
        VALUE(score) TYPE i .
    METHODS check_twos
      RETURNING
        VALUE(score) TYPE i .
    METHODS check_threes
      RETURNING
        VALUE(score) TYPE i .
    METHODS check_fours
      RETURNING
        VALUE(score) TYPE i .
    METHODS check_fives
      RETURNING
        VALUE(score) TYPE i .
    METHODS check_sixes
      RETURNING
        VALUE(score) TYPE i .
ENDCLASS.



CLASS Z_ADICER_STRATEGY_LMR_TEST1 IMPLEMENTATION.


  METHOD check_fives.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 5.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_fours.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 4.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_four_a_kind.

  ENDMETHOD.


  METHOD check_kniffel.
  ENDMETHOD.


  METHOD check_large_street.
  ENDMETHOD.


  METHOD check_ones.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 1.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_sixes.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 6.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_small_street.
  ENDMETHOD.


  METHOD check_threes.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 3.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_three_a_kind.
  ENDMETHOD.


  METHOD check_twos.
    DATA(__dice_roll) = _dice_roll.
    FIELD-SYMBOLS <dice> TYPE ts_dice.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-value = 2.
        <dice>-keep = abap_true.
      ENDIF.
    ENDLOOP.
    LOOP AT __dice_roll ASSIGNING <dice>.
      IF <dice>-keep = abap_true.
        ADD 1 TO score .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_result.

    CONSTANTS upper_aces TYPE zadicer_score_cell VALUE 1 ##NO_TEXT.
    CONSTANTS upper_twos TYPE zadicer_score_cell VALUE 2 ##NO_TEXT.
    CONSTANTS upper_threes TYPE zadicer_score_cell VALUE 3 ##NO_TEXT.
    CONSTANTS upper_fours TYPE zadicer_score_cell VALUE 4 ##NO_TEXT.
    CONSTANTS upper_fives TYPE zadicer_score_cell VALUE 5 ##NO_TEXT.
    CONSTANTS upper_sixes TYPE zadicer_score_cell VALUE 6 ##NO_TEXT.
    CONSTANTS upper_bonus TYPE zadicer_score_cell VALUE 7 ##NO_TEXT.
    CONSTANTS lower_3_ofakind TYPE zadicer_score_cell VALUE 11 ##NO_TEXT.
    CONSTANTS lower_4_ofakind TYPE zadicer_score_cell VALUE 12 ##NO_TEXT.
    CONSTANTS lower_full_house TYPE zadicer_score_cell VALUE 13 ##NO_TEXT.
    CONSTANTS lower_small_straight TYPE zadicer_score_cell VALUE 14 ##NO_TEXT.
    CONSTANTS lower_large_straight TYPE zadicer_score_cell VALUE 15 ##NO_TEXT.
    CONSTANTS lower_abapdicer TYPE zadicer_score_cell VALUE 16 ##NO_TEXT.
    CONSTANTS lower_chance TYPE zadicer_score_cell VALUE 17 ##NO_TEXT.
    CONSTANTS result_upper TYPE zadicer_score_cell VALUE 21 ##NO_TEXT.
    CONSTANTS result_lower TYPE zadicer_score_cell VALUE 22 ##NO_TEXT.
    CONSTANTS result_total TYPE zadicer_score_cell VALUE 23 ##NO_TEXT.

    DATA: random_object TYPE REF TO cl_abap_random_int.
    DATA: seed TYPE i.
    DATA: min TYPE i.
    DATA: max TYPE i.

    min = 3.
    max = 17.

    seed = cl_abap_random=>seed( ).

    cl_abap_random_int=>create(
      EXPORTING
        seed = seed
        min = min
        max = max
      RECEIVING
        prng = random_object
    ).

    DATA(rnd) = random_object->get_next( ).

    score_cell = SWITCH #( rnd
    WHEN 7 THEN 8
    ELSE rnd ).

  ENDMETHOD.


  METHOD zif_adicer_strategy~decide_on_roll.

    _scoresheet = scoresheet.
    _dice_roll = dice_roll.

    TYPES: BEGIN OF ts_score,
             scoretype TYPE string,
             score     TYPE i,
           END OF ts_score.



    DATA: score_table TYPE TABLE OF ts_score.
    FIELD-SYMBOLS <scoreline> TYPE ts_score.

    LOOP AT score_table ASSIGNING <scoreline>.

      <scoreline>-scoretype = SWITCH #( sy-index
      WHEN 1 THEN 'ones'
      WHEN 2 THEN 'twos'
      WHEN 3 THEN 'threes'
      WHEN 4 THEN 'fours'
      WHEN 5 THEN 'fives'
      WHEN 6 THEN 'sixes'
      WHEN 7 THEN 'three_a_kind'
      WHEN 8 THEN 'four_a_kind'
      WHEN 9 THEN 'small_street'
      WHEN 10 THEN 'large_street'
      WHEN 11 THEN 'full_house'
      WHEN 12 THEN 'kniffel'
      ).
      .





    ENDLOOP.
    me->check_ones( ).
    me->check_twos( ).
    me->check_threes( ).
    me->check_fours( ).
    me->check_fives( ).
    me->check_sixes( ).
    me->check_three_a_kind( ).
    me->check_four_a_kind( ).
    me->check_small_street( ).
    me->check_large_street( ).
    me->check_kniffel( ).


  ENDMETHOD.
ENDCLASS.
