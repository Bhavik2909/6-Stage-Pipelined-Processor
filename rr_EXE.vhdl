--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rr_EXE is 
    port (r183_in: in std_logic_vector(182 downto 0);
        clk,en183,rst: in std_logic;
        r183_out: out std_logic_vector(182 downto 0));
end entity rr_EXE;

architecture behave of rr_EXE is
    begin
    process(clk,r183_in,rst)
        begin
		      if(rst = '1') then
                r183_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en183 = '1') then
                    r183_out<=r183_in;
                end if;
            end if;
    end process;
end architecture behave;