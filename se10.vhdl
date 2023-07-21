--Sign_Extender_10
library ieee;
use ieee.std_logic_1164.ALL;

entity se10 is 
  port( se_in : in std_logic_vector(5 downto 0);
	    se_out : out std_logic_vector(15 downto 0));
end se10;


architecture Behavioral of se10 is 
begin 
  se_out <= "0000000000" & se_in when se_in(5) ='0' else 
            "1111111111" & se_in ;
end Behavioral;