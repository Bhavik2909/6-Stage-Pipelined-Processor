--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_rr is 
    port (r92_in: in std_logic_vector(91 downto 0);
        clk,en92,rst: in std_logic;
        r92_out: out std_logic_vector(91 downto 0));
end entity ID_rr;

architecture behave of ID_rr is
    begin
    process(clk,r92_in,rst)
        begin
		      if(rst = '1') then
                r92_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en92 = '1') then
                    r92_out<=r92_in;
                end if;
            end if;
    end process;
end architecture behave;