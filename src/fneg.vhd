library ieee;
use ieee.std_logic_1164.all;

entity fneg is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    Q   : out std_logic_vector (31 downto 0));
end entity fneg;

architecture rtl of fneg is
  signal i_a : std_logic_vector (31 downto 0) := (others => '0');
begin  -- architecture rtl

  with i_a (31) select
    Q <=
    '1' & i_a (30 downto 0) when '0',
    '0' & i_a (30 downto 0) when others;

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
