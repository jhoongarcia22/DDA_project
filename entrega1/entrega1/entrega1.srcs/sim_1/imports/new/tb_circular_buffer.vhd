----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2023 08:22:14 PM
-- Design Name: 
-- Module Name: tb_circular_buffer - rtl
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
use std.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_circular_buffer is
--  Port ( );
end tb_circular_buffer;

architecture rtl of tb_circular_buffer is

component s_circular_buffer is
    port(
        clk: in std_logic;                            --señal del reloj
        necho_en: in std_logic;                       --habilitador del registro
        write_en: in std_logic;                       --habilitador de escritura 
        data_in: in std_logic_vector(23 downto 0);    --dato de entrada
        data_out: out std_logic_vector(23 downto 0)   --dato de salida
    );
end component;

-- Signals for entity under test
signal data_in,data_out: std_logic_vector(23 downto 0);
signal clk, necho_en, write_en: std_logic;

-- For text file
file input_buf1: text;

-- Clock period for simulation
constant clk_period : time := 10 ns;

begin

cbuffer: s_circular_buffer
    port map(
        clk => clk,  
        necho_en => necho_en,                                 
        write_en => write_en,                                
        data_in  => data_in, 
        data_out => data_out   
    );
    
    -- Process for data and clock generation
    process
    variable data_buf : line;
    variable value: integer;
    begin     
   
        -- write_en
            write_en <='0';
            necho_en <= '1';    
            data_in  <= std_logic_vector(to_signed(32767,24));       
            clk <='0';          
            wait for clk_period/2;
            clk <= '1'; 
            wait for clk_period/2;
            
            
            necho_en <= '0';    
            write_en <= '1';
            clk <='0';            
            wait for clk_period/2;
            clk <= '1'; 
            wait for clk_period/2;
            
          
            
        -- Open data files
        file_open(input_buf1, "mod_signal.txt",  read_mode);     
                   
         while not endfile(input_buf1) loop
           -- Read line
           readline(input_buf1, data_buf);           
           --Read value
           read(data_buf,value);           
           -- Put data in port a
           data_in<=std_logic_vector(to_signed(value,24));
           
           -- Clock pulse
            clk<='0';           
            wait for clk_period/2;
            clk <= '1';            
            wait for clk_period/2;
            
        end loop;        
    end process;

end rtl;
