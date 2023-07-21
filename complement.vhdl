library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use work.Gates.all;

entity complement  is
  port ( 
	alu_b : in std_logic_vector(15 downto 0);
	alu_b_comp : out std_logic_vector(15 downto 0));
end entity complement;

architecture Struct of complement is

begin
alu_b_comp <= not alu_b;
		
end Struct ;