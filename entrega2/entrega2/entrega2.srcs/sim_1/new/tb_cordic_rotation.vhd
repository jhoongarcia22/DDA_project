----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2023 10:17:44 AM
-- Design Name: 
-- Module Name: tb_cordic_rotation - rtl
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

entity tb_cordic_rotation is
--  Port ( );
end tb_cordic_rotation;

architecture rtl of tb_cordic_rotation is

component cordic_rotation is
Port (     Xi, Yi, Zi : in STD_LOGIC_VECTOR (23 downto 0);
           Xo, Yo : out STD_LOGIC_VECTOR (24 downto 0);  
           Zo : out STD_LOGIC_VECTOR (23 downto 0);      
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           clk: in std_logic;
           rst: in std_logic
           );
end component;

signal Xi,Yi,Zi,Zo:std_logic_vector(23 downto 0);
signal Xo,Yo:std_logic_vector(24 downto 0);
signal start,done,clk,rst: std_logic;
constant clk_period : time := 10 ns;

begin

cordic_rotation0: cordic_rotation port map(    
           Xi=>Xi,
           Yi=>Yi,
           Zi=>Zi,
           Xo=>Xo,
           Yo=>Yo,
           Zo=>Zo,
           start=>start,
           done=>done,
           clk=>clk,           
           rst=>rst);

process
begin
    rst<='1';
    wait for 20*clk_period;
    rst<='0';
    Xi<=std_logic_vector(to_signed(integer(1*2**23-1),24));
    Yi<=std_logic_vector(to_signed(integer(0*2**23),24));
    Zi<=std_logic_vector(to_signed(integer(-2097151),24));
    start<='1';
    wait for 2*clk_period;
    start<='0';
    
    wait for 50*clk_period;
    Xi<=std_logic_vector(to_signed(integer(1*2**23-1),24));
    Yi<=std_logic_vector(to_signed(integer(0*2**23),24));
    Zi<=std_logic_vector(to_signed(integer(2097151),24));
    start<='1';
    wait for 2*clk_period;
    start<='0';
    
    
    wait;
end process;

process
begin
    clk<='0';
    wait for clk_period/2;
    clk<='1';
    wait for clk_period/2;
end process;
end rtl;