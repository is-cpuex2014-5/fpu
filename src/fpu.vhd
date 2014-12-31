library IEEE;
use IEEE.std_logic_1164.all;

package fpu is

  function feq (
    A : std_logic_vector (31 downto 0);
    B : std_logic_vector (31 downto 0))
    return std_logic;

  function flt (
    A : std_logic_vector (31 downto 0);
    B : std_logic_vector (31 downto 0))
    return std_logic;

end package fpu;

package body fpu is

  function feq (
    A : std_logic_vector (31 downto 0);
    B : std_logic_vector (31 downto 0))
    return std_logic is    
  begin  -- function feq
    if a (30 downto 23) = x"00" and b (30 downto 0) = x"00" then
      return '1';
    elsif a (30 downto 23) = x"ff" and b (30 downto 0) = x"ff" then
      return '0';
    elsif a = b then
      return '1';
    else 
      return '0';
    end if;
  end function feq;

  function flt (
    A : std_logic_vector (31 downto 0);
    B : std_logic_vector (31 downto 0))
    return std_logic is
  begin  -- function flt
    if a (30 downto 23) = x"00" and b (30 downto 0) = x"00" then
      return '0';
    elsif a (31) = '1' and b (31) = '1' and a > b then
      return '1';
    elsif a (31) = '1' and b (31) = '0' then
      return '1';
    elsif a (31) = '0' and b (31) = '0' and a < b then
      return '1';
    else
      return '0';
    end if;    
  end function flt;

end package body fpu;
