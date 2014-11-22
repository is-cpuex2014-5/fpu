library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fmul_stage2 is
  port (
    HH            : in  std_logic_vector (25 downto 0);
    HL            : in  std_logic_vector (23 downto 0);
    LH            : in  std_logic_vector (23 downto 0);
    exp           : in  std_logic_vector (7 downto 0);
    underflow_bit : in  std_logic;
    exp0          : out std_logic_vector (7 downto 0);
    exp1          : out std_logic_vector (7 downto 0);
    mantissa      : out std_logic_vector (25 downto 0);
    CLK           : in  std_logic);
end entity fmul_stage2;

architecture rtl of fmul_stage2 is
  signal i_HH : std_logic_vector (25 downto 0) := (others => '0');
  signal i_HL : std_logic_vector (23 downto 0) := (others => '0');
  signal i_LH : std_logic_vector (23 downto 0) := (others => '0');
  signal i_exp : std_logic_vector (7 downto 0) := (others => '0');
  signal i_underflow_bit : std_logic := '0';
begin  -- architecture rtl

  mantissa <= "00000000000000000000000000" + i_HH + i_HL (23 downto 11) + i_LH (23 downto 11) + 2; 

  with i_underflow_bit select
    exp0 <=
    "00000000" when '0',
    i_exp      when '1',
    i_exp      when others;

  with i_underflow_bit select
    exp1 <=
    "00000001" when '0',
    i_exp + 1  when '1',
    i_exp + 1  when others;

  -- purpose: set i_HH, i_HL, i_LH, and i_exp0
  -- type   : combinational
  -- inputs : CLK
  -- outputs: i_HH, i_HL, i_LH, and i_exp0
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK)  then
      i_HH <= HH;
      i_HL <= HL;
      i_LH <= LH;
      i_exp <= exp;
      i_underflow_bit <= underflow_bit;
    end if;
  end process set_loop;

end architecture rtl;
