--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_WB is 
    port (r117_in: in std_logic_vector(117 downto 0);
        clk,en117,rst: in std_logic;
        r117_out: out std_logic_vector(117 downto 0));
end entity mem_WB;

architecture behave of mem_WB is
    begin
    process(clk,r117_in,rst)
        begin
		      if(rst = '1') then
                r117_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en117 = '1') then
                    r117_out<=r117_in;
                end if;
            end if;
    end process;
end architecture behave;