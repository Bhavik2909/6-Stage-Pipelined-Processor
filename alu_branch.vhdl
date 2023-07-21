library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity alu_branch is
port( 
	alu_a : in std_logic_vector(15 downto 0);
	alu_imm : in std_logic_vector(15 downto 0);
	alu_sum2 : out std_logic_vector(15 downto 0)
		);
end entity alu_branch ;

architecture struc of alu_branch is
  

component full_adder is
 Port ( A : in std_logic_vector(15 downto 0);
 B : in std_logic_vector(15 downto 0);
 Cin : in STD_LOGIC;
 S : out std_logic_vector(15 downto 0);
 Cout : out STD_LOGIC);
end component full_adder;
	
	signal t1 : std_logic_vector(15 downto 0);
	signal c,c1 : std_logic ;
	
	begin
	sum_1x : full_adder port map( A => alu_a, B => alu_imm, Cin=> '0',S => t1, Cout => c);
	sum_2x : full_adder port map( A => t1, B => alu_imm, Cin => c, S => alu_sum2, Cout => c1);

end struc;




















