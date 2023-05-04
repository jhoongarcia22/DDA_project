----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.08.2022 15:45:22
-- Design Name: 
-- Module Name: smult - Behavioral
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


entity reg is
	generic (N	:integer:=8 );
    port(
        clk: in 		std_logic;
        en: in std_logic;
        rst: in           std_logic;
        clr: in           std_logic;
        d: in 		std_logic_vector(N-1 downto 0);
        q: out	std_logic_vector(N-1 downto 0)
        );
end entity;

architecture rtl of reg is
begin

process(clk,d,rst,en) begin
    if(rst='1') then
        q<=(others=>'0');
    elsif(rising_edge(clk)) then
        if(en='1') then
            if(clr='1') then
                q<=(others=>'0');
            else
                q<=d;
            end if;
        end if;
    end if;

end process;
end architecture;