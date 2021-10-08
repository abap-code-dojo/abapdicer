CLASS z_adicer_strategy_kwf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adicer_strategy.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      result TYPE zadicer_score_cell.

    METHODS keep_dice
      IMPORTING eye        TYPE i OPTIONAL
      CHANGING  !dice_roll TYPE zif_adicer_dice_engine=>tt_roll.

    METHODS count_equal
      IMPORTING
        !dice_roll TYPE zif_adicer_dice_engine=>tt_roll
        eye        TYPE i
      EXPORTING
        equal      TYPE i.

    METHODS check_single_eyes
      IMPORTING cell TYPE REF TO zif_adicer_scoresheet .
*      changing scoresheet

    METHODS check_more_of_a_kind.

ENDCLASS.



CLASS z_adicer_strategy_kwf IMPLEMENTATION.

  METHOD count_equal.
    LOOP AT dice_roll TRANSPORTING NO FIELDS WHERE value = eye.
      ADD 1 TO equal.
    ENDLOOP.
  ENDMETHOD.

  METHOD check_single_eyes.
*IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_3_ofakind ).
*        result = zif_adicer_scoresheet=>lower_3_ofakind.
  ENDMETHOD.

  METHOD check_more_of_a_kind.

  ENDMETHOD.

  METHOD keep_dice.
    LOOP AT dice_roll ASSIGNING FIELD-SYMBOL(<dice>) WHERE value = eye.
      <dice>-keep = abap_true.
    ENDLOOP.
  ENDMETHOD.

  METHOD zif_adicer_strategy~decide_on_result.
    score_cell = result.
  ENDMETHOD.

  METHOD zif_adicer_strategy~decide_on_roll.

    " default option if nothing else fits
    IF scoresheet->check_cell_empty(  kind = zif_adicer_scoresheet=>lower_chance ).
      result = zif_adicer_scoresheet=>lower_chance.
    ENDIF.

    " Counting die faces
    count_equal( EXPORTING dice_roll = dice_roll eye = 6 IMPORTING equal = DATA(sixes) ).   " count sixes
    count_equal( EXPORTING dice_roll = dice_roll eye = 5 IMPORTING equal = DATA(fives) ).   " count fives
    count_equal( EXPORTING dice_roll = dice_roll eye = 4 IMPORTING equal = DATA(fours) ).   " count fours
    count_equal( EXPORTING dice_roll = dice_roll eye = 3 IMPORTING equal = DATA(threes) ).   " count threes
    count_equal( EXPORTING dice_roll = dice_roll eye = 2 IMPORTING equal = DATA(twos) ).   " count twos
    count_equal( EXPORTING dice_roll = dice_roll eye = 1 IMPORTING equal = DATA(aces) ).   " count aces


**********************************************************************
    " Equal die faces
**********************************************************************

    " Single numbers
**********************************************************************


    " keep with 2 or more sixes
    IF sixes > 1.
      keep_dice( EXPORTING eye = 6 CHANGING dice_roll = dice_roll ).
      " check just sixes
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_sixes ).
        result = zif_adicer_scoresheet=>upper_sixes.
      ENDIF.
    ENDIF.


    " keep with 2 or more fives
    IF fives > 1.
      keep_dice( EXPORTING eye = 5 CHANGING dice_roll = dice_roll ).
      " check just fives
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_fives ).
        result = zif_adicer_scoresheet=>upper_fives.
      ENDIF.
    ENDIF.


    " keep with 2 or more fours
    IF fours > 1.
      keep_dice( EXPORTING eye = 4 CHANGING dice_roll = dice_roll ).
      " check just fours
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_fours ).
        result = zif_adicer_scoresheet=>upper_fours.
      ENDIF.
    ENDIF.


    " keep with 2 or more threes
    IF threes > 1.
      keep_dice( EXPORTING eye = 3 CHANGING dice_roll = dice_roll ).
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_threes ).
        result = zif_adicer_scoresheet=>upper_threes.
      ENDIF.
    ENDIF.


    " keep with 2 or more twos
    IF twos > 1.
      keep_dice( EXPORTING eye = 2 CHANGING dice_roll = dice_roll ).
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_twos ).
        result = zif_adicer_scoresheet=>upper_twos.
      ENDIF.
    ENDIF.


    " keep with 2 or more aces
    IF aces > 1.
      keep_dice( EXPORTING eye = 1 CHANGING dice_roll = dice_roll ).
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>upper_aces ).
        result = zif_adicer_scoresheet=>upper_aces.
      ENDIF.
    ENDIF.

    " more of a kind
**********************************************************************
    " sixes, fives or fours ≥ 3
    IF sixes > 2 OR fives > 2 OR fours > 2.
      " check if 3 of a kind is empty
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_3_ofakind ).
        result = zif_adicer_scoresheet=>lower_3_ofakind.
      ENDIF.
      " sixes, fives or fours ≥ 4

      IF sixes > 3 OR fives > 3 OR fours > 3.
        " check if 4 of a kind is empty
        IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_4_ofakind ).
          result = zif_adicer_scoresheet=>lower_4_ofakind.
        ENDIF.
      ENDIF.
    ENDIF.

    " Full House
**********************************************************************

    IF sixes = 2 OR fives = 2 OR fours = 2 OR threes = 2 OR twos = 2 OR aces = 2 AND sixes = 3 OR fives = 3 OR fours = 3 OR threes = 3 OR twos = 3 OR aces = 3 .
      IF scoresheet->check_cell_empty( kind = zif_adicer_scoresheet=>lower_full_house ).
        result = zif_adicer_scoresheet=>lower_full_house.
      ENDIF.
    ENDIF.


    " ABAP-Dicer
**********************************************************************
    IF aces = 5 OR twos = 5 OR threes = 5 OR fours = 5 OR fives = 5 OR sixes = 5.

      keep_dice( CHANGING dice_roll = dice_roll ).

      result = zif_adicer_scoresheet=>lower_abapdicer.
    ENDIF.

**********************************************************************
    "Straights
**********************************************************************

    " small Straight
    " looking for '1234' '2345' and '3456'
    IF aces > 0 AND twos > 0 AND threes > 0 AND fours > 0 OR twos > 0 AND threes > 0 AND fours > 0 AND fives > 0 OR threes > 0 AND fours > 0 AND fives > 0 AND sixes > 0.
      IF scoresheet->check_cell_empty(  kind = zif_adicer_scoresheet=>lower_small_straight ).
        keep_dice( EXPORTING eye = 1 CHANGING dice_roll = dice_roll ).
        keep_dice( EXPORTING eye = 2 CHANGING dice_roll = dice_roll ).
        keep_dice( EXPORTING eye = 3 CHANGING dice_roll = dice_roll ).
        keep_dice( EXPORTING eye = 4 CHANGING dice_roll = dice_roll ).
        result = zif_adicer_scoresheet=>lower_small_straight.
      ENDIF.

      " large Straight
      " looking for '12345' and '23456'
      IF aces > 0 AND twos > 0 AND threes > 0 AND fours > 0 AND fives > 0 OR twos > 0 AND threes > 0 AND fours > 0 AND fives > 0 AND sixes > 0.
        IF scoresheet->check_cell_empty(  kind = zif_adicer_scoresheet=>lower_large_straight ).
          result = zif_adicer_scoresheet=>lower_large_straight.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
