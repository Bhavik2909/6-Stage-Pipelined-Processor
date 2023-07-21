--Priority_Encoder_Updated_Version
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pe is 
  port( I : in std_logic_vector(7 downto 0);
		  Y : out std_logic_vector(7 downto 0);
		  A : out std_logic_vector(2 downto 0)
	);
end pe;

architecture Behavioural of pe is
begin
  process(I)
  variable j: integer;
  variable m: std_logic_vector(7 downto 0);
  begin
    m := I;
    for j in 0 to 7 loop   	
      if I(j) = '1' then
		  A <= conv_std_logic_vector(j,3);
		  m(j) := '0';
		  end if;
		exit;
		Y <= m;
    end loop;
  end process;
end Behavioural;  