--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is 
    port (d_in: in std_logic_vector(15 downto 0);
        clk,en,rst: in std_logic;
        d_out: out std_logic_vector(15 downto 0));
end entity reg;

architecture behave of reg is
    begin
    process(clk,d_in,rst)
        begin
		      if(rst = '1') then
                d_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en = '1') then
                    d_out<=d_in;
                end if;
            end if;
    end process;
end architecture behave;