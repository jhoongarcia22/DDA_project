 -- ROM Inference on array

-- File: roms_1.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom is
    port(
    clk  : in  std_logic;
    addr : in  std_logic_vector(4 downto 0);
    data : out std_logic_vector(23 downto 0)
    );
end rom;

architecture rtl of rom is

type rom_type is array (0 to 23) of std_logic_vector(23 downto 0);

signal ROM : rom_type := (X"200000", X"12E405", X"09FB38", X"051112", X"028B0D", X"0145D8", X"00A2F6", X"00517C", X"0028BE",
X"00145F", X"000A30", X"000518", X"00028C", X"000146", X"0000A3", X"000051", X"000029", X"000014", X"00000A", X"000005",
X"000003", X"000001", X"000001", X"000000");


attribute rom_style : string;
attribute rom_style of ROM : signal is "block";

begin

    process(clk)
    begin
        data <= ROM(conv_integer(addr));
    end process;

end rtl; 