library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity alu_add is
port( 
	alu_a : in std_logic_vector(15 downto 0);
	alu_b : in std_logic_vector(15 downto 0);
	alu_c : out std_logic_vector(15 downto 0)
		);
end entity alu_add ;

architecture struc of alu_add is
  
component full_adder is
 Port ( A : in std_logic_vector(15 downto 0);
 B : in std_logic_vector(15 downto 0);
 Cin : in STD_LOGIC;
 S : out std_logic_vector(15 downto 0);
 Cout : out STD_LOGIC);
end component full_adder;

	
	signal c : std_logic ;
	
	begin
	sum_1x : full_adder port map( a => alu_a, b => alu_b, s => alu_c, cin=> '0', cout => c);

end struc;




















