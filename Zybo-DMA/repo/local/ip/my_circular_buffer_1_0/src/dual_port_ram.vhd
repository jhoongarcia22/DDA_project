 -- Simple Dual-Port Block RAM with One Clock
-- Correct Modelization with a Shared Variable
-- File:simple_dual_one_clock.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity dual_port_ram is
    generic(
        c_buffer: integer := 32768;
        data_width: integer := 24;
        addr_width: integer :=15
    );
    port(
        clk    : in  std_logic;
        we_a   : in  std_logic;
        di_a   : in  std_logic_vector(data_width-1 downto 0);
        addr_a : in  std_logic_vector(addr_width-1 downto 0);
        do_b   : out std_logic_vector(data_width-1 downto 0);
        addr_b : in  std_logic_vector(addr_width-1 downto 0)      
    );
end dual_port_ram;

architecture rtl of dual_port_ram is
    type ram_type is array (c_buffer-1 downto 0) of std_logic_vector(data_width-1 downto 0);
    shared variable RAM : ram_type;
    
begin

    process(clk)
        begin
            if rising_edge(clk) then
                if we_a = '1' then    --Escritura
                    RAM(conv_integer(addr_a)) := di_a;
                end if;
            end if;
    end process;
    
    process(clk)
        begin
            if rising_edge(clk) then
                do_b <= RAM(conv_integer(addr_b));
            end if;
    end process;
end rtl; 