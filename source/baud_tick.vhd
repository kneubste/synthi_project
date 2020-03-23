-------------------------------------------
-- Block code:  count_down.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--             25.Dez.2019 - 2st version (stutzcyr)
-- Function: down-counter, with start input and count output. 
-- 		The input start should be a pulse which causes the 
--			counter to load its max-value. When start is off,
--			the counter decrements by one every clock cycle till 
--			count_o equals 0. Once the count_o reachs 0, the counter
--			freezes and wait till next start pulse. 
--			Can be used as enable for other blocks where need to 
--			count number of iterations.
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



-- Entity Declaration 
-------------------------------------------
ENTITY baud_tick IS
GENERIC (width : positive := 10);
  PORT( clk,reset_n	: IN    std_logic;
  		start_bit		: IN    std_logic;
		baud_tick 		: out	  std_logic
    	);
END baud_tick;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF baud_tick IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT  	max_val				: 	unsigned(width-1 downto 0):= to_unsigned(4,width); -- convert integer value 4 to unsigned with 4bits
CONSTANT 	clock_freq			: 	positive := 12_500_000; -- Clock/Hz 
CONSTANT 	baud_rate			: 	positive := 115_200; -- Baude Rate/Hz 
CONSTANT 	count_width 		: 	positive := 10;   -- FreqClock/FreqBaudRate=50000000/115200 =434 so need 10bits 
CONSTANT 	one_period			: 	unsigned(count_width - 1 downto 0):= to_unsigned(clock_freq / baud_rate ,count_width); 
CONSTANT 	half_period 		: 	unsigned(count_width - 1 downto 0):= to_unsigned(clock_freq/ baud_rate /2, count_width);
SIGNAL 		count, next_count	: 	unsigned(width-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(all)
  BEGIN	
	-- load	
	IF (start_bit = '1') THEN
		next_count <= half_period;
		
	elsif (count = "0000000000") THEN
		next_count <= one_period;
		
  	-- decrement
  	ELSE
  		next_count <= count - 1 ;
  	END IF;
	
  END PROCESS comb_logic;   
  
  out_logic: Process(all)
  begin
  baud_tick <= '0';
  
  if (count = "000000000") then
		baud_tick <= '1';
	end if;
  
  end process out_logic;
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(all)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= to_unsigned(0,width); -- convert integer value 0 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)

  
 -- End Architecture 
------------------------------------------- 
END rtl;

