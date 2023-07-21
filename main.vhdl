library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use work.Gates.all;

entity main is
 port (clk : in std_logic;
       rst : in std_logic
 );  
end main;

architecture behave of main is 

component IFF is
port(PC_WREN: in std_logic;
     PC_IN: IN std_logic_vector(15 DOWNTO 0);
     CLK, reset: in std_logic;
     
     PC_CURRENT_IF_OUT : OUT std_logic_vector(15 DOWNTO 0);
     INST_IF_OUT : OUT std_logic_vector(15 DOWNTO 0);
     PC_NEXT_IF_OUT: OUT std_logic_vector(15 DOWNTO 0);
     PC_CURRENT2_IF_OUT : OUT std_logic_vector(15 DOWNTO 0)
     );
end component IFF;
  
component IFF_ID is 
    port (r64_in: in std_logic_vector(63 downto 0); -- remember to change the number of bits of the input and check for all the pipeline registers
        clk,en64,rst: in std_logic;
        r64_out: out std_logic_vector(63 downto 0));
end component IFF_ID;

component id is
    port(
        clk,rst: in std_logic;
		  notclear_id_in: in std_logic;
        inst_id_in, pc_current_id_in, pc_next_id_in, pc_current2_id_in: in std_logic_vector(15 downto 0);
        inst_id_out, pc_current_id_out, pc_current2_id_out, pc_next_id_out: out std_logic_vector(15 downto 0);
        a1_add_id_out,a2_add_id_out,a3_add_id_out: out std_logic_vector(2 downto 0);
        rf_we_id_out,dm_we_id_out,dm_re_id_out,m1_sl_id_out, ex_t1_e_id_out, pc_write_id_out: out std_logic;
        m2_sl_id_out,m3_sl_id_out: out std_logic_vector(1 downto 0);
        m6_sl_id_out, m8_sl_id_out, m9_sl_id_out, m10_sl_id_out: out std_logic;
        m7_sl_id_out, m_ex_sl_id_out, m_mem_sl_id_out: out std_logic_vector(1 downto 0)
    );
end component id;

component ID_rr is 
    port (r92_in: in std_logic_vector(91 downto 0);
        clk,en92,rst: in std_logic;
        r92_out: out std_logic_vector(91 downto 0));
end component ID_rr;

component rr  is
  port (
	-- inputs
	rf_we_wb_out, clk, rst : in std_logic ;
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
end component rr;

component rr_EXE is 
    port (r183_in: in std_logic_vector(182 downto 0);
        clk,en183,rst: in std_logic;
        r183_out: out std_logic_vector(182 downto 0));
end component rr_EXE;

component EXE is 
    port( 
        inst_ex_in :in std_logic_vector(15 downto 0);
        A3_ADD_ex_in  :in std_logic_vector(2 downto 0);
        RF_WE_ex_in : in std_logic;
        DM_RE_ex_in , DM_WE_ex_in: in std_logic;
        M2_SL_ex_in, m7_sl_ex_in, m_ex_sl_ex_in, m_mem_sl_ex_in,  M3_SL_ex_in : in std_logic_vector(1 downto 0);
        M1_SL_ex_in, m6_sl_ex_in, m8_sl_ex_in, m10_sl_ex_in, m9_sl_ex_in : in std_logic;
	    ex_t1_e_ex_in : in std_logic;
        D2_COMP_ex_in ,SE_9_ex_in, SE_6_ex_in: in std_logic_vector(15 downto 0);
        RF_D2_ex_in ,RF_D1_ex_in  :in std_logic_vector(15 downto 0);
        zin_ex_in ,cin_ex_in: in std_logic;
        clk : in std_logic;
        reset : in std_logic;
	    pc_current_ex_in, pc_current2_ex_in : in std_logic_vector(15 downto 0);
		pc_next_ex_in : in std_logic_vector(15 downto 0);
		shift_ex_in : in std_logic_vector(15 downto 0);
        
        cout_ex_out,zout_ex_out: out std_logic;
	    notclear_ex_out: out std_logic;
        RF_D1_EX_out ,RF_D2_EX_out ,ALU1_C_EX_out, alu3_c_ex_out :out std_logic_vector(15 downto 0);
        m9_sl_ex_out :out std_logic;
		m_mem_sl_ex_out, M3_SL_EX_out : out std_logic_vector(1 downto 0);
        RF_WE_EX_out ,DM_RE_EX_out, DM_WE_EX_out: out std_logic;
        A3_ADD_EX_out :out std_logic_vector(2 downto 0);
		pc_current2_ex_out : out std_logic_vector(15 downto 0);
		pc_current_ex_out : out std_logic_vector(15 downto 0);
		shift_ex_out : out std_logic_vector(15 downto 0);
		ex_fwd_ex_out : out std_logic_vector(15 downto 0);
        inst_ex_out :out std_logic_vector(15 downto 0);
		  c_ex_out : out std_logic;
		  z_ex_out : out std_logic
        );
    end component EXE;
	 
component EXE_mem is 
    port (r157_in: in std_logic_vector(159 downto 0);
        clk,en157,rst: in std_logic;
        r157_out: out std_logic_vector(159 downto 0));
end component EXE_mem;

component mem  is
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
end component mem;


component mem_WB is 
    port (r117_in: in std_logic_vector(117 downto 0);
        clk,en117,rst: in std_logic;
        r117_out: out std_logic_vector(117 downto 0));
end component mem_WB;

component WB is
  port(
  M3_SL_wb_in :in std_logic_vector(1 downto 0);
  DM_OUT_wb_in, ALU1_C_wb_in:in std_logic_vector(15 downto 0);
  RF_WE_wb_in: in std_logic;
  A3_add_wb_in: in std_logic_vector(2 downto 0);
  inst_wb_in: in std_logic_vector(15 downto 0);
  clk :in std_logic;
  reset: in std_logic;
  shift_wb_in: in std_logic_vector(15 downto 0);
  pc_current2_wb_in: in std_logic_vector(15 downto 0);

  RF_WE_WB_out: out std_logic;
  RF_D3_WB_out: OUT std_logic_vector(15 downto 0);
  A3_ADD_WB_out: out std_logic_vector(2 downto 0)
  );
  end component WB;
  
  
component hd is
    port(
        inst_id, inst_rr, inst_ex: in std_logic_vector(15 downto 0);
        not_clear_ex, not_clear_mem: in std_logic;
        c_flag_ex, c_flag_mem, z_flag_ex, z_flag_mem: in std_logic;
        m4_sl_id, m5_sl_id : out std_logic_vector(1 downto 0);
        freeze_pr_pc : out std_logic
    );
end component hd;
	 
	 
signal IFF_out: std_logic_vector(63 downto 0);
signal ID_in: std_logic_vector(63 downto 0);		
signal ID_out: std_logic_vector(91 downto 0);	
signal rr_in : std_logic_vector(91 downto 0);
signal rr_out : std_logic_vector(182 downto 0);
signal EXE_in : std_logic_vector(182 downto 0);
signal EXE_out : std_logic_vector(159 downto 0);
signal mem_in : std_logic_vector(159 downto 0);
signal mem_out : std_logic_vector(117 downto 0);
signal WB_in : std_logic_vector(117 downto 0);
signal WB_out : std_logic_vector(19 downto 0);
signal pc_wren_temp, pc_write_id_out_temp, c_ex_out_temp, z_ex_out_temp, c_flag_mem_temp, z_flag_mem_temp: std_logic;
signal FREEZE_PR_PC_temp ,rf_we_wb_out_temp, notclear_ex_out_temp: std_logic;
signal pc_current_ex_out_temp, RF_D3_WB_out_temp, mem_fwd_mem_out_temp, ex_fwd_ex_out_temp, r92_out_temp: std_logic_vector(15 downto 0);
signal r183_out_temp, r157_out_temp: std_logic_vector(15 downto 0);
signal A3_ADD_WB_out_temp: std_logic_vector(2 downto 0);
signal m4_sl_id_temp, m5_sl_id_temp: std_logic_vector(1 downto 0);

begin 
pc_wren_temp <= pc_write_id_out_temp AND FREEZE_PR_PC_temp; 

  IFF1 : IFF
  port map(PC_WREN =>pc_wren_temp , PC_IN => pc_current_ex_out_temp, CLK => clk, reset => rst, --check for PC_WREN 
           
			  PC_CURRENT_IF_OUT => IFF_out(63 downto 48),
			  INST_IF_OUT => IFF_out(47 downto 32),
			  PC_NEXT_IF_OUT => IFF_out(31 downto 16),
			  PC_CURRENT2_IF_OUT => IFF_out(15 downto 0));
  
  IFF_ID1 : IFF_ID			  
  port map(r64_in => IFF_out, clk => clk, rst => rst, r64_out => ID_in, en64 => FREEZE_PR_PC_temp); -- check for en64			  
			  
  id1 : ID
  port map(clk => clk, rst => rst,notclear_id_in => notclear_ex_out_temp,
           inst_id_in => ID_in(47 downto 32), pc_current_id_in => ID_in(63 downto 48),
			  pc_next_id_in => ID_in(31 downto 16), pc_current2_id_in => ID_in(15 downto 0),
			  inst_id_out => ID_out(91 downto 76), pc_current_id_out => ID_out(75 downto 60),
			  pc_current2_id_out => ID_out(59 downto 44), pc_next_id_out => ID_out(43 downto 28),
			  a1_add_id_out => ID_out(27 downto 25), a2_add_id_out => ID_out(24 downto 22), a3_add_id_out => ID_out(21 downto 19),
			  rf_we_id_out => ID_out(18),dm_we_id_out => ID_out(17), dm_re_id_out => ID_out(16), m1_sl_id_out => ID_out(15),
			  ex_t1_e_id_out => ID_out(14), m2_sl_id_out => ID_out(13 downto 12), m3_sl_id_out => ID_out(11 downto 10),
			  m6_sl_id_out => ID_out(9), m8_sl_id_out => ID_out(8), m9_sl_id_out => ID_out(7), m10_sl_id_out => ID_out(6),
			  m7_sl_id_out => ID_out(5 downto 4), m_ex_sl_id_out => ID_out(3 downto 2), m_mem_sl_id_out => ID_out(1 downto 0), 
			  pc_write_id_out => pc_write_id_out_temp);
			  
  ID_rr1 : ID_rr
  port map(r92_in => ID_out, clk => clk, rst => rst,
           r92_out => rr_in, en92 => FREEZE_PR_PC_temp);
			  
  rr1 : rr
  port map(--inputs
           clk => clk, rst => rst, rf_we_wb_out => rf_we_wb_out_temp,
           a1_add_rr_in => rr_in(27 downto 25), a2_add_rr_in => rr_in(24 downto 22), a3_add_rr_in => rr_in(21 downto 19),
			  a3_add_wb_out =>A3_ADD_WB_out_temp, rf_d3_wb_out =>RF_D3_WB_out_temp, rf_we_rr_in => rr_in(18) , dm_we_rr_in => rr_in(17), dm_re_rr_in => rr_in(16), 
			  m1_sl_rr_in => rr_in(15), m6_sl_rr_in => rr_in(9), notclear_rr_in => notclear_ex_out_temp ,m2_sl_rr_in => rr_in(13 downto 12), 
			  m7_sl_rr_in => rr_in(5 downto 4), m4_sl_rr_in => m4_sl_id_temp, m3_sl_rr_in => rr_in(11 downto 10),
			  m5_sl_rr_in => m5_sl_id_temp,m_mem_sl_rr_in => rr_in(1 downto 0), m_ex_sl_rr_in => rr_in(3 downto 2),
			  inst_rr_in => rr_in(91 downto 76), pc_current_rr_in => rr_in(75 downto 60), pc_current2_rr_in => rr_in(59 downto 44), 
			  pc_next_rr_in => rr_in(43 downto 28), mem_fwd_rr_in => mem_fwd_mem_out_temp , ex_fwd_rr_in => ex_fwd_ex_out_temp,
			  m8_sl_rr_in => rr_in(8), m9_sl_rr_in => rr_in(7), m10_sl_rr_in => rr_in(6), ex_t1_e_rr_in => rr_in(14),
			  --outputs
			  pc_current_rr_out => rr_out(182 downto 167), pc_current2_rr_out => rr_out(166 downto 151), pc_next_rr_out => rr_out(150 downto 135),
			  inst_rr_out => rr_out(134 downto 119), rf_d1_rr_out => rr_out(118 downto 103), rf_d2_rr_out => rr_out(102 downto 87), 
			  d2_comp_rr_out => rr_out(86 downto 71), se6_rr_out => rr_out(70 downto 55), se9_rr_out => rr_out(54 downto 39), 
			  shift_rr_out => rr_out(38 downto 23), a3_add_rr_out => rr_out(22 downto 20), m1_sl_rr_out => rr_out(19), dm_we_rr_out => rr_out(18),
			  dm_re_rr_out => rr_out(17), rf_we_rr_out => rr_out(16), st_en_rr_out => rr_out(15), m6_sl_rr_out => rr_out(14), m8_sl_rr_out => rr_out(13), 
			  m9_sl_rr_out => rr_out(12), m10_sl_rr_out => rr_out(11), ex_t1_e_rr_out => rr_out(10), m2_sl_rr_out => rr_out(9 downto 8),
			  m7_sl_rr_out => rr_out(7 downto 6), m3_sl_rr_out => rr_out(5 downto 4), m_mem_sl_rr_out => rr_out(3 downto 2) ,
			  m_ex_sl_rr_out => rr_out(1 downto 0)
			 );
			
  rr_EXE1 : rr_EXE			
  port map(r183_in => rr_out, clk => clk, rst => rst, en183 => '1', r183_out => EXE_in);
  
  EXE1 : EXE
  port map( pc_current_ex_in => EXE_in(182 downto 167), pc_current2_ex_in => EXE_in(166 downto 151), pc_next_ex_in => EXE_in(150 downto 135),
            inst_ex_in => EXE_in(134 downto 119), RF_D1_ex_in => EXE_in(118 downto 103), RF_D2_ex_in => EXE_in(102 downto 87),
            D2_COMP_ex_in => EXE_in(86 downto 71),SE_9_ex_in => EXE_in(54 downto 39), SE_6_ex_in => EXE_in(70 downto 55),
            shift_ex_in => EXE_in(38 downto 23), A3_ADD_ex_in => EXE_in(22 downto 20), M1_SL_ex_in => EXE_in(19), DM_WE_ex_in => EXE_in(18),
		      DM_RE_ex_in => EXE_in(17), RF_WE_ex_in => EXE_in(16), m6_sl_ex_in =>EXE_in(14), m8_sl_ex_in => EXE_in(13),  m10_sl_ex_in => EXE_in(11),
				m9_sl_ex_in => EXE_in(12), ex_t1_e_ex_in => EXE_in(10), M2_SL_ex_in => EXE_in(9 downto 8), m7_sl_ex_in => EXE_in(7 downto 6),
            M3_SL_ex_in => EXE_in(5 downto 4), m_mem_sl_ex_in => EXE_in(3 downto 2), m_ex_sl_ex_in => EXE_in(1 downto 0),
            clk => clk, reset=> rst, zin_ex_in => EXE_out(6), cin_ex_in => EXE_out(7), 
				
            --outputs 
				pc_current_ex_out => EXE_out(157 downto 142), pc_current2_ex_out => EXE_out(141 downto 126), inst_ex_out => EXE_out(125 downto 110),
				RF_D1_EX_out => EXE_out(109 downto 94),RF_D2_EX_out => EXE_out(93 downto 78), ALU1_C_EX_out => EXE_out(77 downto 62),
				alu3_c_ex_out => EXE_out(61 downto 46), shift_ex_out => EXE_out(45 downto 30), ex_fwd_ex_out => EXE_out(29 downto 14),
	         A3_ADD_EX_out => EXE_out(13 downto 11), m_mem_sl_ex_out => EXE_out(10 downto 9), cout_ex_out => EXE_out(8), 			
			   zout_ex_out => EXE_out(7), notclear_ex_out => EXE_out(6), M3_SL_EX_out => EXE_out(5 downto 4), m9_sl_ex_out => EXE_out(3),
				RF_WE_EX_out => EXE_out(2), DM_RE_EX_out => EXE_out(1), DM_WE_EX_out => EXE_out(0), c_ex_out => EXE_out(158), z_ex_out => EXE_out(159)
		);
		ex_fwd_ex_out_temp<= EXE_out(29 downto 14);
		
	pc_current_ex_out_temp<= EXE_out(157 downto 142);
	EXE_mem1 : EXE_mem
   port map(r157_in => EXE_out, clk => clk, rst => rst,
	         r157_out => mem_in, en157 => '1');
				
	mem1 : mem
	port map( clk => clk, rst => rst, pc_current2_mem_in => mem_in(141 downto 126), inst_mem_in => mem_in(125 downto 110),
	          rf_d1_mem_in => mem_in(109 downto 94), rf_d2_mem_in => mem_in(93 downto 78), alu1_c_mem_in => mem_in(77 downto 62),
				 alu3_c_mem_in => mem_in(61 downto 46), shift_mem_in => mem_in(45 downto 30), a3_add_mem_in => mem_in(13 downto 11),
				 m_mem_sl_mem_in => mem_in(10 downto 9), m3_sl_mem_in => mem_in(5 downto 4), m9_sl_mem_in => mem_in(3), rf_we_mem_in => mem_in(2),
			    dm_we_mem_in => mem_in(0), dm_re_mem_in => mem_in(1),
			    -- outputs	 
				 pc_current2_mem_out => mem_out(117 downto 102), inst_mem_out => mem_out(101 downto 86), rf_d1_mem_out => mem_out(85 downto 70),
             alu1_c_mem_out => mem_out(69 downto 54), shift_mem_out => mem_out(53 downto 38), mem_fwd_mem_out => mem_out(37 downto 22),
				 dm_out_mem_out => mem_out(21 downto 6), a3_add_mem_out => mem_out(5 downto 3), rf_we_mem_out => mem_out(2),
				 m3_sl_mem_out => mem_out(1 downto 0)
				);
			mem_fwd_mem_out_temp<=  mem_out(37 downto 22);
			notclear_ex_out_temp<= EXE_out(6);
				
	mem_WB1 : mem_WB
	port map( r117_in => mem_out, clk => clk, rst => rst, en117 => '1', r117_out => WB_in);
	
	WB1 : WB
	port map( pc_current2_wb_in => WB_in(117 downto 102), inst_wb_in => WB_in(101 downto 86), ALU1_C_wb_in => WB_in(69 downto 54),
             shift_wb_in => WB_in(53 downto 38), DM_OUT_wb_in => WB_in(21 downto 6), A3_add_wb_in => WB_in(5 downto 3), 
	          RF_WE_wb_in => WB_in(2), M3_SL_wb_in => WB_in(1 downto 0), clk => clk, reset => rst,
	          --outputs	
		       RF_D3_WB_out => WB_out(19 downto 4), A3_ADD_WB_out => WB_out(3 downto 1), RF_WE_WB_out => WB_out(0)      		 
	
	); 
	RF_D3_WB_out_temp<= WB_out(19 downto 4);
	A3_ADD_WB_out_temp<= WB_out(3 downto 1);
	rf_we_wb_out_temp <=  WB_out(0);
	
	hd1 : hd
	port map( inst_id =>r92_out_temp, inst_rr => r183_out_temp, inst_ex => r157_out_temp, not_clear_ex => notclear_ex_out_temp,
	          not_clear_mem => notclear_ex_out_temp,
	          c_flag_ex => c_ex_out_temp, z_flag_ex => z_ex_out_temp,  c_flag_mem =>c_flag_mem_temp, z_flag_mem => z_flag_mem_temp,
	          m4_sl_id =>m4_sl_id_temp, m5_sl_id =>  m5_sl_id_temp,  freeze_pr_pc => FREEZE_PR_PC_temp
           );
			  
	r92_out_temp <= rr_in(91 downto 76);
	r183_out_temp <= EXE_in(134 downto 119);
	r157_out_temp <=  mem_in(125 downto 110);
	c_ex_out_temp <= EXE_out(158);
	z_ex_out_temp <=  EXE_out(159);
	c_flag_mem_temp <=  EXE_out(7);
	z_flag_mem_temp <= EXE_out(6);
end architecture behave;
	




       
       

	   

 
		    
		

	
	

  	
  	
    


