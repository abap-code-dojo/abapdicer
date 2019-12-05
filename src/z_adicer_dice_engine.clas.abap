class Z_ADICER_DICE_ENGINE definition
  public
  final
  create private .

public section.

  interfaces ZIF_ADICER_DICE_ENGINE .

  class-methods FACTORY
    importing
      !SEED type I
    returning
      value(OBJECT) type ref to ZIF_ADICER_DICE_ENGINE .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS constructor
      IMPORTING
        !seed TYPE i OPTIONAL .
    CLASS-DATA current_dice_engine TYPE REF TO z_adicer_dice_engine.
    DATA: random_generator TYPE REF TO cl_abap_random_int,
          number_of_roll   TYPE i.
ENDCLASS.



CLASS Z_ADICER_DICE_ENGINE IMPLEMENTATION.


  METHOD constructor.
    zif_adicer_dice_engine~seed = seed.

    random_generator = cl_abap_random_int=>create(
       seed = zif_adicer_dice_engine~seed
       min = 1
       max = 6 ).
  ENDMETHOD.


  METHOD factory.
    IF current_dice_engine IS INITIAL.
      object = NEW z_adicer_dice_engine( seed ).
    ELSE.
      object = current_dice_engine.
    ENDIF.
  ENDMETHOD.


  METHOD zif_adicer_dice_engine~generate_random.

    dice = random_generator->get_next( ).

  ENDMETHOD.


  METHOD zif_adicer_dice_engine~get_results.
    DATA new_roll TYPE zif_adicer_dice_engine~ts_dice.

    IF last_roll IS INITIAL.
      DO 5 TIMES.
        CLEAR new_roll.
        new_roll-diceid = sy-index.
        new_roll-value  = zif_adicer_dice_engine~generate_random( ).
        new_roll-keep   = abap_false.
        APPEND new_roll TO next_roll.
      ENDDO.
      number_of_roll = 0.
    ELSE.
      IF number_of_roll <= 2.
        LOOP AT last_roll INTO DATA(old_roll).
          CLEAR new_roll.
          IF old_roll-diceid = sy-tabix AND old_roll-keep = abap_true.
            new_roll-diceid  = sy-tabix.
            new_roll-value   = old_roll-value.
            new_roll-keep    = abap_true.
          ELSE.
            new_roll-diceid  = sy-tabix.
            new_roll-value   = zif_adicer_dice_engine~generate_random( ).
            new_roll-keep    = abap_false.
          ENDIF.
          APPEND new_roll TO next_roll.
        ENDLOOP.
      ENDIF.
      ADD 1 TO number_of_roll.
    ENDIF.

  ENDMETHOD.


  METHOD zif_adicer_dice_engine~get_seed.
    seed = zif_adicer_dice_engine~seed.
  ENDMETHOD.
ENDCLASS.
