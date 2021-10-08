*&---------------------------------------------------------------------*
*& Report zadicer_hitlist
*&---------------------------------------------------------------------*
" a hitlist of all existing strategies.
"

REPORT zadicer_hitlist.


PARAMETERS numgames TYPE i DEFAULT 100.
PARAMETERS seed     TYPE i DEFAULT 1.

CLASS main DEFINITION.
  PUBLIC SECTION.
    METHODS start
      IMPORTING
        number_of_games TYPE i.
  PRIVATE SECTION.
    DATA strategy TYPE REF TO zif_adicer_strategy.
    DATA game TYPE REF TO zif_adicer_game_engine.

ENDCLASS.

CLASS strategy_helper DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF strategy_id,
             id      TYPE char12,
             clsname TYPE seoclsname,
           END OF strategy_id,
           strategy_ids TYPE SORTED TABLE OF strategy_id WITH UNIQUE KEY id.
    CLASS-METHODS get_strategies
      RETURNING
        VALUE(strategies) TYPE strategy_ids.

  PRIVATE SECTION.

    CLASS-DATA strategies TYPE strategy_ids.

ENDCLASS.



CLASS main IMPLEMENTATION.
  METHOD start.

    TYPES: BEGIN OF _hitlist_entry,
             strategy TYPE seoclsname,
             average  TYPE i,
             runtime  type i,
           END OF _hitlist_entry,
           _hitlist TYPE STANDARD TABLE OF _hitlist_entry WITH DEFAULT KEY.
    DATA hitlist TYPE _hitlist.

    LOOP AT strategy_helper=>get_strategies( ) INTO DATA(strategy).
      game = NEW z_adicer_game_engine( ).

      get run TIME FIELD data(start).
      game->start(
          numbers_games = number_of_games
          strategies    = VALUE #( ( strategy_name  = strategy-clsname ) )
          variant       = space
          seed          = seed ).
      get RUN TIME FIELD data(stopp).

      APPEND VALUE #(
        strategy = strategy-clsname
        average  = game->get_average( )
        runtime  = stopp - start ) TO hitlist.
    ENDLOOP.

    SORT hitlist BY average DESCENDING.



    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = data(salv_table)
      CHANGING
        t_table        = hitlist ).
    salv_table->get_functions( )->set_default( ).
    data(columns) = salv_table->get_columns( ).
    columns->get_column( 'STRATEGY' )->set_medium_text( 'Strategy' ).
    columns->get_column( 'AVERAGE' )->set_medium_text( 'Average result' ).
    columns->get_column( 'RUNTIME' )->set_medium_text( 'Runt time' ).
    salv_table->display( ).

  ENDMETHOD.

ENDCLASS.

CLASS strategy_helper IMPLEMENTATION.

  METHOD get_strategies.

    TRY.
        strategies = VALUE strategy_ids(
                             FOR class IN NEW cl_oo_interface( 'ZIF_ADICER_STRATEGY' )->get_implementing_classes( )
                                    ( id  = class-clsname+18(12)
                                      clsname = class-clsname ) ).
      CATCH cx_class_not_existent.
    ENDTRY.

  ENDMETHOD.


ENDCLASS.


START-OF-SELECTION.

  DATA(game) = NEW main( ).
  game->start(
    EXPORTING
      number_of_games  = numgames ).
