interface ZIF_ADICER_SCORESHEET
  public .


  types:
    BEGIN OF ts_scoresheet_cell,
      kind  TYPE zadicer_score_cell,
      value TYPE i,
    END OF ts_scoresheet_cell .
  types:
    tt_scoresheet TYPE SORTED TABLE OF ts_scoresheet_cell WITH UNIQUE KEY kind .
  types:
    BEGIN OF ts_readable_scoresheet,
           pos       TYPE i,
           kind      TYPE  zadicer_score_cell,
           kind_text TYPE c LENGTH 20,
           value     TYPE i,
         END OF ts_readable_scoresheet .
  types:
    tt_readable_scoresheet TYPE SORTED TABLE OF ts_readable_scoresheet WITH UNIQUE KEY pos .

  constants UPPER_ACES type ZADICER_SCORE_CELL value 1 ##NO_TEXT.
  constants UPPER_TWOS type ZADICER_SCORE_CELL value 2 ##NO_TEXT.
  constants UPPER_THREES type ZADICER_SCORE_CELL value 3 ##NO_TEXT.
  constants UPPER_FOURS type ZADICER_SCORE_CELL value 4 ##NO_TEXT.
  constants UPPER_FIVES type ZADICER_SCORE_CELL value 5 ##NO_TEXT.
  constants UPPER_SIXES type ZADICER_SCORE_CELL value 6 ##NO_TEXT.
  constants UPPER_BONUS type ZADICER_SCORE_CELL value 7 ##NO_TEXT.
  constants LOWER_3_OFAKIND type ZADICER_SCORE_CELL value 11 ##NO_TEXT.
  constants LOWER_4_OFAKIND type ZADICER_SCORE_CELL value 12 ##NO_TEXT.
  constants LOWER_FULL_HOUSE type ZADICER_SCORE_CELL value 13 ##NO_TEXT.
  constants LOWER_SMALL_STRAIGHT type ZADICER_SCORE_CELL value 14 ##NO_TEXT.
  constants LOWER_LARGE_STRAIGHT type ZADICER_SCORE_CELL value 15 ##NO_TEXT.
  constants LOWER_ABAPDICER type ZADICER_SCORE_CELL value 16 ##NO_TEXT.
  constants LOWER_CHANCE type ZADICER_SCORE_CELL value 17 ##NO_TEXT.
  constants RESULT_UPPER type ZADICER_SCORE_CELL value 21 ##NO_TEXT.
  constants RESULT_LOWER type ZADICER_SCORE_CELL value 22 ##NO_TEXT.
  constants RESULT_TOTAL type ZADICER_SCORE_CELL value 23 ##NO_TEXT.
  data SCORESHEET type TT_SCORESHEET .
  constants EMPTY type I value -1 ##NO_TEXT.
  data NUMBER_OF_5_OF_A_KIND type I .

  methods RECEIVE_DECISION
    importing
      !DECISION type ZADICER_SCORE_CELL
      !DICE_RESULTS type ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(SCORE) type I
    raising
      ZCX_ADICER_SCORESHEET .
  methods GET_SCORESHEET
    returning
      value(SCORESHEET) type TT_SCORESHEET .
  methods GET_RESULT
    returning
      value(RESULT) type I .
  methods GET_NUMBER_OF_ABAPDICERS
    returning
      value(COUNT) type I .
  methods CHECK_FINISH
    returning
      value(RESULT) type FLAG .
  methods ASK_CELL_VALUE
    importing
      !KIND type ZADICER_SCORE_CELL
    returning
      value(SCORE) type I .
  methods GET_READABLE_SCORESHEET
    returning
      value(READABLE_SCORESHEET) type TT_READABLE_SCORESHEET .
  methods GET_SCORESHEET_IN_LINE
    returning
      value(SCORE_LINE) type ZADICER_SCORESHEET_LINE .
  methods CHECK_CELL_EMPTY
    importing
      !KIND type ZADICER_SCORE_CELL
    returning
      value(RESULT) type FLAG .
endinterface.
