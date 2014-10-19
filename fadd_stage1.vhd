library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity fadd_stage1 is
  
  port (
    A          : in  std_logic_vector (31 downto 0);
    B          : in  std_logic_vector (31 downto 0);
    CLK        : in  std_logic;
    m_g        : out std_logic_vector (26 downto 0);
    m_l        : out std_logic_vector (26 downto 0);
    sign       : out std_logic;
    exp        : out std_logic_vector (7 downto 0);
    isAddition : out std_logic);

end entity fadd_stage1;

architecture rtl of fadd_stage1 is
  component right_shift is
    port (
      D : in  std_logic_vector (23 downto 0);
      s : in  std_logic_vector (4 downto 0);
      q : out std_logic_vector (26 downto 0));
  end component right_shift;

  signal i_A : std_logic_vector (31 downto 0) := (others => '0');
  signal i_B : std_logic_vector (31 downto 0) := (others => '0');
  signal i_m_l : std_logic_vector (23 downto 0) := (others => '0');
  signal s : std_logic_vector (4 downto 0) := (others => '0');
  signal diff_AB : std_logic_vector (7 downto 0) := (others => '0');
  signal diff_BA : std_logic_vector (7 downto 0) := (others => '0');
begin  -- architecture rtl

  with i_A (30 downto 0) > i_B (30 downto 0) select
    m_g <=
    "1" & i_A (22 downto 0) & "000" when true,
    "1" & i_B (22 downto 0) & "000" when false;

  shift : right_shift port map (i_m_l,s,m_l);

  with i_A (30 downto 0) > i_B (30 downto 0) select
    i_m_l <=
    "1" & i_B (22 downto 0) when true,
    "1" & i_A (22 downto 0) when false;

  diff_AB <= i_A (30 downto 23) - i_B (30 downto 23);
  diff_BA <= i_B (30 downto 23) - i_A (30 downto 23);

  s <= "11111" 
       when (i_A (30 downto 0) > i_B (30 downto 0) and
       diff_AB (7 downto 5) /= "000") or
       (i_A (30 downto 0) < i_B (30 downto 0) and
       diff_BA (7 downto 5) /= "000")
       else diff_AB (4 downto 0)
       when i_A (30 downto 0) > i_B (30 downto 0)
       else diff_BA (4 downto 0);

  with i_A (30 downto 0) > i_B (30 downto 0) select
    sign <=
    i_A (31) when true,
    i_B (31) when false;

  with i_A (30 downto 0) > i_B (30 downto 0) select
    exp <=
    i_A (30 downto 23) when true,
    i_B (30 downto 23) when false;
  
  isAddition <= not (i_A (31) xor i_B (31));
  
  -- purpose: set i_[AB]
  -- type   : combinational
  -- inputs : CLK
  -- outputs: i_A i_B
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_A <= A;
      i_B <= B;
    end if;
  end process set_loop;

end architecture rtl;
