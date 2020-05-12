-------------------------------------------
-- Block code:  bit_counter.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 29.11.2019 - changed from count_down.vhd  (kneubste)
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY bit_counter IS
GENERIC (width : positive := 4);
  PORT( clk,reset_n		: IN    std_logic;
  		start_bit			: IN    std_logic;
		baud_tick			: IN 	  std_logic;
    	bit_count     		: OUT   std_logic_vector(3 downto 0)
    	);
END bit_counter;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bit_counter IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT  	max_val: 			   unsigned(width-1 downto 0):= to_unsigned(4,width); -- convert integer value 4 to unsigned with 4bits
SIGNAL 		count, next_bit_count: 	unsigned(width-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  bit_counter: PROCESS(all)
  BEGIN	
	-- load	
	IF (start_bit = '1') THEN
		next_bit_count <= to_unsigned(9,width)	;
	
  	-- decrement
  	ELSIF (bit_count > "0000") and baud_tick = '1' THEN
  		next_bit_count <= count - 1 ;
  	
  	-- freezes
  	ELSE
  		next_bit_count <= count;
  	END IF;
	
  END PROCESS bit_counter;   
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(all)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= to_unsigned(0,width); -- convert integer value 0 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		count <= next_bit_count ;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  bit_count <= std_logic_vector(count);
 -- End Architecture 
------------------------------------------- 
END rtl;
