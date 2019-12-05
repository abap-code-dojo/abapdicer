class Z_ADICER_STRATEGY_FACTORY definition
  public
  final
  create public .

public section.

  class-methods CREATE
    importing
      !STRATEGY type ZADICER_GAME_STRATEGY
    returning
      value(OBJECT) type ref to ZIF_ADICER_STRATEGY .
protected section.
private section.
ENDCLASS.



CLASS Z_ADICER_STRATEGY_FACTORY IMPLEMENTATION.


  METHOD create.

    TRY.
        CREATE OBJECT object TYPE (strategy).
      CATCH cx_sy_create_object_error.
        object = NEW z_adicer_strategy_tst_empty( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
