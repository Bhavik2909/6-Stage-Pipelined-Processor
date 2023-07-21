--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg3 is 
    port (r3_in: in std_logic_vector(2 downto 0);
        clk,en3,rst: in std_logic;
        r3_out: out std_logic_vector(2 downto 0));
end entity reg3;

architecture behave of reg3 is
    begin
    process(clk,r3_in,rst)
        begin
		      if(rst = '1') then
                r3_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en3 = '1') then
                    r3_out<=r3_in;
                end if;
            end if;
    end process;
end architecture behave;