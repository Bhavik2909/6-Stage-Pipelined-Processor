library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity WB is
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
  end entity WB;

  architecture cake of WB is

  component MUX_2x1_16b is
    port (
    d : out std_logic_vector(15 downto 0);
    a : in std_logic;
    r1, r2: in std_logic_vector(15 downto 0)
    );
   end component MUX_2x1_16b;

  begin
     M3:MUX_4X1_16b
      port map(r1=>DM_OUT_wb_in, r2=>ALU1_C_wb_in, r3 => shift_wb_in, r4 => pc_current2_wb_in, d=>RF_D3_WB_out, a=>M3_SL_wb_in);

      A3_ADD_WB_out <= A3_add_wb_in;
      RF_WE_WB_out <= RF_WE_wb_in;

  end cake;