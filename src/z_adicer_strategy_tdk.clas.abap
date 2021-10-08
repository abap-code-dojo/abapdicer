class z_adicer_strategy_tdk definition
  public
  final
  create public .

  public section.

    interfaces zif_adicer_strategy .
  protected section.
  private section.
endclass.



class z_adicer_strategy_tdk implementation.


  method zif_adicer_strategy~decide_on_result.
    score_cell = zif_adicer_scoresheet=>lower_chance.
  endmethod.


  method zif_adicer_strategy~decide_on_roll.

    case round.

      when '1'.
        if line_exists( dice_roll[ value = '6' ] ) and reduce value( init val type i for wa in  dice_roll next val = val + wa-value  ) > 15.

          loop at dice_roll assigning field-symbol(<dice>).
            <dice>-keep = abap_true.
          endloop.

        else.
          dice_roll[ round ]-keep = abap_true.
        endif.
      when others.
        dice_roll[ round ]-keep = abap_true.
    endcase.

*SCORESHEET

  endmethod.
endclass.
