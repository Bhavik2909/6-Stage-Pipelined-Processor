library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use work.Gates.all;

entity rr  is
  port (
	-- inputs
	rf_we_wb_out, clk, rst: in std_logic ;
	a1_add_rr_in, a2_add_rr_in, a3_add_wb_out, a3_add_rr_in : in std_logic_vector(2 downto 0);
	rf_d3_wb_out : in std_logic_vector(15 downto 0);
	rf_we_rr_in, dm_we_rr_in, dm_re_rr_in, m1_sl_rr_in, m6_sl_rr_in : in std_logic;
	notclear_rr_in : in std_logic;
	m2_sl_rr_in, m7_sl_rr_in, m4_sl_rr_in, m3_sl_rr_in, m5_sl_rr_in : in std_logic_vector(1 downto 0);
	m_mem_sl_rr_in, m_ex_sl_rr_in : in std_logic_vector(1 downto 0);
	inst_rr_in : in std_logic_vector(15 downto 0);
	pc_current_rr_in, pc_current2_rr_in : in std_logic_vector(15 downto 0);
	mem_fwd_rr_in, ex_fwd_rr_in : in std_logic_vector(15 downto 0);
	pc_next_rr_in : in std_logic_vector(15 downto 0);
	m8_sl_rr_in, m9_sl_rr_in, m10_sl_rr_in: in std_logic;
	ex_t1_e_rr_in: in std_logic;
  

	-- outputs
	rf_d1_rr_out, rf_d2_rr_out, d2_comp_rr_out, se6_rr_out, se9_rr_out, shift_rr_out : out std_logic_vector(15 downto 0);
	m1_sl_rr_out, dm_we_rr_out, dm_re_rr_out, rf_we_rr_out, st_en_rr_out, m6_sl_rr_out : out std_logic;
	m2_sl_rr_out, m7_sl_rr_out, m3_sl_rr_out : out std_logic_vector(1 downto 0);
	a3_add_rr_out : out std_logic_vector(2 downto 0);
	inst_rr_out : out std_logic_vector(15 downto 0);
	pc_next_rr_out : out std_logic_vector(15 downto 0);
	m_mem_sl_rr_out, m_ex_sl_rr_out : out std_logic_vector(1 downto 0);
	pc_current_rr_out, pc_current2_rr_out : out std_logic_vector(15 downto 0);
	m8_sl_rr_out, m9_sl_rr_out, m10_sl_rr_out: out std_logic;
	ex_t1_e_rr_out: out std_logic
	);

end entity rr;

architecture Struct of rr is

component register_file is 
	port(a1,a2,a3: in std_logic_vector(2 downto 0);
        d3: in std_logic_vector(15 downto 0);
        d1,d2: out std_logic_vector(15 downto 0);
        clk,rst,rf_e: in std_logic);
end component register_file;

component se10 is 
	port(se_in : in std_logic_vector(5 downto 0);
	    se_out : out std_logic_vector(15 downto 0));
end component se10;

component se7 is 
	port(se_in : in std_logic_vector(8 downto 0);
	    se_out : out std_logic_vector(15 downto 0));
end component se7;

component shift7 is 
	port(a_in : in std_logic_vector(8 downto 0);
	d_out : out std_logic_vector(15 downto 0));
end component shift7;

component complement is 
	port(alu_b : in std_logic_vector(15 downto 0);
	alu_b_comp : out std_logic_vector(15 downto 0));
end component complement;

component MUX_4x1_16b is
            port (
             d : out std_logic_vector(15 downto 0);
             a : in std_logic_vector(1 downto 0);
             r1, r2, r3, r4: in std_logic_vector(15 downto 0)
             );
end component MUX_4x1_16b ;

signal rf_d2_copy1, rf_d2_copy2, rf_d1_copy, mux_r4 : std_logic_vector(15 downto 0);

begin

sign_extender_6 : se10 port map( se_in => inst_rr_in(5 downto 0), se_out => se6_rr_out);
sign_extender_9 : se7 port map( se_in => inst_rr_in(8 downto 0), se_out => se9_rr_out);
shifter_comp : shift7 port map( a_in => inst_rr_in(8 downto 0), d_out => shift_rr_out);

m7_sl_rr_out <= m7_sl_rr_in;
m6_sl_rr_out <= m6_sl_rr_in;
m3_sl_rr_out <= m3_sl_rr_in;
m2_sl_rr_out <= m2_sl_rr_in;
m1_sl_rr_out <= m1_sl_rr_in;
m_mem_sl_rr_out <= m_mem_sl_rr_in;
m_ex_sl_rr_out <= m_ex_sl_rr_in;
m8_sl_rr_out <= m8_sl_rr_in;
m9_sl_rr_out <= m9_sl_rr_in;
m10_sl_rr_out <= m10_sl_rr_in;
ex_t1_e_rr_out <= ex_t1_e_rr_in;

m4 : MUX_4x1_16b port map(d => rf_d1_rr_out, r1 => mem_fwd_rr_in, r2 => ex_fwd_rr_in, r3 => rf_d1_copy, r4 => mux_r4, a => m4_sl_rr_in);
m5 : MUX_4x1_16b port map(d => rf_d2_copy2, r1 => mem_fwd_rr_in, r2 => ex_fwd_rr_in, r3 => rf_d2_copy1, r4 => mux_r4, a => m5_sl_rr_in);

a3_add_rr_out <= a3_add_rr_in;
inst_rr_out <= inst_rr_in;
pc_current_rr_out <= pc_current_rr_in;
pc_next_rr_out <= pc_next_rr_in;
pc_current2_rr_out <= pc_current2_rr_in;

rf_file_1 : register_file port map( a1 => a1_add_rr_in, a2 => a2_add_rr_in, a3 => a3_add_wb_out,
		  d3 => rf_d3_wb_out,
        d1 => rf_d1_copy, d2 => rf_d2_copy1,
        clk => clk, rst => rst, rf_e => rf_we_wb_out);
		  
complement_1 : complement port map(alu_b => rf_d2_copy2, alu_b_comp => d2_comp_rr_out);

rf_d2_rr_out <= rf_d2_copy2;

AND_br1 : AND_2 port map(A => dm_we_rr_in, B=> notclear_rr_in, Y=> dm_we_rr_out);
AND_br2 : AND_2 port map(A => dm_re_rr_in, B=> notclear_rr_in, Y=> dm_re_rr_out);
AND_br3 : AND_2 port map(A => rf_we_rr_in, B=> notclear_rr_in, Y=> rf_we_rr_out);

end Struct ;