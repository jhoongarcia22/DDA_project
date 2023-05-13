----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 08:08:09 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.ALL;

entity fsm is     
     port (   
    clk: in std_logic;
    rst: in std_logic;    
           
           sel_mux : out STD_LOGIC;
          
           en_counter: out STD_LOGIC;
           clr_counter: out STD_LOGIC;
           
    ovf: in std_logic;
    start: in std_logic;
    en_reg: out std_logic
   
 
     );
end entity;

architecture rtl of fsm is

	type state_type is (start_state,compute_state,counter_state);
	signal state: state_type;

begin

-- Next state logic
PROCESS (clk, rst)
	BEGIN
	    -- Reset asincr�nico
		IF rst = '1' THEN
			state <= start_state;			
		ELSIF RISING_EDGE(clk) THEN
			CASE state IS				
				WHEN start_state =>					
					IF start='1' THEN
						state <=compute_state;
					ELSE
						state <=start_state;
					END IF;
				WHEN compute_state =>
					state<=counter_state;
				WHEN counter_state =>
					IF ovf='0' THEN
						state <= compute_state;
					ELSE
						state <=start_state;
					END IF;			
				WHEN others =>
						state <= start_state;
			END CASE;			
		END IF;
	END PROCESS;

-- Output logic
process(state,start,ovf) 
begin

 case state is
      when start_state =>
            if (start='1' ) then
                clr_counter<='1';        
                en_counter<='1';
                sel_mux<='1';
                en_reg<= '1';
       
            else 
                clr_counter<='0';         
                en_counter<='0';
                sel_mux<='0';
                en_reg<= '0';
       
end if;
      
      
      
         
      when compute_state =>
          
           clr_counter<='0';         
            en_counter<='1';       
            sel_mux<='0';
            en_reg<= '1';
     
    
      
      
        
        
      when counter_state =>
      
            clr_counter<='0';      
            en_counter<='0';     
            sel_mux<='0';
            en_reg<= '0';
        
     
       
       
       

        
      
        
      when others =>       
            sel_mux<='0';
      clr_counter <='0';
      en_counter<='0';
      en_reg<= '0';

       
    end case;


end process;

end architecture;