library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity full_adder is
 Port ( A : in std_logic_vector(15 downto 0);
 B : in std_logic_vector(15 downto 0);
 Cin : in STD_LOGIC;
 S : out std_logic_vector(15 downto 0);
 Cout : out STD_LOGIC);
end full_adder;
 
architecture gate_level of full_adder is

    signal C:std_logic_vector(14 downto 0);
 
begin

 S(0) <= A(0) XOR B(0) XOR Cin ;
 C(0) <= (A(0) AND B(0)) OR (Cin AND A(0)) OR (Cin AND B(0)) ;   
 
 S(1) <= A(1) XOR B(1) XOR C(0) ;
 C(1) <= (A(1) AND B(1)) OR (C(0) AND A(1)) OR (C(0) AND B(1)) ;

 S(2) <= A(2) XOR B(2) XOR C(1) ;
 C(2) <= (A(2) AND B(2)) OR (C(1) AND A(2)) OR (C(1) AND B(2)) ;

 S(3) <= A(3) XOR B(3) XOR C(2) ;
 C(3) <= (A(13) AND B(3)) OR (C(2) AND A(3)) OR (C(2) AND B(3)) ;

 S(4) <= A(4) XOR B(4) XOR C(3) ;
 C(4) <= (A(14) AND B(4)) OR (C(3) AND A(4)) OR (C(3) AND B(4)) ;

 S(5) <= A(5) XOR B(5) XOR C(4) ;
 C(5) <= (A(5) AND B(5)) OR (C(4) AND A(5)) OR (C(4) AND B(5)) ;

 S(6) <= A(6) XOR B(6) XOR C(5) ;
 C(6) <= (A(6) AND B(6)) OR (C(5) AND A(6)) OR (C(5) AND B(6)) ;

 S(7) <= A(7) XOR B(7) XOR C(6) ;
 C(7) <= (A(7) AND B(7)) OR (C(6) AND A(7)) OR (C(6) AND B(7)) ;

 S(8) <= A(8) XOR B(8) XOR C(7) ;
 C(8) <= (A(8) AND B(8)) OR (C(7) AND A(8)) OR (C(7) AND B(8)) ;

 S(9) <= A(9) XOR B(9) XOR C(8) ;
 C(9) <= (A(9) AND B(9)) OR (C(8) AND A(9)) OR (C(8) AND B(9)) ;

 S(10) <= A(10) XOR B(10) XOR C(9) ;
 C(10) <= (A(10) AND B(10)) OR (C(9) AND A(10)) OR (C(9) AND B(10)) ;

 S(11) <= A(11) XOR B(11) XOR C(10) ;
 C(11) <= (A(11) AND B(11)) OR (C(10) AND A(11)) OR (C(10) AND B(11)) ;

 S(12) <= A(12) XOR B(12) XOR C(11) ;
 C(12) <= (A(12) AND B(12)) OR (C(11) AND A(12)) OR (C(11) AND B(12)) ;

 S(13) <= A(13) XOR B(13) XOR C(12) ;
 C(13) <= (A(13) AND B(13)) OR (C(12) AND A(13)) OR (C(12) AND B(13)) ;

 S(14) <= A(14) XOR B(14) XOR C(13) ;
 C(14) <= (A(14) AND B(14)) OR (C(13) AND A(14)) OR (C(13) AND B(14)) ;

 S(15) <= A(15) XOR B(15) XOR C(14) ;
 Cout <= (A(15) AND B(15)) OR (C(14) AND A(15)) OR (C(14) AND B(15)) ;

end gate_level;
