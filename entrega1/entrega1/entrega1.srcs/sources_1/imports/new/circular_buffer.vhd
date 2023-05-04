----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 08:11:31 AM
-- Design Name: 
-- Module Name: circular_buffer - architecture
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

entity circular_buffer is
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
end circular_buffer;

architecture rtl of circular_buffer is

    signal read_addr, write_addr, n_echo: std_logic_vector(addr_width-1 downto 0); --direcciones de lectura, escritura ysalida del reg
        
    component dual_port_ram is
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
    end component;
    
begin

    ram: dual_port_ram 
        port map (
            clk    => clk,
            we_a   => write_en,
            di_a   => data_in,
            addr_a => write_addr,
            do_b   => data_out,
            addr_b => read_addr
        );
    
    n_echo <= data_in(addr_width-1 downto 0) when rising_edge(clk) and (necho_en = '1');
     
    process(clk) 
    begin
        if rising_edge(clk) then         
            if write_en = '1' then         --escritura
                write_addr <= std_logic_vector(unsigned(write_addr) - 1);              
            end if;
                read_addr <= std_logic_vector(unsigned(write_addr) + unsigned(n_echo));   --lectura             
        end if;
    end process;
             
end rtl;