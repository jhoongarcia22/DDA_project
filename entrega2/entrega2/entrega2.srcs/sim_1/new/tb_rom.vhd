----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 05:37:10 PM
-- Design Name: 
-- Module Name: tb_rom - rtl
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

entity tb_rom is
--  Port ( );
end tb_rom;

architecture rtl of tb_rom is
component rom is
    port(
    clk  : in  std_logic;
    addr : in  std_logic_vector(4 downto 0);
    data : out std_logic_vector(23 downto 0)
    );
end component;

signal clk : std_logic;
signal addr : std_logic_vector(4 downto 0);
signal data : std_logic_vector(23 downto 0);
constant clk_period : time := 400 ns;

begin

rom0: rom port map(
clk=>clk,
addr=>addr,
data=>data
);


    process
    begin
            clk<='0';           
            wait for 10 ns;
            clk <= '1';            
            wait for 10 ns;     
     
    end process;
    
    process
    begin
        wait for 20 ns; addr <= B"00000";
        wait for 20 ns; addr <= B"00001";
        wait for 20 ns; addr <= B"00010";
        wait for 20 ns; addr <= B"00011";
        wait for 20 ns; addr <= B"00100";
        wait for 20 ns; addr <= B"00101";
        wait for 20 ns; addr <= B"00110";
        wait for 20 ns; addr <= B"00111";
        wait for 20 ns; addr <= B"01000";
        wait for 20 ns; addr <= B"01001";
        wait for 20 ns; addr <= B"01010";
        wait for 20 ns; addr <= B"01011";
        wait for 20 ns; addr <= B"01100";
        wait for 20 ns; addr <= B"01101";
        wait for 20 ns; addr <= B"01110";
        wait for 20 ns; addr <= B"01111";
     
     
    end process;
    
end rtl;