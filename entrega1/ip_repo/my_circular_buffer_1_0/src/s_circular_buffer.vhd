----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2023 08:18:50 AM
-- Design Name: 
-- Module Name: s_circular_buffer - rtl
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

entity s_circular_buffer is
    port(
        clk: in std_logic;                            --señal del reloj
        necho_en: in std_logic;                       --habilitador del registro
        write_en: in std_logic;                       --habilitador de escritura 
        data_in: in std_logic_vector(23 downto 0);    --dato de entrada
        data_out: out std_logic_vector(23 downto 0)   --dato de salida
    );
end s_circular_buffer;


architecture rtl of s_circular_buffer is

    component circular_buffer is
        generic(
            c_buffer: integer := 32768;
            data_width: integer := 24;
            addr_width: integer :=15
        );
        port(
            clk: in std_logic;                            --señal del reloj
            necho_en: in std_logic;                       --habilitador del registro
            write_en: in std_logic;                       --habilitador de escritura 
            data_in: in std_logic_vector(data_width-1 downto 0);    --dato de entrada
            data_out: out std_logic_vector(data_width-1 downto 0)   --dato de salida
        );
    end component;
begin
       s_circular: circular_buffer 
       generic map(
            c_buffer => 32768,
            data_width => 24,
            addr_width => 15
        )
        port map (
            clk    => clk,
            necho_en   => necho_en,
            write_en   => write_en,
            data_in    => data_in,
            data_out   => data_out
        );

end rtl;
