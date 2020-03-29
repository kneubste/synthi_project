-------------------------------------------------------------------------------
-- Title      : Testbench for design "synthi_top"
-- Project    : MS1
-------------------------------------------------------------------------------
-- File       : synthi_top_tb.vhd
-- Author     : lussimat
-- Company    : 
-- Created    : 2020-03-09
-- Last update: 2020-03-29
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Diese Testbench ist dafür zuständig, die verschiedenen
-- data-register (0-9) von i2c_slave_bfm zu testen. Für den Test wird
-- am Input "SW" von "sythi_top", die Werte 0-7 geladen (3 Schalter).
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  : 2020-03-13 Zusammenfügen verschiedener Teile
--              2020-03-15 Fehlersuche + Behebung
--              2020-03-17 einfachere Lösung für anlegen von Wert an SW
--              2020-03-19 letzter Schliff - kommentieren, Header und Beautify
-- Date        Version  Author  Description
-- 2020-03-16  1.0      matth   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use std.textio.all;
use work.simulation_pkg.all;
use work.standard_driver_pkg.all;
use work.user_driver_pkg.all;
use work.reg_table_pkg.all;

-------------------------------------------------------------------------------

entity synthi_top_tb is

end entity synthi_top_tb;

-------------------------------------------------------------------------------

architecture struct of synthi_top_tb is

  component synthi_top is
    port (
      CLOCK_50    : in    std_logic;
      KEY_0       : in    std_logic;
      KEY_1       : in    std_logic;
      SW          : in    std_logic_vector(9 downto 0);
      USB_RXD     : in    std_logic;
      USB_TXD     : in    std_logic;
      BT_RXD      : in    std_logic;
      BT_TXD      : in    std_logic;
      BT_RST_N    : in    std_logic;
      AUD_XCK     : out   std_logic;
      AUD_DACDAT  : out   std_logic;
      AUD_BCLK    : out   std_logic;
      AUD_DACLRCK : out   std_logic;
      AUD_ADCLRCK : out   std_logic;
      AUD_ADCDAT  : in    std_logic;
      AUD_SCLK    : out   std_logic;
      AUD_SDAT    : inout std_logic;
      LEDR_0      : out   std_logic;
      HEX0        : out   std_logic_vector(6 downto 0);
      HEX1        : out   std_logic_vector(6 downto 0));
  end component synthi_top;

  component i2c_slave_bfm is
    generic (
      verbose : boolean := false);
    port (
      AUD_XCK   : in    std_logic;
      I2C_SDAT  : inout std_logic := 'H';
      I2C_SCLK  : inout std_logic := 'H';
      reg_data0 : out   std_logic_vector(31 downto 0);
      reg_data1 : out   std_logic_vector(31 downto 0);
      reg_data2 : out   std_logic_vector(31 downto 0);
      reg_data3 : out   std_logic_vector(31 downto 0);
      reg_data4 : out   std_logic_vector(31 downto 0);
      reg_data5 : out   std_logic_vector(31 downto 0);
      reg_data6 : out   std_logic_vector(31 downto 0);
      reg_data7 : out   std_logic_vector(31 downto 0);
      reg_data8 : out   std_logic_vector(31 downto 0);
      reg_data9 : out   std_logic_vector(31 downto 0));
  end component i2c_slave_bfm;

  -- component ports
  signal CLOCK_50     : std_logic;
  signal KEY_0        : std_logic;
  signal KEY_1        : std_logic;
  signal SW           : std_logic_vector(9 downto 0);
  signal USB_RXD      : std_logic;
  signal USB_TXD      : std_logic;
  signal BT_RXD       : std_logic;
  signal BT_TXD       : std_logic;
  signal BT_RST_N     : std_logic;
  signal AUD_XCK      : std_logic;
  signal AUD_DACDAT   : std_logic;
  signal AUD_BCLK     : std_logic;
  signal AUD_DACLRCK  : std_logic;
  signal AUD_ADCLRCK  : std_logic;
  signal AUD_ADCDAT   : std_logic;
  signal AUD_SCLK     : std_logic;
  signal AUD_SDAT     : std_logic;
  signal LEDR_0       : std_logic;
  signal HEX0         : std_logic_vector(6 downto 0);
  signal HEX1         : std_logic_vector(6 downto 0);
  signal I2C_SCLK_int : std_logic;
  signal I2C_SDAT_int : std_logic;
  signal reg_data0    : std_logic_vector(31 downto 0);
  signal reg_data1    : std_logic_vector(31 downto 0);
  signal reg_data2    : std_logic_vector(31 downto 0);
  signal reg_data3    : std_logic_vector(31 downto 0);
  signal reg_data4    : std_logic_vector(31 downto 0);
  signal reg_data5    : std_logic_vector(31 downto 0);
  signal reg_data6    : std_logic_vector(31 downto 0);
  signal reg_data7    : std_logic_vector(31 downto 0);
  signal reg_data8    : std_logic_vector(31 downto 0);
  signal reg_data9    : std_logic_vector(31 downto 0);
  signal AUD_XCK_in   : std_logic;
  signal SW_32b       : std_logic_vector(31 downto 0);
  
  signal switch       : std_logic_vector(31 downto 0);
  signal dacdat_check : std_logic_vector(31 downto 0);
  
  constant clock_freq   : natural := 50_000_000;
  constant clock_period : time    := 1000 ms/clock_freq;

begin  -- architecture struct

  -- component instantiation
  DUT : synthi_top
    port map (
      CLOCK_50    => CLOCK_50,
      KEY_0       => KEY_0,
      KEY_1       => KEY_1,
      SW          => SW,
      USB_RXD     => USB_RXD,
      USB_TXD     => USB_TXD,
      BT_RXD      => BT_RXD,
      BT_TXD      => BT_TXD,
      BT_RST_N    => BT_RST_N,
      AUD_XCK     => AUD_XCK,
      AUD_DACDAT  => AUD_DACDAT,
      AUD_BCLK    => AUD_BCLK,
      AUD_DACLRCK => AUD_DACLRCK,
      AUD_ADCLRCK => AUD_ADCLRCK,
      AUD_ADCDAT  => AUD_ADCDAT,
      AUD_SCLK    => I2C_SCLK_int,
      AUD_SDAT    => I2C_SDAT_int,
      LEDR_0      => LEDR_0,
      HEX0        => HEX0,
      HEX1        => HEX1);

  SW    <= SW_32b(9 downto 0);
  SW(3) <= gpi_signal(3);

  source : i2c_slave_bfm
    port map (
      AUD_XCK   => AUD_XCK_in,
      I2C_SCLK  => I2C_SCLK_int,
      I2C_SDAT  => I2C_SDAT_int,
      reg_data0 => reg_data0,
      reg_data1 => reg_data1,
      reg_data2 => reg_data2,
      reg_data3 => reg_data3,
      reg_data4 => reg_data4,
      reg_data5 => reg_data5,
      reg_data6 => reg_data6,
      reg_data7 => reg_data7,
      reg_data8 => reg_data8,
      reg_data9 => reg_data9);



  readcmd : process
    -- This process loops through a file and reads one line
    -- at a time, parsing the line to get the values and
    -- expected result.

    variable cmd          : string(1 to 7);  --stores test command
    variable line_in      : line;       --stores the to be processed line     
    variable tv           : test_vect;  --stores arguments 1 to 4
    variable lincnt       : integer := 0;  --counts line number in testcase file
    variable fail_counter : integer := 0;  --counts failed tests



  begin
    -------------------------------------
    -- Open the Input and output files
    -------------------------------------
    FILE_OPEN(cmdfile, "../testcase.dat", read_mode);
    FILE_OPEN(outfile, "../results.dat", write_mode);

    -------------------------------------
    -- Start the loop
    -------------------------------------


    loop

      --------------------------------------------------------------------------
      -- Check for end of test file and print out results at the end
      --------------------------------------------------------------------------


      if endfile(cmdfile) then          -- Check EOF
        end_simulation(fail_counter);
        exit;
      end if;

      --------------------------------------------------------------------------
      -- Read all the argumnents and commands
      --------------------------------------------------------------------------

      readline(cmdfile, line_in);       -- Read a line from the file
      lincnt := lincnt + 1;


      next when line_in'length = 0;     -- Skip empty lines
      next when line_in.all(1) = '#';   -- Skip lines starting with #

      read_arguments(lincnt, tv, line_in, cmd);
      tv.clock_period := clock_period;  -- set clock period for driver calls

      -------------------------------------
      -- Reset the circuit
      -------------------------------------

      if cmd = string'("rst_sim") then
        rst_sim(tv, key_0);             --Reset der Simulation
      elsif cmd = string'("run_sim") then
        run_sim(tv);  --Simulation wird für bestimmte Anz.Clk-cycles betrieben
      elsif cmd = string'("uar_sim") then
        uar_sim(tv, usb_txd);    --Serielles Eingangssignal wird angelegt
      elsif cmd = string'("uar_ch0") then
        uar_chk(tv, hex0);       --Check von 7-Segment-Anzeige mit Testvektor
      elsif cmd = string'("uar_ch1") then
        uar_chk(tv, hex1);       --Check von 7-Segment-Anzeige mit Testvektor
      elsif cmd = string'("ini_cod") then
        gpi_sim(tv, SW_32b);     --Paralleles Signal wird in SW_32b geladen
      elsif cmd = string'("i2c_ch0") then
        gpo_chk(tv, reg_data0);         --Check data-register0
      elsif cmd = string'("i2c_ch1") then
        gpo_chk(tv, reg_data1);         --Check data-register1
      elsif cmd = string'("i2c_ch2") then
        gpo_chk(tv, reg_data2);         --Check data-register2
      elsif cmd = string'("i2c_ch3") then
        gpo_chk(tv, reg_data3);         --Check data-register3
      elsif cmd = string'("i2c_ch4") then
        gpo_chk(tv, reg_data4);         --Check data-register4
      elsif cmd = string'("i2c_ch5") then
        gpo_chk(tv, reg_data5);         --Check data-register5
      elsif cmd = string'("i2c_ch6") then
        gpo_chk(tv, reg_data6);         --Check data-register6
      elsif cmd = string'("i2c_ch7") then
        gpo_chk(tv, reg_data7);         --Check data-register7
      elsif cmd = string'("i2c_ch8") then
        gpo_chk(tv, reg_data8);         --Check data-register8
      elsif cmd = string'("i2c_ch9") then
        gpo_chk(tv, reg_data9);         --Check data-register9
        
       -- Generiet serielles Signal wie nach Umwandlung
      elsif cmd = string'("i2s_sim") then
        gpo_chk(tv, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT);

       -- Empfängt serielles Signal und vergleicht mit Argument im Testcase   
      elsif cmd = string'("i2s_chk") then
        gpo_chk(tv, AUD_DACLRCK, AUD_BCLK, AUD_DACDAT, dacdat_check);            

-- add further test commands below here


      else
        assert false
          report "NO MATCHING COMMAND FOUND IN 'testcase.dat' AT LINE: "& integer'image(lincnt)
          severity error;
      end if;

      if tv.fail_flag = true then       --count failures in tests
        fail_counter := fail_counter + 1;
      else fail_counter := fail_counter;
      end if;

    end loop;  --finished processing command line

    wait;  -- to avoid infinite loop simulator warning

  end process;

  clkgen : process
  begin
    clock_50 <= '0';
    wait for clock_period/2;
    clock_50 <= '1';
    wait for clock_period/2;

  end process clkgen;



end architecture struct;
-------------------------------------------------------------------------------
