-------------------------------------------------------------------------------
-- Title      : midi_controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     :   <kneubste>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-09
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This block contains the midi_controller for sythi_project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-20  1.0      kneubste        Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  

use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------

entity midi_controller is

  port (clk_12m         : in  std_logic;
        reset_n         : in  std_logic;
        rx_data_rdy     : in  std_logic;
        rx_data         : in  std_logic_vector(7 downto 0);
        note_on         : out std_logic;
        note_simple     : out std_logic_vector(6 downto 0);
        velocity_simple : out std_logic_vector(6 downto 0);
		  data_flag			: out std_logic
        );

end entity midi_controller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_controller is
-- Signals & Constants Declaration
-------------------------------------------

  type fsm_states is (st_wait, st_wait_data1, st_wait_data2);
  signal fsm_state                : fsm_states;
  signal next_fsm_state           : fsm_states;
  signal data_flag_sig, next_data_flag_sig             : std_logic;
  signal note_on_sig, next_note_on_sig                 : std_logic;
  signal note_simple_sig, next_note_simple_sig         : std_logic_vector(6 downto 0);
  signal velocity_simple_sig, next_velocity_simple_sig : std_logic_vector(6 downto 0);

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      fsm_state           <= st_wait;
      note_on_sig         <= '0';
      data_flag_sig       <= '0';
		note_simple_sig     <= (others => '0');
		velocity_simple_sig <= (others => '0');

    elsif rising_edge(clk_12m) then
      fsm_state           <= next_fsm_state;
      note_on_sig         <= next_note_on_sig;
		velocity_simple_sig <= next_velocity_simple_sig;
		note_simple_sig     <= next_note_simple_sig;
		data_flag_sig  	  <= next_data_flag_sig;

    end if;
  end process flip_flops;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC MIDI-FSM 
  --------------------------------------------------
  state_logic : process (all)
  begin
    -- default statements (hold current value)
    next_fsm_state <= fsm_state;
	 next_data_flag_sig <= data_flag_sig;

    --------------------------------------------------

    case fsm_state is

      when st_wait =>
		 
		 next_data_flag_sig  <= '0'; --keine neue Status-Daten stehen an
        if rx_data_rdy = '0' then
			 next_fsm_state <= st_wait;
        elsif rx_data(7) = '1' then
          next_fsm_state <= st_wait_data1;
        elsif rx_data(7) = '0' then
          next_fsm_state <= st_wait_data2;
        end if;

      when st_wait_data1 =>

        if rx_data_rdy = '0' then
          next_fsm_state <= st_wait_data1;
        else
          next_fsm_state <= st_wait_data2;
        end if;

      when st_wait_data2 =>

        if rx_data_rdy = '0' then
          next_fsm_state <= st_wait_data2;
        else
          next_data_flag_sig  <= '1'; --wird für eine clk_period gesetzt
          next_fsm_state <= st_wait;
        end if;

      when others =>
        next_fsm_state <= st_wait;
		  next_data_flag_sig  <= '1'; --wird für eine clk_period gesetzt
    end case;

  end process state_logic;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC
  --------------------------------------------------
  fsm_output_logic : process (all)

  begin

    next_note_on_sig         <= note_on_sig;
    next_note_simple_sig     <= note_simple_sig;
    next_velocity_simple_sig <= velocity_simple_sig;

    case fsm_state is
      when st_wait =>
        if rx_data_rdy = '1' then
          if rx_data(7) = '1' then
            next_note_on_sig <= rx_data(4);
          elsif rx_data(7) = '0' then
            next_note_simple_sig <= rx_data(6 downto 0);
          end if;
        end if;
      when st_Wait_data1 =>
        if rx_data_rdy = '1' then
          next_note_simple_sig <= rx_data(6 downto 0);
        end if;
      when st_Wait_data2 =>
        if rx_data_rdy = '1' then
          next_velocity_simple_sig <= rx_data(6 downto 0);
        end if;
      when others =>

    end case;

  end process fsm_output_logic;

  --------------------------------------------------
  -- Output-Zuweisungen
  --------------------------------------------------

  note_on         <= note_on_sig;
  note_simple     <= note_simple_sig;
  velocity_simple <= velocity_simple_sig;
  data_flag			<= data_flag_sig;
  --------------------------------------------------

-- End Architecture 
------------------------------------------- 
  end rtl;
