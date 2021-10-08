interface ZIF_ADICER_GAME_ENGINE
  public .


  types:
    BEGIN OF ts_strategy,
           strategy_name  TYPE zadicer_game_strategy,
         END OF ts_strategy .
  types:
    tt_strategies TYPE TABLE OF ts_strategy .

  constants VARIANT_NORMAL type CHAR1 value 'N' ##NO_TEXT.
  constants VARIANT_PARALLEL type CHAR1 value 'P' ##NO_TEXT.
  data NUMBER_OF_ROUNDS type I .

  methods START
    importing
      !NUMBERS_GAMES type INT4
      !STRATEGIES type TT_STRATEGIES
      !VARIANT type CHAR1
      !SEED type I .
  methods GET_AVERAGE
    returning
      value(RESULT) type I .
  methods SHOW_RESULT .
endinterface.
