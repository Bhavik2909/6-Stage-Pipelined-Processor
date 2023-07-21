library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use work.Gates.all;

entity shift7  is
  port ( 
	a_in : in std_logic_vector(8 downto 0);
	d_out : out std_logic_vector(15 downto 0));
end entity shift7;

architecture Struct of shift7 is

begin
d_out(6 downto 0) <= "0000000";
d_out(15 downto 7) <= a_in;
		
end Struct ;