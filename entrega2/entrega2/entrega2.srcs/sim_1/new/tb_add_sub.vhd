----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 01:49:29 PM
-- Design Name: 
-- Module Name: tb_add_sub - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_add_sub is
--  Port ( );
end tb_add_sub;

architecture rtl of tb_add_sub is
component add_sub is	
    port(
        data_in, shifter: in    std_logic_vector(23 downto 0);
        signo:   in    std_logic;
        data_out: out  std_logic_vector(23 downto 0)   
	);
end component;

    signal data_in, shifter, data_out, result : std_logic_vector(23 downto 0);
    signal signo : std_logic;
    
begin
    add_sub0: add_sub port map (
        data_in => data_in,
        shifter => shifter,
        signo => signo,
        data_out => data_out
    );
    
    process
    begin
        data_in <= "000000000000000000000111";
        shifter <= "000000000000000000000001";
        signo <= '1';
        wait for 100 ns;
        result <= data_out; 
        wait for 200 ns;
    end process;
end rtl;