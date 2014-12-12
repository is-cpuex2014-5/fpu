library ieee;
use ieee.std_logic_1164.all;

entity fabs is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    Q   : out std_logic_vector (31 downto 0));
end entity fabs;

architecture rtl of fabs is
  signal i_a : std_logic_vector (31 downto 0) := (others => '0');
begin  -- architecture rtl

  Q <= '0' & i_a (30 downto 0);

  -- purpose: set A -> i_a
  -- type   : combinational
  -- inputs : CLK
  -- outputs: i_a
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_a <= A;
    end if;
  end process set_loop;

end architecture rtl;
