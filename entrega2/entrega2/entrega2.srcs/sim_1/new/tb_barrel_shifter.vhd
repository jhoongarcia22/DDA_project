----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 05:32:56 PM
-- Design Name: 
-- Module Name: tb_barrel_shifter - rtl
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_barrel_shifter is
--  Port ( );
end entity;

architecture rtl of tb_barrel_shifter is

component barrel_shifter is
    port (
        data_in  : in  std_logic_vector(23 downto 0);
        shift    : in  std_logic_vector(4 downto 0);
        data_out : out std_logic_vector(23 downto 0)
    );
end component;


    signal data_in : std_logic_vector(23 downto 0);
    signal shift : std_logic_vector(4 downto 0);
    signal data_out : std_logic_vector(23 downto 0);

begin

    barrelshifter0: barrel_shifter port map (
        data_in  => data_in,
        shift    => shift,
        data_out => data_out
    );

    process
    begin
        data_in <= x"823456";
        shift <= "00000";
        wait for 10 ns;
        
        shift <= "00001";
        wait for 10 ns;
        
        shift <= "00100";
        wait for 10 ns;
        
        shift <= "01010";
        wait for 10 ns;
        
        wait;
    end process;

end rtl;