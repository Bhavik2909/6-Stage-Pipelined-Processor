--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_1b is 
    port (d_in: in std_logic;
        clk,en,rst: in std_logic;
        d_out: out std_logic);
end entity reg_1b;

architecture behave of reg_1b is
    begin
    process(clk,d_in,rst)
        begin
		      if(rst = '1') then
                d_out <= '0';
            elsif(clk'event and clk='0') then
                if(en = '1') then
                    d_out<=d_in;
                end if;
            end if;
    end process;
end behave;