-------------------------------------------------------------------------------
-- Title      : framegenerator
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : i2s_frame_generator.vhd
-- Author     : lussimat
-- Company    : 
-- Created    : 2020-03-24
-- Last update: 2020-05-28
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This entity generates the load-, shift_left-, 
--		shift_right-, and the word_select(ws)-Signal.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-03-24| lussimat | 1st version
-- 2020-03-30| lussimat | Debugging
-- 2020-05-28| kneubste | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------
-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity i2s_frame_generator is
  generic (width : positive := 2);
  port(rst_n_12m : in  std_logic;
       clk_12m   : in  std_logic;
       bclk      : out std_logic;
       load      : out std_logic;
       shift_l   : out std_logic;
       shift_r   : out std_logic;
       ws        : out std_logic
       );
end i2s_frame_generator;


-- Architecture Declaration?
-------------------------------------------
architecture rtl of i2s_frame_generator is
-- Signals & Constants Declaration?
-------------------------------------------
  type fsm_states is (st_load, st_left_wait, st_right_wait, st_shift_l, st_shift_r);
  signal next_fsm_state, fsm_state     : fsm_states;
  signal div_count, div_next_count     : unsigned(width-1 downto 0) := (others => '0');
  signal bit_counter, next_bit_counter : unsigned(6 downto 0);
  signal ws_int, load_int, bclk_int    : std_logic;
  signal shift_l_int, shift_r_int      : std_logic;
-- Begin Architecture
-------------------------------------------
begin
-------------------------------------------------------
--BCLK Generator
-------------------------------------------------------
  mod_div_comb_logic : process(all)
  begin
    --increment next_count
    div_next_count <= div_count + 2;

  end process mod_div_comb_logic;

--------------------------------------------------------

--------------------------------------------------------
--modul Counter
--------------------------------------------------------
  modulo_logic : process(all)
  begin
    if bclk = '1' then
      next_bit_counter <= bit_counter + 1;
    else
      next_bit_counter <= bit_counter;
    end if;


  end process modulo_logic;
--------------------------------------------------------

  flip_flops : process(all)
  begin
    --counter from 0 to 128 - increment by rising edge of clk_12m and low bclk
    if rst_n_12m = '0' then
      bit_counter <= (others => '0');
      fsm_state   <= st_load;
    elsif rising_edge(clk_12m) then
      bit_counter <= next_bit_counter;
      fsm_state   <= next_fsm_state;
      div_count   <= div_next_count;
    end if;

  end process flip_flops;


--------------------------------------------------------
--i2s_decoder
--------------------------------------------------------        
  i2s_decoder : process(all)
  begin
    --default statements
    load_int       <= '0';
    ws_int         <= '0';
    shift_r_int    <= '0';
    shift_l_int    <= '0';
    next_fsm_state <= fsm_state;

    case fsm_state is
      --es wurde mit next_bit_counter gearbeitet, um keine delays zu schaffen 

      -- load wird high
      when st_load =>
        load_int                                            <= '1';
        if next_bit_counter = "0000001" then next_fsm_state <= st_shift_l;  --wechsle in st_shift_l wenn next_bit_counter 1 wird (es wird geschoben)
        else next_fsm_state                                 <= st_load;
        end if;
      -- shift_left wird aktiv => es wird links geschoben
      when st_shift_l =>
        shift_l_int                                         <= '1';
        if next_bit_counter = "0010001" then next_fsm_state <= st_left_wait;  --wechsle in state st_left_wait wenn fertig geschoben
        else next_fsm_state                                 <= st_shift_l;
        end if;
      -- nichts aktives passiert => word select verweilt auf links
      when st_left_wait =>
        if next_bit_counter = "1000000" then next_fsm_state <= st_right_wait;  --word select aendert sich => rechts
        else next_fsm_state                                 <= st_left_wait;  --nichts passiert
        end if;
      -- nichts aktives passiert => word select verweilt auf rechts             
      when st_right_wait =>
        ws_int                                              <= '1';
        if next_bit_counter = "1000001" then next_fsm_state <= st_shift_r;
        elsif next_bit_counter = 0 then next_fsm_state      <= st_load;
        else next_fsm_state                                 <= st_right_wait;
        end if;
      -- shift_right wird aktiv => es wird rechts geschoben     
      when st_shift_r =>
        ws_int                                              <= '1';
        shift_r_int                                         <= '1';
        if next_bit_counter = "1010001" then next_fsm_state <= st_right_wait;  --wechsle zurueck in state st_right_wait wenn fertig geschoben
        else next_fsm_state                                 <= st_shift_r;
        end if;

      when others => null;

    end case;

  end process i2s_decoder;
--------------------------------------------------------

  --Output: bclk, ws, load, shift_l, shift_r

  bclk    <= std_logic(div_next_count(width-1));  --bclk wird ausgegeben   
  ws      <= ws_int;
  shift_l <= shift_l_int;
  shift_r <= shift_r_int;
  load    <= load_int;

end rtl;
