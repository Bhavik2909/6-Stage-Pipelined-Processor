--Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port(d_add,d_write: in std_logic_vector(15 downto 0);
        d_read: out std_logic_vector(15 downto 0);
        en_r,en_w,clk: in std_logic);
end entity memory;

architecture behave of memory is
    type mem_array is array (2**4-1 downto 0) of std_logic_vector(15 downto 0);     --Memory Array
    signal data :mem_array:=(others=>(others=>'0'));                  --Initialization of Memory Array
begin
    Writing: process(d_write,clk,en_w,d_add)
    begin
        if (clk' event and clk = '1') then
            if (en_w = '1') then
                data(to_integer(unsigned(d_add)))<=d_write;
            end if;
        end if;
    end process;

    Reading: process(clk,d_add,en_r)
    begin
        if (en_r = '1') then
            d_read <= data(to_integer(unsigned(d_add)));
        end if;
    end process;
end architecture behave;