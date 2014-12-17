library IEEE;
use IEEE.STD_LOGIC_1164.all;

package fsqrt_types is

  type fsqrt_1 is record -- input to fsqrt stage 2
    A   : std_logic_vector (31 downto 0);
    key : std_logic_vector (9 downto 0);
  end record fsqrt_1;

  type fsqrt_2 is record -- input to fsqrt stage 3
    A       : std_logic_vector (31 downto 0);
    raw_ret : std_logic_vector (45 downto 0);
  end record fsqrt_2;

end package fsqrt_types;

