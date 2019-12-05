*&---------------------------------------------------------------------*
*& Report zadicer_game
*&---------------------------------------------------------------------*

REPORT zadicer_game.


PARAMETERS strid TYPE char12 AS LISTBOX VISIBLE LENGTH 80 MEMORY ID zadicer_strategy OBLIGATORY.
PARAMETERS numgames TYPE i DEFAULT 100.
PARAMETERS seed     TYPE i DEFAULT 1.

CLASS main DEFINITION.
  PUBLIC SECTION.
    METHODS start
      IMPORTING
        number_of_games  TYPE i
        name_of_strategy TYPE zadicer_game_strategy.
  PRIVATE SECTION.
    DATA strategy TYPE REF TO zif_adicer_strategy.
    DATA game TYPE REF TO zif_adicer_game_engine.

ENDCLASS.

CLASS strategy_helper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS set_listbox
      RETURNING
        VALUE(values) TYPE vrm_values.
    CLASS-METHODS get_by_id
      IMPORTING
        id             TYPE char12
      RETURNING
        VALUE(clsname) TYPE seoclsname.

  PRIVATE SECTION.
    TYPES: BEGIN OF strategy_id,
             id      TYPE char12,
             clsname TYPE seoclsname,
           END OF strategy_id,
           strategy_ids TYPE SORTED TABLE OF strategy_id WITH UNIQUE KEY id.

    CLASS-DATA strategies TYPE strategy_ids.

ENDCLASS.


INITIALIZATION.

  strategy_helper=>set_listbox( ).

CLASS main IMPLEMENTATION.
  METHOD start.
    game = NEW z_adicer_game_engine( ).

    game->start(
        numbers_games = number_of_games
        strategies    = VALUE #( ( strategy_name  = name_of_strategy ) )
        variant       = space
        seed          = seed ).
  ENDMETHOD.

ENDCLASS.

CLASS strategy_helper IMPLEMENTATION.

  METHOD set_listbox.

    TRY.
        strategies = VALUE strategy_ids(
                             FOR class IN NEW cl_oo_interface( 'ZIF_ADICER_STRATEGY' )->get_implementing_classes( )
                                    ( id  = class-clsname+18(12)
                                      clsname = class-clsname ) ).

        CALL FUNCTION 'VRM_SET_VALUES'
          EXPORTING
            id     = 'STRID'
            values = VALUE vrm_values(
                        FOR class IN NEW cl_oo_interface( 'ZIF_ADICER_STRATEGY' )->get_implementing_classes( )
                               ( key  = class-clsname+18(12)
                                 text = NEW cl_oo_class( class-clsname )->class-descript ) ).
      CATCH cx_class_not_existent.
    ENDTRY.

  ENDMETHOD.

  METHOD get_by_id.
    clsname = strategies[ id = id ]-clsname.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.

  DATA(game) = NEW main( ).
  game->start(
    EXPORTING
      number_of_games  = numgames
      name_of_strategy = strategy_helper=>get_by_id( strid ) ).
