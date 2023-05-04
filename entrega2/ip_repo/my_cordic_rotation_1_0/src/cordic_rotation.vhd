----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 09:54:01 PM
-- Design Name: 
-- Module Name: cordic_rotation - rtl
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

entity cordic_rotation is
Port (     Xi, Yi, Zi : in STD_LOGIC_VECTOR (23 downto 0);
           Xo, Yo : out STD_LOGIC_VECTOR (24 downto 0);  
           Zo : out STD_LOGIC_VECTOR (23 downto 0);      
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           clk: in std_logic;
           rst: in std_logic
           );
end cordic_rotation;

architecture rtl of cordic_rotation is
component controlpath is
    port (   
    clk: in std_logic;
    rst: in std_logic;    
    start: in std_logic;
           sel_mux : out STD_LOGIC;
           en_reg : out STD_LOGIC;
           n_count : out std_logic_vector(4 downto 0);     
    done: out std_logic
     );
end component;

component datapath is
    Port ( Xi, Yi, Zi: in STD_LOGIC_VECTOR (23 downto 0);
           Xo, Yo : out STD_LOGIC_VECTOR (24 downto 0);
           Zo : out STD_LOGIC_VECTOR (23 downto 0);
           n: in STD_LOGIC_VECTOR(4 downto 0);
           sel_mux : in STD_LOGIC;
           en_r : in STD_LOGIC;
           clk: in std_logic;
           rst: in std_logic
           );
end component;

signal  mux_int,en_reg_int: STD_LOGIC;
signal  n_int: STD_LOGIC_VECTOR(4 downto 0);


begin

datapath0: datapath port map(    
           Xi=>Xi,
           Yi=>Yi,
           Zi=>Zi,
           Xo=>Xo,
           Yo=>Yo,
           Zo=>Zo,
           sel_mux=>mux_int,
           en_r=>en_reg_int,
           n=>n_int,            
           clk=>clk,
           rst=>rst);

controlpath0: controlpath port map(
           en_reg=>en_reg_int,
           sel_mux=>mux_int,
           n_count=>n_int,
           start=>start, 
           done=>done,                 
           clk=>clk,
           rst=>rst
);


end rtl;