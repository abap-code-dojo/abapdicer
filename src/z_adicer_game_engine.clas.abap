CLASS z_adicer_game_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_adicer_game_engine .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_player,
        player_id   TYPE int4,
        strategy    TYPE REF TO zif_adicer_strategy,
        score_sheet TYPE REF TO zif_adicer_scoresheet,
      END OF ts_player .
  types:
    tt_players TYPE TABLE OF ts_player .

  data PLAYERS type TT_PLAYERS .
  data DICER type ref to ZIF_ADICER_DICE_ENGINE .
  data:
    players_in_game TYPE TABLE OF int4 .
  data:
    score_table TYPE STANDARD TABLE OF zadicer_scoresheet_grid WITH EMPTY KEY .

  methods HANDLE_SCORE_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN .
  methods SHOW_RESULT .
  methods INIT
    importing
      !SEED type I .
  methods PLAY_TURN
    importing
      !PLAYER type TS_PLAYER .
  methods WRITE_TURN .
  methods CHECK_FINISH .
  methods SAVE_GAME .
  methods DETERMINE_STRATEGY
    importing
      !STRATEGY_NAME type ZADICER_GAME_STRATEGY
    returning
      value(STRATEGY) type ref to ZIF_ADICER_STRATEGY
    exceptions
      ERROR_INST_CREATION .
  methods PLAY_GAME .
  methods CHECK_PLAYER_STATE .
  methods VALIDATE_DICEROLL
    importing
      !DICE_ROLL_ORIGINAL type ref to ZIF_ADICER_DICE_ENGINE=>TT_ROLL
      !DICE_ROLL_STRATEGY type ref to ZIF_ADICER_DICE_ENGINE=>TT_ROLL
    returning
      value(IS_VALID) type ABAP_BOOL .
ENDCLASS.



CLASS Z_ADICER_GAME_ENGINE IMPLEMENTATION.


  METHOD check_finish.
    LOOP AT players_in_game INTO DATA(player_in_game).
      "Spieblatt prüfen
      " wie? Kein PLAN!!!!!
    ENDLOOP.
  ENDMETHOD.


  METHOD check_player_state.
    DATA player TYPE ts_player.
    LOOP AT players INTO player.
*      player-SCORE_SHEET->check_finish( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD determine_strategy.

    DATA(type) = |{ strategy_name CASE = UPPER }|.

    CREATE OBJECT strategy TYPE (type).

    IF strategy IS INITIAL.
      RAISE error_inst_creation.
    ENDIF.

  ENDMETHOD.


  METHOD handle_score_double_click.

    READ TABLE score_table INTO DATA(score) INDEX row.
    CHECK sy-subrc = 0.

    cl_demo_output=>display_data( score-scoresheet->get_readable_scoresheet( ) ).

  ENDMETHOD.


  METHOD init.
    dicer = z_adicer_dice_engine=>factory( seed = seed ).
  ENDMETHOD.


  METHOD play_game.

    "there are 13 rounds per game:
    "6 on the top
    "plus bottom:
    "3er Pasch
    "4er Pasch
    "Full House
    "small street
    "great street
    "chance
    "5-of-a-kind
    DO 13 TIMES.
      LOOP AT players INTO DATA(playerdata).
        me->play_turn( playerdata ).
      ENDLOOP.
    ENDDO.

    "extra rounds when there were 5-of-a-kind

    LOOP AT players INTO playerdata.
      "one extra throw for each additional 5-of-a-kind
      DO playerdata-score_sheet->number_of_5_of_a_kind - 1 TIMES.
        me->play_turn( playerdata ).
      ENDDO.
    ENDLOOP.



  ENDMETHOD.


  METHOD play_turn.

    DATA diceroll TYPE zif_adicer_dice_engine=>tt_roll.
    DATA diceroll_strategy TYPE zif_adicer_dice_engine=>tt_roll.
    DATA round TYPE i.

    DO 3 TIMES.

      ADD 1 TO round.
      diceroll = dicer->get_results( last_roll = diceroll_strategy ).

      "Make copy of original diceroll
      diceroll_strategy = diceroll.

      player-strategy->decide_on_roll(
        EXPORTING
          round       = round
          scoresheet  = player-score_sheet
        CHANGING
          dice_roll   = diceroll_strategy ).

      IF NOT line_exists( diceroll_strategy[ keep = space ] ).
        "all dice should be kept: we can break up this turn
        EXIT. "from do
      ENDIF.
    ENDDO.

    "make sure to have the original dice values
    "(strategy is only allowed to change KEEP but not the values...!)
    LOOP AT diceroll_strategy ASSIGNING FIELD-SYMBOL(<dice>).
      <dice>-value = diceroll[ sy-tabix ]-value.
    ENDLOOP.

    "Ask strategy for the decision
    DATA(strategy_result) = player-strategy->decide_on_result( ).

    TRY.
        "set strategy's decision to score sheet
        DATA(score) = player-score_sheet->receive_decision(
          decision     = strategy_result
          dice_results = diceroll_strategy ).
      CATCH zcx_adicer_scoresheet INTO DATA(scoresheet_error).
    ENDTRY.

  ENDMETHOD.


  METHOD save_game.

  ENDMETHOD.


  METHOD show_result.

    DATA score_line  TYPE zadicer_scoresheet_grid.
    DATA grand_total_sum TYPE i.

    LOOP AT players INTO DATA(playerdata).
      score_line-scoresheet  = playerdata-score_sheet.
      score_line-scores      = playerdata-score_sheet->get_scoresheet_in_line( ).
      APPEND score_line TO score_table.
      ADD score_line-scores-grand_total TO grand_total_sum.
    ENDLOOP.

    DATA(average) = grand_total_sum / zif_adicer_game_engine~number_of_rounds.

    MESSAGE |average grand total: { average }| TYPE 'S'.


    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table   = DATA(score_grid)
          CHANGING
            t_table        = score_table
        ).
        score_grid->get_functions( )->set_all( ).

        DATA(cols) = score_grid->get_columns( ).
        cols->get_column( 'SCORESHEET' )->set_technical( abap_true ).
        cols->set_color_column( '_COLOR_' ).
        cast cl_salv_column_table( cols->get_column( 'UPPER_BONUS' ) )->set_color( value #( col = col_key int = 0 ) ).
        cast cl_salv_column_table( cols->get_column( 'UPPER_RESULT' ) )->set_color( value #( col = col_total int = 0 ) ).
        cast cl_salv_column_table( cols->get_column( 'LOWER_ABAPDICER' ) )->set_color( value #( col = col_group ) ).
        cast cl_salv_column_table( cols->get_column( 'LOWER_RESULT' ) )->set_color( value #( col = col_total int = 0 ) ).
        cast cl_salv_column_table( cols->get_column( 'GRAND_TOTAL' ) )->set_color( value #( col = col_total int = 1 ) ).
        SET HANDLER handle_score_double_click FOR score_grid->get_event( ).
        score_grid->display( ).
      CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error.
    ENDTRY.

  ENDMETHOD.


  METHOD validate_diceroll.
    is_valid = abap_true.
  ENDMETHOD.


  METHOD write_turn.

  ENDMETHOD.


  METHOD zif_adicer_game_engine~start.
    DATA: player TYPE ts_player.

    "save total number of rounds
    zif_adicer_game_engine~number_of_rounds = numbers_games.

    DO numbers_games TIMES.
      LOOP AT strategies INTO DATA(strategy).
        CLEAR player.
        player-strategy    = determine_strategy( strategy_name = strategy-strategy_name ).
        player-score_sheet = z_adicer_scoresheet=>get_instance( ).
        player-player_id   = 1.
        APPEND player TO players.
      ENDLOOP.
    ENDDO.

    init( seed ).
    play_game(  ).
    show_result( ).

  ENDMETHOD.
ENDCLASS.
