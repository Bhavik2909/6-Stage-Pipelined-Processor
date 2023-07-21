--Priority_Encoder_Updated_Version
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe1 is 
  port( I : in std_logic_vector(7 downto 0);
        C : in std_logic_vector(2 downto 0);
		  Y : out std_logic_vector(7 downto 0);
		  A : out std_logic_vector(2 downto 0)
	);
end pe1;

architecture Behavioural of pe1 is
begin
  process(I)
  variable j: integer;
  variable m: std_logic_vector(7 downto 0);
  begin
      m := I;
      j := to_integer(unsigned(C));
      if I(j) = '1' then 
      A <= C;
      m(j) := '0';
      end if;
		Y <= m;
  end process;
end Behavioural;  