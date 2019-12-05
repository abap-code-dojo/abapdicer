interface ZIF_ADICER_STRATEGY
  public .


  data DICEROLL type INTEGER .
  data SCORESHEET type INTEGER .

  methods DECIDE_ON_ROLL
    importing
      !ROUND type Z_ADICER_ROUND_COUNTER
      !SCORESHEET type ref to ZIF_ADICER_SCORESHEET
    changing
      !DICE_ROLL type ZIF_ADICER_DICE_ENGINE=>TT_ROLL .
  methods DECIDE_ON_RESULT
    returning
      value(SCORE_CELL) type ZADICER_SCORE_CELL .
endinterface.
