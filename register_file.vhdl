--Register File
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port(a1,a2,a3: in std_logic_vector(2 downto 0);
        d3: in std_logic_vector(15 downto 0);
        d1,d2: out std_logic_vector(15 downto 0);
        clk,rst,rf_e: in std_logic);
end entity register_file;

architecture behave of register_file is
    type rf_array is array (7 downto 0) of std_logic_vector(15 downto 0);   --Register File Array
    signal data: rf_array := (others=>(others => '0'));           --Initialization
begin
    Registers: process(clk,rf_e,rst,a3)
    begin
        if (rst = '1') then
            data<= (others=>(others => '0'));
        elsif (rising_edge(clk) and rf_e = '1') then
            data(to_integer(unsigned(a3)))<= d3;
        end if;
    end process;
    d1<= data(to_integer(unsigned(a1)));
    d2<= data(to_integer(unsigned(a2)));
end architecture behave;