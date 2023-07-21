library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hd is
    port(
        inst_id, inst_rr, inst_ex: in std_logic_vector(15 downto 0);
        not_clear_ex, not_clear_mem: in std_logic;
        c_flag_ex, c_flag_mem, z_flag_ex, z_flag_mem: in std_logic;
        m4_sl_id, m5_sl_id : out std_logic_vector(1 downto 0);
        freeze_pr_pc : out std_logic
    );
end entity hd;

architecture behave of hd is
begin
    process(inst_id,inst_rr,inst_ex)
    begin
        case inst_id(15 downto 12) is
            when ("0001") =>    --ADD
                if (inst_rr(15 downto 12) = "0001" or inst_rr(15 downto 12) = "0010") then  --ADD OR NAND
                    if (inst_id(11 downto 9) = inst_rr(5 downto 3)) then                    --IN EX
                        if (inst_rr(1 downto 0) = "10") then
                            if (c_flag_ex = '1') then
                                m4_sl_id <= "01";
                            else
                                m4_sl_id <= "10";
                            end if;
                        elsif (inst_rr(1 downto 0) = "01") then
                            if (z_flag_ex = '1') then
                                m4_sl_id <= "01";
                            else
                                m4_sl_id <= "10";
                            end if;
                        else
                            m4_sl_id <= "01";
                        end if;
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_rr(5 downto 3)) then
                        if (inst_rr(1 downto 0) = "10") then
                            if (c_flag_ex = '1') then
                                m5_sl_id <= "01";
                            else
                                m5_sl_id <= "10";
                            end if;
                        elsif (inst_rr(1 downto 0) = "01") then
                            if (z_flag_ex = '1') then
                                m5_sl_id <= "01";
                            else
                                m5_sl_id <= "10";
                            end if;
                        else
                            m5_sl_id <= "01";
                        end if;
                    else
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_ex(15 downto 12) = "0001" or inst_ex(15 downto 12) = "0010") then   --ADD OR NAND
                    if (inst_id(11 downto 9) = inst_ex(5 downto 3)) then                        --IN MEM
                        if (inst_ex(1 downto 0) = "10") then
                            if (c_flag_mem = '1') then
                                m4_sl_id <= "00";
                            else
                                m4_sl_id <= "10";
                            end if;
                        elsif (inst_ex(1 downto 0) = "01") then
                            if (z_flag_mem = '1') then
                                m4_sl_id <= "00";
                            else
                                m4_sl_id <= "10";
                            end if;
                        else
                            m4_sl_id <= "00";
                        end if;
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_ex(5 downto 3)) then
                        if (inst_ex(1 downto 0) = "10") then
                            if (c_flag_mem = '1') then
                                m5_sl_id <= "00";
                            else
                                m5_sl_id <= "10";
                            end if;
                        elsif (inst_ex(1 downto 0) = "01") then
                            if (z_flag_mem = '1') then
                                m5_sl_id <= "00";
                            else
                                m5_sl_id <= "10";
                            end if;
                        else
                            m5_sl_id <= "00";
                        end if;
                    else
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_rr(15 downto 12) = "0000" and not_clear_ex = '1') then --ADI IN EX
                    if (inst_id(11 downto 9) = inst_rr(8 downto 6)) then
                        m4_sl_id <= "01";
                        m5_sl_id <= "10";
                    else
                        m4_sl_id <= "10";
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_ex(15 downto 12) = "0000" and not_clear_mem = '1') then --ADI IN MEM
                    if (inst_id(11 downto 9) = inst_ex(8 downto 6)) then
                        m4_sl_id <= "01";
                        m5_sl_id <= "10";
                    else
                        m4_sl_id <= "10";
                        m5_sl_id <= "10";
                    end if;
                
                elsif (inst_rr(15 downto 12) = "0011") then --LLI in ex
                    if(inst_id(8 downto 6) = inst_rr(11 downto 9) or inst_id(11 downto 9) = inst_rr(11 downto 9)) then
                        freeze_pr_pc <= '1';
                    end if;
                elsif (inst_ex(15 downto 12) = "0011") then --LLI in mem
                    if(inst_id(11 downto 9) = inst_ex(11 downto 9)) then
                        m4_sl_id <= "00";
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_ex(11 downto 9)) then
                        m5_sl_id <= "00";
                    else
                        m5_sl_id <= "10";
                    end if;
                    elsif (inst_rr(15 downto 12) = "0100") then --LW in ex
                    if(inst_id(8 downto 6) = inst_rr(11 downto 9) or inst_id(11 downto 9) = inst_rr(11 downto 9)) then
                        freeze_pr_pc <= '1';
                    end if;
                elsif (inst_ex(15 downto 12) = "0100") then --LW in mem
                    if(inst_id(11 downto 9) = inst_ex(11 downto 9)) then
                        m4_sl_id <= "00";
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_ex(11 downto 9)) then
                        m5_sl_id <= "00";
                    else
                        m5_sl_id <= "10";
                    end if;

                else
                    m4_sl_id <= "10";
                    m5_sl_id <= "10";
                end if;

            when ("0010") =>    --NAND
                if (inst_rr(15 downto 12) = "0001" or inst_rr(15 downto 12) = "0010") then  --ADD OR NAND
                    if (inst_id(11 downto 9) = inst_rr(5 downto 3)) then                    --IN EX
                        if (inst_rr(1 downto 0) = "10") then
                            if (c_flag_ex = '1') then
                                m4_sl_id <= "01";
                            else
                                m4_sl_id <= "10";
                            end if;
                        elsif (inst_rr(1 downto 0) = "01") then
                            if (z_flag_ex = '1') then
                                m4_sl_id <= "01";
                            else
                                m4_sl_id <= "10";
                            end if;
                        else
                            m4_sl_id <= "01";
                        end if;
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_rr(5 downto 3)) then
                        if (inst_rr(1 downto 0) = "10") then
                            if (c_flag_ex = '1') then
                                m5_sl_id <= "01";
                            else
                                m5_sl_id <= "10";
                            end if;
                        elsif (inst_rr(1 downto 0) = "01") then
                            if (z_flag_ex = '1') then
                                m5_sl_id <= "01";
                            else
                                m5_sl_id <= "10";
                            end if;
                        else
                            m5_sl_id <= "01";
                        end if;
                    else
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_ex(15 downto 12) = "0001" or inst_ex(15 downto 12) = "0010") then   --ADD OR NAND
                    if (inst_id(11 downto 9) = inst_ex(5 downto 3)) then                        --IN MEM
                        if (inst_ex(1 downto 0) = "10") then
                            if (c_flag_mem = '1') then
                                m4_sl_id <= "00";
                            else
                                m4_sl_id <= "10";
                            end if;
                        elsif (inst_ex(1 downto 0) = "01") then
                            if (z_flag_mem = '1') then
                                m4_sl_id <= "00";
                            else
                                m4_sl_id <= "10";
                            end if;
                        else
                            m4_sl_id <= "00";
                        end if;
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_ex(5 downto 3)) then
                        if (inst_ex(1 downto 0) = "10") then
                            if(c_flag_mem = '1') then
                                m5_sl_id <= "00";
                            else
                                m5_sl_id <= "10";
                            end if;
                        elsif (inst_ex(1 downto 0) = "01") then
                            if (z_flag_mem = '1') then
                                m5_sl_id <= "00";
                            else
                                m5_sl_id <= "10";
                            end if;
                        else
                            m5_sl_id <= "00";
                        end if;     
                    else
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_rr(15 downto 12) = "0000" and not_clear_ex = '1') then --ADI IN EX
                    if (inst_id(11 downto 9) = inst_rr(8 downto 6)) then
                        m4_sl_id <= "01";
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_rr(8 downto 6)) then
                        m5_sl_id <= "01";
                    else
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_ex(15 downto 12) = "0000" and not_clear_mem = '1') then --ADI IN MEM
                    if (inst_id(11 downto 9) = inst_ex(8 downto 6)) then
                        m4_sl_id <= "01";
                    else
                        m4_sl_id <= "10";
                    end if;
                    if (inst_id(8 downto 6) = inst_ex(8 downto 6)) then
                        m5_sl_id <= "01";
                    else
                        m5_sl_id <= "10";
                    end if;
                else
                    m4_sl_id <= "10";
                    m5_sl_id <= "10";
                end if;
                
            when ("0000") =>    --ADI  --EDIT THIS CODE ACCORIDING TO ADI IN STALL STAGE       
                if (inst_rr(15 downto 12) = "0001" or inst_rr(15 downto 12) = "0010") then  --ADD AND NAND
                    if (not_clear_ex = '1') then
                        if (inst_id(11 downto 9) = inst_rr(5 downto 3)) then                    --IN EX
                            if (inst_rr(1 downto 0) = "10") then
                                if (c_flag_ex = '1') then
                                    m4_sl_id <= "01";
                                    m5_sl_id <= "10";
                                else
                                    m4_sl_id <= "10";
                                    m5_sl_id <= "10";
                                end if;
                            elsif (inst_rr(1 downto 0) = "01") then
                                if (z_flag_ex = '1') then
                                    m4_sl_id <= "01";
                                    m5_sl_id <= "10";
                                else
                                    m4_sl_id <= "10";
                                    m5_sl_id <= "10";
                                end if;
                            else
                                m4_sl_id <= "01";
                                m5_sl_id <= "10";
                            end if;       
                        else
                            m4_sl_id <= "10";
                            m5_sl_id <= "10";
                        end if;
                    end if;
                elsif (inst_ex(15 downto 12) = "0001" or inst_ex(15 downto 12) = "0010") then   --ADD AND NAND
                    if (not_clear_mem = '1') then
                        if (inst_id(11 downto 9) = inst_ex(5 downto 3)) then                       --IN MEM
                            if (inst_ex(1 downto 0) = "10") then
                                if (c_flag_mem = '1') then
                                    m4_sl_id <= "00";
                                    m5_sl_id <= "10";
                                else
                                    m4_sl_id <= "10";
                                    m5_sl_id <= "10";
                                end if;
                            elsif (inst_ex(1 downto 0) = "01") then
                                if (z_flag_mem = '1') then
                                    m4_sl_id <= "00";
                                    m5_sl_id <= "10";
                                else
                                    m4_sl_id <= "10";
                                    m5_sl_id <= "10";
                                end if;
                            else
                                m4_sl_id <= "00";
                                m5_sl_id <= "10";
                            end if;
                        else
                            m4_sl_id <= "10";
                            m5_sl_id <= "10";
                        end if;
                    end if;
                elsif (inst_rr(15 downto 12) = "0000" and not_clear_ex = '1') then                 --ADI IN 
                    if (inst_id(11 downto 9) = inst_rr(8 downto 6)) then    --EX
                        m4_sl_id <= "01";
                        m5_sl_id <= "10";
                    else
                        m4_sl_id <= "10";
                        m5_sl_id <= "10";
                    end if;
                elsif (inst_ex(15 downto 12) = "0000" and not_clear_mem = '1') then                 --ADI IN
                    if (inst_id(11 downto 9) = inst_ex(8 downto 6)) then    --MEM
                        m4_sl_id <= "01";
                        m5_sl_id <= "10";
                    else
                        m4_sl_id <= "10";
                        m5_sl_id <= "10";
                    end if;
                else
                    m4_sl_id <= "10";
                    m5_sl_id <= "10";
                end if;
            when ("0101") =>
                if (inst_rr(15 downto 12) = "0001" or inst_rr(15 downto 12) = "0010") then  --ADD OR NAND
                        if (inst_id(11 downto 9) = inst_rr(5 downto 3)) then                    --IN EX
                            if (inst_rr(1 downto 0) = "10") then
                                if (c_flag_ex = '1') then
                                    m4_sl_id <= "01";
                                else
                                    m4_sl_id <= "10";
                                end if;
                            elsif (inst_rr(1 downto 0) = "01") then
                                if (z_flag_ex = '1') then
                                    m4_sl_id <= "01";
                                else
                                    m4_sl_id <= "10";
                                end if;
                            else
                                m4_sl_id <= "01";
                            end if;
                        else
                            m4_sl_id <= "10";
                        end if;
                elsif (inst_ex(15 downto 12) = "0001" or inst_ex(15 downto 12) = "0010") then   --ADD OR NAND
                if (inst_id(11 downto 9) = inst_ex(5 downto 3)) then                        --IN MEM
                    if (inst_ex(1 downto 0) = "10") then
                        if (c_flag_mem = '1') then
                            m4_sl_id <= "00";
                        else
                            m4_sl_id <= "10";
                        end if;
                    elsif (inst_ex(1 downto 0) = "01") then
                        if (z_flag_mem = '1') then
                            m4_sl_id <= "00";
                        else
                            m4_sl_id <= "10";
                        end if;
                    else
                        m4_sl_id <= "00";
                    end if;
                else
                    m4_sl_id <= "10";
                end if;
                elsif (inst_rr(15 downto 12) = "0000" and not_clear_ex = '1') then --ADI IN EX
                if (inst_id(11 downto 9) = inst_rr(8 downto 6)) then
                    m4_sl_id <= "01";
                    m5_sl_id <= "10";
                else
                    m4_sl_id <= "10";
                    m5_sl_id <= "10";
                end if;
            elsif (inst_ex(15 downto 12) = "0000" and not_clear_mem = '1') then --ADI IN MEM
                if (inst_id(11 downto 9) = inst_ex(8 downto 6)) then
                    m4_sl_id <= "01";
                    m5_sl_id <= "10";
                else
                    m4_sl_id <= "10";
                    m5_sl_id <= "10";
                end if;
					else
						 m4_sl_id <= "10";
                    m5_sl_id <= "10";
				end if;
         when others =>
			 m4_sl_id <= "10";
          m5_sl_id <= "10";
           			

        end case;
    end process;
end architecture behave;