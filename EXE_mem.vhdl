--Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXE_mem is 
    port (r157_in: in std_logic_vector(159 downto 0);
        clk,en157,rst: in std_logic;
        r157_out: out std_logic_vector(159 downto 0));
end entity EXE_mem;

architecture behave of EXE_mem is
    begin
    process(clk,r157_in,rst)
        begin
		      if(rst = '1') then
                r157_out <= (others => '0');
            elsif(clk'event and clk='0') then
                if(en157 = '1') then
                    r157_out<=r157_in;
                end if;
            end if;
    end process;
end architecture behave;