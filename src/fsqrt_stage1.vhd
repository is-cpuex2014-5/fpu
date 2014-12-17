library IEEE;
use IEEE.std_logic_1164.all;
use work.fsqrt_types.all;

entity fsqrt_stage1 is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    r   : out fsqrt_1;
    CLK : in  std_logic);
end entity fsqrt_stage1;

architecture rtl of fsqrt_stage1 is

begin  -- architecture rtl

  -- purpose: set ret -> Q
  -- type   : combinational
  -- inputs : CLK
  -- outputs: Q
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      r.A <= A;
      r.key <= (not A (23)) &  A(22 downto 14);
    end if;
  end process set_loop;
  
end architecture rtl;
