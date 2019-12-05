class Z_ADICER_DICE_ENGINE_TEST_01 definition
  public
  abstract
  create public
  for testing
  duration short
  risk level harmless .

public section.

  methods BETWEEN_1_AND_6
  for testing .
  methods SEED_CORRECT
  for testing .
  methods SEED_FALSE
  for testing .
  methods GET_RESULTS_NO_CHANGE
  for testing .
  methods GET_RESULTS_CHANGE_1
  for testing .
  methods GET_RESULTS_FOUR_ROLLS
  for testing .
  methods CHANGING_DICE_RESULTS
  for testing .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA f_cut TYPE REF TO zif_adicer_dice_engine .
    DATA first_roll TYPE zif_adicer_dice_engine=>tt_roll.
    DATA first_roll_keep_all TYPE zif_adicer_dice_engine=>tt_roll.
    METHODS setup .
ENDCLASS.



CLASS Z_ADICER_DICE_ENGINE_TEST_01 IMPLEMENTATION.


  METHOD between_1_and_6.
    DATA randomresult TYPE i.
    DATA is_between_1_and_6 TYPE abap_bool.
    DO 1000 TIMES.
      randomresult = f_cut->generate_random( ).
      is_between_1_and_6 = COND #( WHEN randomresult BETWEEN 1 AND 6
      THEN abap_true
      ELSE abap_false ).
      cl_abap_unit_assert=>assert_equals(
        EXPORTING
          act                  = is_between_1_and_6
          exp                  = abap_true    ).
    ENDDO.
  ENDMETHOD.


  METHOD changing_dice_results.

    DATA last_roll TYPE zif_adicer_dice_engine=>tt_roll.
    DATA third_roll TYPE zif_adicer_dice_engine=>tt_roll.

    "1st roll
    DATA(dice_result) = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll
        msg = '1st roll failed' ).

    "2nd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = VALUE zif_adicer_dice_engine=>tt_roll(
        ( diceid = 1 value = 1 keep = ' ' )
        ( diceid = 2 value = 2 keep = ' ' )
        ( diceid = 3 value = 6 keep = ' ' )
        ( diceid = 4 value = 1 keep = ' ' )
        ( diceid = 5 value = 2 keep = ' ' ) )
        msg = '2nd roll failed' ).

    "3rd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = VALUE zif_adicer_dice_engine=>tt_roll(
        ( diceid = 1 value = 1 keep = ' ' )
        ( diceid = 2 value = 3 keep = ' ' )
        ( diceid = 3 value = 2 keep = ' ' )
        ( diceid = 4 value = 3 keep = ' ' )
        ( diceid = 5 value = 3 keep = ' ' ) )
        msg = '3rd roll failed' ).
    last_roll = dice_result.
    LOOP AT last_roll ASSIGNING FIELD-SYMBOL(<roll>).
      <roll>-keep = abap_true.
    ENDLOOP.
    third_roll = last_roll.

    "4th roll - not allowed! should return empty roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = third_roll
        msg = '4th roll not as expected...' ).


  ENDMETHOD.


  METHOD get_results_change_1.
    DATA last_roll TYPE zif_adicer_dice_engine=>tt_roll.
    DATA(dice_result) = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll ).
  ENDMETHOD.


  METHOD get_results_four_rolls.
    DATA last_roll TYPE zif_adicer_dice_engine=>tt_roll.

    "1st roll
    DATA(dice_result) = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll
        msg = '1st roll failed' ).
    last_roll = dice_result.
    LOOP AT last_roll ASSIGNING FIELD-SYMBOL(<roll>).
      <roll>-keep = abap_true.
    ENDLOOP.

    "2nd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll_keep_all
        msg = '2nd roll failed' ).

    "3rd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll_keep_all
        msg = '3rd roll failed' ).

    "4th roll - not allowed! should return empty roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = dice_result
        exp = first_roll_keep_all
        msg = '4th roll not as expected...' ).

  ENDMETHOD.


  METHOD get_results_no_change.
    DATA last_roll TYPE zif_adicer_dice_engine=>tt_roll.


    "1st roll
    DATA(dice_result) = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
        act = dice_result
        exp = first_roll ).
    last_roll = dice_result.
    LOOP AT last_roll ASSIGNING FIELD-SYMBOL(<roll>).
      <roll>-keep = abap_true.
    ENDLOOP.


    "2nd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
        act = dice_result
        exp = first_roll_keep_all ).

    "3rd roll
    dice_result = f_cut->get_results( last_roll = last_roll ).
    cl_abap_unit_assert=>assert_equals(
        act = dice_result
        exp = first_roll_keep_all ).

  ENDMETHOD.


  METHOD seed_correct.

    cl_abap_unit_assert=>assert_equals(
        act = f_cut->get_seed( )
        exp = 1 ).
  ENDMETHOD.


  METHOD seed_false.

    cl_abap_unit_assert=>assert_differs(
        act = f_cut->get_seed( )
        exp = 0 ).
  ENDMETHOD.


  METHOD setup.
    first_roll = VALUE zif_adicer_dice_engine=>tt_roll(
        ( diceid = 1 value = 3 keep = ' ' )
        ( diceid = 2 value = 6 keep = ' ' )
        ( diceid = 3 value = 5 keep = ' ' )
        ( diceid = 4 value = 6 keep = ' ' )
        ( diceid = 5 value = 1 keep = ' ' ) ) .
    first_roll_keep_all = VALUE zif_adicer_dice_engine=>tt_roll(
        ( diceid = 1 value = 3 keep = 'X' )
        ( diceid = 2 value = 6 keep = 'X' )
        ( diceid = 3 value = 5 keep = 'X' )
        ( diceid = 4 value = 6 keep = 'X' )
        ( diceid = 5 value = 1 keep = 'X' ) ) .
    f_cut = z_adicer_dice_engine=>factory( seed = 1 ).
  ENDMETHOD.
ENDCLASS.
