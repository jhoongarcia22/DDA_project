----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 04:06:46 PM
-- Design Name: 
-- Module Name: barrel_shifter - rtl
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


entity barrel_shifter is
    port (
        data_in  : in  std_logic_vector(24 downto 0);
        shift    : in  std_logic_vector(4 downto 0);
        data_out : out std_logic_vector(24 downto 0)
    );
end entity barrel_shifter;

architecture rtl of barrel_shifter is
begin

    process (data_in, shift)
    begin
        --data_out <= std_logic_vector(signed(data_in) sra to_integer(unsigned(shift)));
        data_out <= to_stdlogicvector(to_bitvector(std_logic_vector(data_in)) sra to_integer(unsigned(shift)));
    end process;

end architecture rtl;