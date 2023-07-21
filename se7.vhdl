--Sign_Extender_7
library ieee;
use ieee.std_logic_1164.ALL;

entity se7 is 
  port( se_in : in std_logic_vector(8 downto 0);
	    se_out : out std_logic_vector(15 downto 0));
end se7;


architecture Behavioral of se7 is 
begin 
  se_out <= "0000000" & se_in when se_in(8) ='0' else 
            "1111111" & se_in ;
end Behavioral;