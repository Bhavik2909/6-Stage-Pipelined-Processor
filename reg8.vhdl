--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg8 is 
    port (r8_in: in std_logic_vector(7 downto 0);
        clk,en8,rst: in std_logic;
        r8_out: out std_logic_vector(7 downto 0));
end entity reg8;

architecture behave of reg8 is
    begin
    process(clk,r8_in,rst)
        begin
		      if(rst = '1') then
                r8_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en8 = '1') then
                    r8_out<=r8_in;
                end if;
            end if;
    end process;
end architecture behave;