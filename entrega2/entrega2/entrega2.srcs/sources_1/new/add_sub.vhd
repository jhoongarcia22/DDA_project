----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 08:17:26 AM
-- Design Name: 
-- Module Name: ope - rtl
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

entity add_sub is	
	generic (N	:integer:=24 );
    port(
        data_in, shifter: in    std_logic_vector(N-1 downto 0);
        signo:   in    std_logic;
        data_out: out  std_logic_vector(N-1 downto 0)   
	);
end entity;

architecture rtl of add_sub is

begin

process(data_in, shifter, signo) begin
    if(signo = '1') then
        data_out <= std_logic_vector(signed(data_in) + signed(shifter));
    else
        data_out <= std_logic_vector(signed(data_in) - signed(shifter));
    end if;
end process;
end rtl;