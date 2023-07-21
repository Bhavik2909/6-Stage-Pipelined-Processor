library ieee;
use ieee.std_logic_1164.all;

entity Nand1 is
port(Inp1 : in std_logic_vector(15 downto 0);
	  Inp2 : in std_logic_vector(15 downto 0);
	  Outp : out std_logic_vector(15 downto 0)
	  );
end entity;

architecture yes of Nand1 is

begin

Outp <= Inp1 nand Inp2;

end yes;