library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ZLC31 is
  
  port (
    A : in  std_logic_vector (30 downto 0);
    Q : out integer range 0 to 31);

end entity ZLC31;

architecture rtl of ZLC31 is  

  -- purpose: ZLC31 of 3 bits
  function ZLC3 (
    A : std_logic_vector (2 downto 0))
    return unsigned is
    variable ret : unsigned (1 downto 0) := (others => '0');
  begin  -- function ZLC3
    ret (1) := A (2) nor A (1);
    ret (0) := not (A (2) or (not A(1) and A (0)));
    return ret;
  end function ZLC3;
  
  -- purpose: ZLC of 7 bits
  function ZLC7 (
    A : std_logic_vector (6 downto 0))
    return unsigned is
    variable ret : unsigned (2 downto 0) := (others => '0');
  begin  -- function ZLC7
    ret (2) := not (A (6) or A (5) or A (4) or A (3));
    ret (1) := not (A (6) or A (5) or (not A (4) and not A (3) and (A (2) or A (1))));
    ret (0) := not (A (6)
               or ( not A (5) and ( A (4)
               or ( not A (3) and ( A (2)
               or ( not A (1) and ( A (0))))))));
    return ret;
  end function ZLC7;

  -- purpose: ZLC of 15 bits
  function ZLC15 (
    A : std_logic_vector (14 downto 0))
    return unsigned is
    variable ret : unsigned (3 downto 0) := (others => '0');
  begin  -- function ZLC15
    ret (3) := not (A (14) or A (13) or A (12) or A (11) 
               or A (10) or A (9) or A (8) or A (7));
    ret (2) := not (A (14) or A (13) or A (12) or A (11)
                    or (not A (10) and not A (9) and not A (8) and not A (7)
                    and (A (6) or A (5) or A (4) or A (3))));
    ret (1) := not (A (14) or A (13)
               or ( not A (12) and not A (11) and ( A (10) or A (9)
               or ( not A (8) and not A (7) and (A (6) or A (5)
               or (not A (4) and not A (3) and (A (2) or A (1))))))));
    ret (0) := not (A (14)
               or ( not A (13) and ( A (12)
               or ( not A (11) and ( A (10)
               or ( not A (9) and ( A (8)
               or ( not A (7) and ( A (6)
               or ( not A (5) and ( A (4)
               or ( not A (3) and ( A (2)
               or ( not A (1) and ( A (0))))))))))))))));
    return ret;
  end function ZLC15;
  
begin  -- architecture rtl

  Q <= to_integer(ZLC15 (A (30 downto 16)))
       when ZLC15 (A (30 downto 16)) /= 15
       else 15 + to_integer(ZLC7 (A (15 downto 9)))
       when ZLC7 (A (15 downto 9)) /= 7
       else 22 + to_integer(ZLC3 (A (8 downto 6)))
       when ZLC3 (A (8 downto 6)) /= 3
       else 25 + to_integer(ZLC3 (A (5 downto 3)))
       when ZLC3 (A (5 downto 3)) /= 3
       else 28 + to_integer(ZLC3 (A (2 downto 0)));
end architecture rtl;
