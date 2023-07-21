library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity id is
    port(
        clk,rst: in std_logic;
        notclear_id_in: in std_logic;
        inst_id_in, pc_current_id_in, pc_next_id_in, pc_current2_id_in: in std_logic_vector(15 downto 0);
        inst_id_out, pc_current_id_out, pc_current2_id_out, pc_next_id_out: out std_logic_vector(15 downto 0);
        a1_add_id_out,a2_add_id_out,a3_add_id_out: out std_logic_vector(2 downto 0);
        rf_we_id_out,dm_we_id_out,dm_re_id_out,m1_sl_id_out, ex_t1_e_id_out, pc_write_id_out: out std_logic; -- pc_write_id_out doesn't go into pipeline
        m2_sl_id_out,m3_sl_id_out: out std_logic_vector(1 downto 0);
        m6_sl_id_out, m8_sl_id_out, m9_sl_id_out, m10_sl_id_out: out std_logic;
        m7_sl_id_out, m_ex_sl_id_out, m_mem_sl_id_out: out std_logic_vector(1 downto 0)
    );
end entity id;

architecture behave of id is
component pe1 is 
  port( I : in std_logic_vector(7 downto 0);
        C : in std_logic_vector(2 downto 0);
		Y : out std_logic_vector(7 downto 0);
		A : out std_logic_vector(2 downto 0)
	);
end component pe1;

component reg1 is 
    port (r1_in: in std_logic;
        clk,en1,rst: in std_logic;
        r1_out: out std_logic);
end component reg1;

component reg3 is 
    port (r3_in: in std_logic_vector(2 downto 0);
        clk,en3,rst: in std_logic;
        r3_out: out std_logic_vector(2 downto 0));
end component reg3;

component reg8 is 
    port (r8_in: in std_logic_vector(7 downto 0);
        clk,en8,rst: in std_logic;
        r8_out: out std_logic_vector(7 downto 0));
end component reg8;

signal r8_in_temp, r8_out_temp: std_logic_vector(7 downto 0);
signal en8_temp, en3_temp, en1_temp: std_logic;
signal r3_in_temp, r3_out_temp, A_temp, C_temp: std_logic_vector(2 downto 0);
signal r1_in_temp, r1_out_temp: std_logic;
signal I_temp, Y_temp: std_logic_vector(7 downto 0);

begin
    pc_current_id_out <= pc_current_id_in;
    pc_next_id_out <= pc_next_id_in;
    pc_current2_id_out <= pc_current2_id_in;
    inst_id_out<=inst_id_in;
    process(inst_id_in,clk)
    begin
        case (inst_id_in(15 downto 12)) is
            when ("0001") =>    --ADD
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= inst_id_in(5 downto 3);
                rf_we_id_out <= '1' and notclear_id_in;    --Have to edit this according to the carry and zero flag
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                if (inst_id_in(2) = '1') then
                    m2_sl_id_out <= "11";
                else
                    m2_sl_id_out <= "00";
                end if;
                m3_sl_id_out <= "01";
                m6_sl_id_out <= '0';
                m7_sl_id_out <= "00";
                m_ex_sl_id_out <= "00";
                m_mem_sl_id_out <= "01";
                pc_write_id_out <= '1';
            when ("0010") =>    --NAND  
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= inst_id_in(5 downto 3);
                rf_we_id_out <= '1' and notclear_id_in;    --Have to edit this according to the carry and zero flag
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                if (inst_id_in(2) = '1') then
                    m2_sl_id_out <= "11";
                else
                    m2_sl_id_out <= "00";
                end if;
                m3_sl_id_out <= "01";
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "00";
                pc_write_id_out <= '1';
            when ("0000") =>    --ADI
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= "000"; --Don't Care Condition
                a3_add_id_out <= inst_id_in(8 downto 6);
                rf_we_id_out <= '1' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                m2_sl_id_out <= "01";
                m3_sl_id_out <= "01";
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "00";
                pc_write_id_out <= '1';
            when ("0011") =>    --LLI
                a1_add_id_out <= "000"; --Don't Care Condition
                a2_add_id_out <= "000"; --Don't Care Condition
                a3_add_id_out <= inst_id_in(11 downto 9);
                rf_we_id_out <= '1' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';    --Don't Care Condition
                m2_sl_id_out <= "10";   --Why is this 10 please think over it?
                m3_sl_id_out <= "10";
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "00";
                pc_write_id_out <= '1';
            when ("0100") =>    --LW
                a1_add_id_out <= "000"; --Don't Care Condition
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= inst_id_in(11 downto 9);
                rf_we_id_out <= '1' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '1' and notclear_id_in;
                m1_sl_id_out <= '1';    --Here mux 9 will be 0
                m2_sl_id_out <= "01";
                m3_sl_id_out <= "00";
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "00";
                pc_write_id_out <= '1';
            when ("0101") =>    --SW
                a1_add_id_out <= inst_id_in(8 downto 6);
                a2_add_id_out <= inst_id_in(11 downto 9);
                a3_add_id_out <= "000";
                rf_we_id_out <= '0' and notclear_id_in;
                dm_we_id_out <= '1' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';    --Here mux 9 will be 0
                m2_sl_id_out <= "01";
                m3_sl_id_out <= "00";   --Don't Care Condition
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "00";
                pc_write_id_out <= '1';
            when ("1000") =>  --BEQ
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= "000"; --Don't Care Condition
                rf_we_id_out <= '0' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                m2_sl_id_out <= "00";
                m3_sl_id_out <= "00";   --Don't Care Condition
                m6_sl_id_out <= '1';    
                m7_sl_id_out <= "00";    --Need to modify this condition in the execution stage
                pc_write_id_out <= '1';
            when ("1001") =>    --BLT
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= "000"; --Don't Care Condition
                rf_we_id_out <= '0' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                m2_sl_id_out <= "00";
                m3_sl_id_out <= "00";   --Don't Care Condition
                m6_sl_id_out <= '1';   
                m7_sl_id_out <= "00";     --Need to modify this condition in the execution stage
                pc_write_id_out <= '1';
            when ("1011") =>    --BLE
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= "000"; --Don't Care Condition
                rf_we_id_out <= '0' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                m2_sl_id_out <= "00";
                m3_sl_id_out <= "00";   --Don't Care Condition
                m6_sl_id_out <= '1';    
                m7_sl_id_out <= "00";    --Need to modify this condition in the execution stage
                pc_write_id_out <= '1';
            when ("1100") =>    --JAL
                a1_add_id_out <= "000"; --Don't Care Condition
                a2_add_id_out <= "000"; --Don't Care Condition
                a3_add_id_out <= inst_id_in(11 downto 9);
                rf_we_id_out <= '1' and notclear_id_in;   
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';    --Don't care condition
                m2_sl_id_out <= "00";   --Don't care condition
                m3_sl_id_out <= "11";
                m6_sl_id_out <= '0';
                m7_sl_id_out <= "01";
                pc_write_id_out <= '1';
            when ("1101") =>    --JLR
                a1_add_id_out <= "000"; --Don't care condition
                a2_add_id_out <= inst_id_in(8 downto 6);
                a3_add_id_out <= inst_id_in(11 downto 9);
                rf_we_id_out <= '1' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';    --Don't Care Condition
                m2_sl_id_out <= "00";   --Don't Care Condition
                m3_sl_id_out <= "11";
                m6_sl_id_out <= '0';    --Don't Care Condition
                m7_sl_id_out <= "10";
                pc_write_id_out <= '1';
            when ("1111") =>    --JRI
                a1_add_id_out <= inst_id_in(11 downto 9);
                a2_add_id_out <= "000"; --Don't care condition
                a3_add_id_out <= "000"; --Don't care condition
                rf_we_id_out <= '0' and notclear_id_in;
                dm_we_id_out <= '0' and notclear_id_in;
                dm_re_id_out <= '0' and notclear_id_in;
                m1_sl_id_out <= '0';
                m2_sl_id_out <= "10";
                m3_sl_id_out <= "00";   --Don't care condition
                m6_sl_id_out <= '0';    --Don't care condition
                m7_sl_id_out <= "11";
                m8_sl_id_out <= '0';
                m9_sl_id_out <= '0';
                pc_write_id_out <= '1';
            when ("0110") =>    --LM
                if(r3_out_temp = "000") then
                    pc_write_id_out <= '0';
                    I_temp <= inst_id_in(7 downto 0);
					C_temp <= r3_out_temp;
                    en8_temp <= '1';
                    r8_in_temp <= Y_temp;
                    en3_temp <= '1';
                    r3_in_temp <= "001";
                    a3_add_id_out <= A_temp;
                    a2_add_id_out <= "000"; --Don't care condition
                    a1_add_id_out <= inst_id_in(11 downto 9);
                    if (inst_id_in(0) = '1') then
                        rf_we_id_out <= '1' and notclear_id_in;    --Need to correct this according to bits
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                        rf_we_id_out <= '0' and notclear_id_in;
                        en1_temp <= '0';
                    end if;
                    dm_we_id_out <= '0' and notclear_id_in;
                    dm_re_id_out <= '1' and notclear_id_in;
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Review this one
                    m8_sl_id_out <= '0';
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '1';
                    ex_t1_e_id_out <= '1';
                elsif (r3_out_temp = "111") then --PC write ON
                    I_temp <= r8_out_temp;
					C_temp <= r3_out_temp;
                    en8_temp <= '0';
                    r8_in_temp <= Y_temp;
                    en3_temp <= '1';
                    r3_in_temp <= "000";
                    a3_add_id_out <= A_temp;
                    a2_add_id_out <= "000"; --Don't care condition
                    a1_add_id_out <= inst_id_in(11 downto 9);  --Don't care condition
                    if (inst_id_in(7) = '1') then
                        rf_we_id_out <= '1' and notclear_id_in;
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                    rf_we_id_out <= '0';
                    en1_temp <= '0';
                    end if;
                    dm_we_id_out <= '0' and notclear_id_in;
                    dm_re_id_out <= '1' and notclear_id_in;
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Review this one
                    m8_sl_id_out <= inst_id_in(7) and r1_out_temp;
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '0';
                    ex_t1_e_id_out <= '1';
                    pc_write_id_out <= '1';  
                else
                    pc_write_id_out <= '0';
                    I_temp <= r8_out_temp;
					C_temp <= r3_out_temp;
                    en8_temp <= '1';
                    r8_in_temp <= Y_temp;
                    en3_temp <= '1';
                    r3_in_temp <= r3_out_temp + "001";
                    a3_add_id_out <= A_temp;
                    a2_add_id_out <= "000"; --Don't care condition
                    a1_add_id_out <= inst_id_in(11 downto 9);  --Don't care condition
                    if (inst_id_in(conv_integer(r3_out_temp)) = '1') then
                        rf_we_id_out <= '1' and notclear_id_in;
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                        rf_we_id_out <= '0';
                        en1_temp <= '0';
                    end if;
                    dm_we_id_out <= '0' and notclear_id_in;
                    dm_re_id_out <= '1' and notclear_id_in;
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Review this one
                    m8_sl_id_out <= inst_id_in(conv_integer(r3_out_temp)) and r1_out_temp;
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '0';
                    ex_t1_e_id_out <= '1';
                end if; 
            when ("0111") =>    --SM
                if (r3_out_temp = "000") then
                    pc_write_id_out <= '0';
                    I_temp <= inst_id_in(7 downto 0);
					C_temp <= r3_out_temp;
                    en8_temp  <= '1';
                    r8_in_temp <= Y_temp ;
                    en3_temp <= '1';
                    r3_in_temp <= "001";
                    a2_add_id_out <= A_temp;
                    a1_add_id_out <= inst_id_in(11 downto 9);
                    a3_add_id_out <= "000"; --Don't Care Condition
                    rf_we_id_out <= '0' and notclear_id_in;
                    if (inst_id_in(0) = '1') then
                        dm_we_id_out <= '1' and notclear_id_in;
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                        dm_we_id_out <= '0' and notclear_id_in;
                        en1_temp <= '0';
                    end if;
                    dm_re_id_out <= '0' and notclear_id_in;
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Don't Care Condition
                    m8_sl_id_out <= '0';
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '1';
                    ex_t1_e_id_out <= '1';
                elsif (r3_out_temp = "111") then
                    I_temp <= r8_out_temp;
					C_temp <= r3_out_temp;
                    en8_temp <= '0';
                    r8_in_temp <= Y_temp;
                    en3_temp <= '1';
                    r3_in_temp <= "000";
                    a2_add_id_out <= A_temp;
                    a1_add_id_out <= inst_id_in(11 downto 9);  --Don't Care Condition
                    a3_add_id_out <= "000"; --Don't Care Condition
                    rf_we_id_out <= '0';
                    if (inst_id_in(7) = '1') then
                        dm_we_id_out <= '1' and notclear_id_in;
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                        dm_we_id_out <= '0';
                        en1_temp <= '0';
                    end if;
                    dm_re_id_out <= '0';
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Don't Care Condition
                    m8_sl_id_out <= inst_id_in(7) and r1_out_temp;
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '0';
                    ex_t1_e_id_out <= '1';
                    pc_write_id_out <= '1';
                else
                    pc_write_id_out <= '0';
                    I_temp <= r8_out_temp;
					C_temp <= r3_out_temp;
                    en8_temp <= '1';
                    r8_in_temp <= Y_temp;
                    en3_temp <= '1';
                    r3_in_temp <= r3_out_temp + "001";
                    a2_add_id_out <= A_temp;
                    a1_add_id_out <= inst_id_in(11 downto 9);  --Don't Care Condition
                    a3_add_id_out <= "000"; --Don't Care Condition
                    rf_we_id_out <= '0';
                    if (inst_id_in(conv_integer(r3_out_temp)) = '1') then
                        dm_we_id_out <= '1' and notclear_id_in;
                        en1_temp <= '1';
                        r1_in_temp <= '1';
                    else
                        dm_we_id_out <= '0';
                        en1_temp <= '0';
                    end if;
                    dm_re_id_out <= '0';
                    m1_sl_id_out <= '0';    --Don't care condition
                    m2_sl_id_out <= "00";   --Don't care condition
                    m3_sl_id_out <= "00";
                    m6_sl_id_out <= '0';   --Don't care condition
                    m7_sl_id_out <= "00";
                    m_ex_sl_id_out <= "00"; --Don't care condition
                    m_mem_sl_id_out <= "00";    --Don't Care Condition
                    m8_sl_id_out <= inst_id_in(conv_integer(r3_out_temp)) and r1_out_temp;
                    m9_sl_id_out <= '1';
                    m10_sl_id_out <= '0';
                    ex_t1_e_id_out <= '1';
                end if;
				when others =>
				a1_add_id_out <= "000";
                rf_we_id_out <= '0';
                dm_we_id_out <= '0';
                dm_re_id_out <= '0';
                pc_write_id_out <= '1';

        end case;
    end process;
    LMSM_add: reg8
            port map(r8_in => r8_in_temp, clk => clk, en8 => en8_temp,rst => rst, r8_out => r8_out_temp);
    LMSM_count: reg3
            port map(r3_in => r3_in_temp, clk => clk, en3 => en3_temp,rst => rst, r3_out => r3_out_temp);
    LMSM_add_check: reg1
            port map(r1_in => r1_in_temp, clk => clk, en1 => en1_temp,rst => rst, r1_out => r1_out_temp);
    Priority_Encoder: pe1
        port map(I => I_temp, C => C_temp, Y => Y_temp, A => A_temp);
end architecture behave;