library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fmul_stage3 is  
  port (
    m_in  : in  std_logic_vector (25 downto 0);
    exp0  : in  std_logic_vector (7 downto 0);
    exp1  : in  std_logic_vector (7 downto 0);
    CLK   : in  std_logic;
    m_out : out std_logic_vector (22 downto 0);
    exp   : out std_logic_vector (7 downto 0));
end entity fmul_stage3;

architecture rtl of fmul_stage3 is
  signal i_m : std_logic_vector (25 downto 0) := (others => '0');
  signal i_exp0 : std_logic_vector (7 downto 0) := (others => '0');
  signal i_exp1 : std_logic_vector (7 downto 0) := (others => '0');
begin  -- architecture rtl
  with i_m (25) select
    m_out <=
    i_m (23 downto 1) when '0',
    i_m (24 downto 2) when '1',
    i_m (24 downto 2) when others;

  with i_m (25) select
    exp <=
    i_exp1 when '1',
    i_exp0 when '0',
    i_exp0 when others;

  -- purpose: set i_m,exp0,and exp1
  -- type   : combinational
  -- inputs : CLK
  -- outputs: i_m exp0 exp1
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_m <= m_in;
      i_exp0 <= exp0;
      i_exp1 <= exp1;
    end if;
  end process set_loop;

end architecture rtl;
