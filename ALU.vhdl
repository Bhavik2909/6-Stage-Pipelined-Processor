library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port( 
	alu_a : in std_logic_vector(15 downto 0);
	alu_b : in std_logic_vector(15 downto 0);
	enable_alu: in std_logic_vector(3 downto 0);
    carry_add: in std_logic_vector(1 downto 0);
    Cin: in std_logic;
    Zin: in std_logic;
	alu_c : out std_logic_vector(15 downto 0);
	Cout : out std_logic;
	Zout : out std_logic
		);

end entity ALU;

architecture yes of AlU is

component Nand1 is
	port(
			Inp1 : in std_logic_vector(15 downto 0);
	      Inp2 : in std_logic_vector(15 downto 0);
	      Outp : out std_logic_vector(15 downto 0)
	    );
end component;
    
component subtractor is
      port(
          A ,B:in std_logic_vector(15 downto 0);
          S : out std_logic_vector(15 downto 0);
          c_temp : out std_logic
      );
      end component subtractor;    
  
component full_adder is
        Port ( A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        Cin : in STD_LOGIC;
        S : out std_logic_vector(15 downto 0);
        Cout : out STD_LOGIC);
       end component;

       signal t1,t2,t3: std_logic_vector(15 downto 0);
       signal c_temp_2,carry_flag_temp,c_temp1: std_logic;

begin
       C1: NAND1
       port map(inp1 => alu_a, inp2 => alu_b, outp =>t1 ); 
       C2: full_adder
       port map(A=>alu_a, B=>alu_b, Cin => carry_flag_temp, S=>t2, Cout=>c_temp_2);  
       C3: subtractor
       port map(A=>alu_a, B=>alu_b, S=>t3, c_temp=>c_temp1);

      ALU_beh : process (t2,t3,c_temp_2,carry_flag_temp,c_temp1,alu_a ,alu_b,enable_alu,carry_add,Cin,Zin,t1,t2)
		begin
		
		if (enable_alu="0000") then
			if (carry_add="11") then
				carry_flag_temp <= Cin;
			else carry_flag_temp <='0';
			end if;
		elsif (enable_alu="0001") then
			if (carry_add="11") then
				carry_flag_temp <= Cin;
			end if;
		end if;

       case enable_alu is 
       when "0010" => if carry_add ="00" then alu_c<= t1; end if;
        if carry_add ="10" and Cin='1' then alu_c<=t1;end if;
        if carry_add ="01" and Zin='1'then alu_c<=t1;end if;
		  if t1="0000000000000000" then Zout<='1';end if;

       when "0001" => if carry_add ="00" then alu_c<=t2;end if;
         if carry_add ="10" and Cin='1' then alu_c<=t2;end if;
         if carry_add ="01" and Zin='1' then alu_c<=t2;end if;
        if  carry_add ="11" then alu_c<=t2;end if;
        alu_c<=t2;
		  if t2="0000000000000000" then Zout<='1';end if;
		  Cout<=C_temp_2;

       when "1000" => alu_c<=t3;
		  IF t3="0000000000000000" THEN Zout<='1';end if;
       when "1001" => alu_c<=t3;
		  Cout<=C_temp1;
       when "1011" => alu_c<=t3;
		  Cout<=C_temp1;

       when "0000" => Cout<=C_temp_2;
		 if t2="0000000000000000" then Zout<='1';end if;
       WHEN others => Zout<='0';
       
       end case;
    end process;
end yes;