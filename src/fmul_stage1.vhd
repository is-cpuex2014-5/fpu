library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fmul_stage1 is
  port (
    A : in std_logic_vector (31 downto 0);
    B : in std_logic_vector;
    CLK : in std_logic;
    exp0 : out std_logic_vector (8 downto 0);
    HH : out std_logic_vector (25 downto 0);
    HL : out std_logic_vector (23 downto 0);
    LH : out std_logic_vector (23 downto 0);
    sign : out std_logic);
end entity fmul_stage1;

architecture rtl of fmul_stage1 is
  signal i_a : std_logic_vector (31 downto 0) := (others => '0');
  signal i_b : std_logic_vector (31 downto 0) := (others => '0');
begin  -- architecture rtl
  HH <= ('1' & i_a (22 downto 11)) * ('1' & i_b (22 downto 11));
  HL <= ('1' & i_a (22 downto 11)) * (i_b (10 downto 0));
  LH <= (i_a (10 downto 0)) * ('1' & i_b (22 downto 11));
  exp0 <= "000000000" + i_a (30 downto 23) + i_b (30 downto 23) + 129;
  sign <= i_a (31) xor i_b (31);
  
  -- purpose: set i_a and i_b
  -- type   : combinational
  -- inputs : CLK
  -- outputs: i_a i_b
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_a <= A;
      i_b <= B;
    end if;
  end process set_loop;

end architecture rtl;
