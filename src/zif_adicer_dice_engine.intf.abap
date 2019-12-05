INTERFACE zif_adicer_dice_engine
  PUBLIC .


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
    tt_roll TYPE SORTED TABLE OF ts_dice WITH UNIQUE KEY diceid.



  CLASS-DATA dice_roll TYPE TABLE OF tt_roll .
  DATA: number_of_roll TYPE i .
  DATA seed TYPE i .
  DATA last_roll TYPE tt_roll .

  METHODS generate_random
    RETURNING
      VALUE(dice) TYPE i .
  METHODS get_results
    IMPORTING
      !last_roll       TYPE tt_roll
    RETURNING
      VALUE(next_roll) TYPE tt_roll
    EXCEPTIONS
      methods
      factory .
  METHODS get_seed
    RETURNING
      VALUE(seed) TYPE i .
ENDINTERFACE.
