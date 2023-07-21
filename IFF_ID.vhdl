--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFF_ID is 
    port (r64_in: in std_logic_vector(63 downto 0);
        clk,en64,rst: in std_logic;
        r64_out: out std_logic_vector(63 downto 0));
end entity IFF_ID;

architecture behave of IFF_ID is
    begin
    process(clk,r64_in,rst)
        begin
		      if(rst = '1') then
                r64_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en64 = '1') then
                    r64_out<=r64_in;
                end if;
            end if;
    end process;
end architecture behave;