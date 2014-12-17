library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.fsqrt_types.all;

entity fsqrt_stage3 is
  
  port (
    r_in : in  fsqrt_2;
    CLK  : in  std_logic;
    Q    : out std_logic_vector (31 downto 0));

end entity fsqrt_stage3;

architecture rtl of fsqrt_stage3 is
  constant m_Nan : std_logic_vector (31 downto 0) := x"fff00000";

  signal ret : std_logic_vector (31 downto 0) := (others => '0');
  signal sign : std_logic := '0';
  signal expr_t : std_logic_vector (8 downto 0) := (others => '0');
  signal expr : std_logic_vector (7 downto 0) := (others => '0');
  signal raw_ret : std_logic_vector (45 downto 0) := (others => '0');
  signal h_a : std_logic_vector (12 downto 0) := (others => '0');
  signal h_b : std_logic_vector (12 downto 0) := (others => '0');
  signal l_a : std_logic_vector (10 downto 0) := (others => '0');
  signal l_b : std_logic_vector (10 downto 0) := (others => '0');
  signal HH : std_logic_vector (25 downto 0) := (others => '0');
  signal HL : std_logic_vector (23 downto 0) := (others => '0');
  signal LH : std_logic_vector (23 downto 0) := (others => '0');
  signal mul0 : std_logic_vector (25 downto 0) := (others => '0');
  signal mul : std_logic_vector (22 downto 0) := (others => '0');
  signal x_expr : std_logic_vector (7 downto 0) := (others => '0');
  signal m_a : std_logic_vector (24 downto 0) := (others => '0');
  signal m_b : std_logic_vector (24 downto 0) := (others => '0');
  signal sum : std_logic_vector (25 downto 0) := (others => '0');

begin  -- architecture rtl

  raw_ret <= r_in.raw_ret;

  sign <= r_in.A (31);
  expr_t <= "001111111" + r_in.A (30 downto 23);
  expr <= expr_t(8 downto 1);

  h_a <= '1' & raw_ret (45 downto 34);
  h_b <= '1' & r_in.A (22 downto 11);
  l_a <= raw_ret (33 downto 23);
  l_b <= r_in.A (10 downto 0);

  HH <= h_a * h_b;
  HL <= h_a * l_b;
  LH <= l_a * h_b;

  mul0 <= "00000000000000000000000000" + HH + LH (23 downto 11) + HL (23 downto 11) + "10";

  with mul0 (25) select
    mul <=
    mul0 (24 downto 2) when '1',
    mul0 (23 downto 1) when others;

  x_expr <= x"81" when mul0 (25) = '1' and r_in.A (23) = '0' else
            x"80" when mul0 (25) = '1' or r_in.A (23) = '0' else
            x"7f";
          

  with x_expr select
    m_a <=
    "01" & mul (22 downto 0)      when x"7f",
    '1' & mul (22 downto 0) & '0' when others;

  with x_expr select
    m_b <=
    "01" & raw_ret (22 downto 0) when x"81",
    '1' & raw_ret (22 downto 0) & '0' when others;


  sum <= "00000000000000000000000000" + m_a + m_b;

  ret <= x"3F800000" when r_in.A = x"3F800001" else
         r_in.A when sign = '1' and r_in.A (30 downto 23) = x"00" else
         m_Nan when sign = '1' else
         x"00000000" when r_in.A (30 downto 23) = x"00" else
         r_in.A when r_in.A (30 downto 23) = x"ff" else
         sign & expr & sum (24 downto 2) when m_b (24) = '1' else
         sign & expr & sum (23 downto 1);  
 
  -- purpose: set ret -> Q
  -- type   : combinational
  -- inputs : CLK
  -- outputs: Q
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      Q <= ret;
    end if;
  end process set_loop;

end architecture rtl;
