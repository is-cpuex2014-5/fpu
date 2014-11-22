library IEEE;
use IEEE.std_logic_1164.all;

-- returns 1 when A < B
entity flt is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    B   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    C   : out std_logic);
end entity flt;

architecture rtl of flt is
  signal ret : std_logic := '0';
begin  -- architecture rtl
  
  ret <= '0' when a (30 downto 23) = x"00" and b (30 downto 0) = x"00"
         else '1' when a (31) = '1' and b (31) = '1' and a > b
         else '1' when a (31) = '1' and b (31) = '0'
         else '1' when a (31) = '0' and b (31) = '0' and a < b
         else '0';

  -- purpose: set ret -> C
  -- type   : combinational
  -- inputs : CLK
  -- outputs: C
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      C <= ret;
    end if;
  end process set_loop;
  
end architecture rtl;
