library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFF is
port(PC_WREN: in std_logic;
     PC_IN: IN std_logic_vector(15 DOWNTO 0);
     CLK, reset: in std_logic;
     
     PC_CURRENT_IF_OUT : OUT std_logic_vector(15 DOWNTO 0);
     INST_IF_OUT : OUT std_logic_vector(15 DOWNTO 0);
     PC_NEXT_IF_OUT: OUT std_logic_vector(15 DOWNTO 0);
     PC_CURRENT2_IF_OUT : OUT std_logic_vector(15 DOWNTO 0)
     );
end IFF;

architecture gun of IFF is

component memory is
    port(d_add,d_write: in std_logic_vector(15 downto 0);
        d_read: out std_logic_vector(15 downto 0);
        en_r,en_w,clk: in std_logic);
end component memory;

component reg is 
    port (d_in: in std_logic_vector(15 downto 0);
        clk,en,rst: in std_logic;
        d_out: out std_logic_vector(15 downto 0));
end component reg;

COMPONENT full_adder is
    Port ( A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    Cin : in STD_LOGIC;
    S : out std_logic_vector(15 downto 0);
    Cout : out STD_LOGIC);
   end COMPONENT;

SIGNAL PC_OUT: std_logic_vector(15 downto 0);
SIGNAL COUT1,Cout2:STD_LOGIC;

begin 
R1: reg
port map(d_in=>PC_IN, D_out=>PC_OUT, EN=>PC_WREN, RST=>reset, clk=>clk);

M1: memory
port map(d_add=>pc_out, d_read=>inst_if_out, en_r=>'1' , en_w=>'0', clk=>clk,d_write=>pc_in);

PC_CURRENT_if_out <= PC_OUT;

F1: full_adder
port map( A=>PC_OUT, S=>PC_NEXT_IF_OUT, COUT=>COUT1, B=>"0000000000000000", Cin=>'1');

F2: full_adder
port map(A=>PC_OUT, B=>"0000000000000001",Cin=>'1', S=>PC_CURRENT2_IF_OUT, Cout=>Cout2);

end gun;