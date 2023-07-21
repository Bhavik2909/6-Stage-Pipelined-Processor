library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use work.Gates.all;

entity mem  is
  port (
	-- inputs
	dm_we_mem_in, dm_re_mem_in, clk, rst, rf_we_mem_in: in std_logic ;
	m3_sl_mem_in: in std_logic_vector(1 downto 0);
	m_mem_sl_mem_in : in std_logic_vector(1 downto 0);
	a3_add_mem_in : in std_logic_vector(2 downto 0);
	inst_mem_in, alu1_c_mem_in, rf_d2_mem_in, rf_d1_mem_in : in std_logic_vector(15 downto 0);
	pc_current2_mem_in : in std_logic_vector(15 downto 0);
	shift_mem_in : in std_logic_vector(15 downto 0);
	m9_sl_mem_in: in std_logic;
	alu3_c_mem_in: in std_logic_vector(15 downto 0);
	-- outputs
	rf_we_mem_out : out std_logic ;
	m3_sl_mem_out : out std_logic_vector(1 downto 0) ;
	a3_add_mem_out : out std_logic_vector(2 downto 0);
	inst_mem_out, alu1_c_mem_out, dm_out_mem_out, rf_d1_mem_out : out std_logic_vector(15 downto 0);
	shift_mem_out : out std_logic_vector(15 downto 0);
	mem_fwd_mem_out : out std_logic_vector(15 downto 0);
	pc_current2_mem_out : out std_logic_vector(15 downto 0)
	);

end entity mem;

architecture Struct of mem is

component memory is 
	port(d_add,d_write: in std_logic_vector(15 downto 0);
        d_read: out std_logic_vector(15 downto 0);
        en_r,en_w,clk: in std_logic);
end component memory;

component MUX_4x1_16b is
	port (d : out std_logic_vector(15 downto 0);
    	a : in std_logic_vector(1 downto 0);
    	r1, r2, r3, r4: in std_logic_vector(15 downto 0));
end component MUX_4x1_16b ;

component MUX_2x1_16b is
	port (
	d : out std_logic_vector(15 downto 0);
	a : in std_logic;
	r1, r2: in std_logic_vector(15 downto 0)
	);
end COMPONENT MUX_2x1_16b ;

signal dm_out1 : std_logic_vector(15 downto 0);
signal mem_add_temp: std_logic_vector(15 downto 0);

begin

m3_sl_mem_out <= m3_sl_mem_in;

rf_we_mem_out <= rf_we_mem_in;
a3_add_mem_out <= a3_add_mem_in;
inst_mem_out <= inst_mem_in;

alu1_c_mem_out <= alu1_c_mem_in;
rf_d1_mem_out <= rf_d1_mem_in;

pc_current2_mem_out <= pc_current2_mem_in;
shift_mem_out <= shift_mem_in;

memory_1 : memory port map( d_add => mem_add_temp, d_write => rf_d2_mem_in,
        d_read => dm_out1,
        en_r => dm_re_mem_in, en_w => dm_we_mem_in, clk=> clk);

dm_out_mem_out <= dm_out1;

m_mem : MUX_4X1_16b 
      port map(r1=> dm_out1, r2=>alu1_c_mem_in, r3=>shift_mem_in, r4=> pc_current2_mem_in, a=> m_mem_sl_mem_in, d=>mem_fwd_mem_out);

m9: MUX_2X1_16b 
    port map(r1=> alu1_c_mem_in, r2=>alu3_c_mem_in, a=> m9_sl_mem_in, d=>mem_add_temp);

end Struct ;