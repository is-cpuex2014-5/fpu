library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fadd_stage3 is
  
  port (
    sign           : in  std_logic;
    exponent       : in  std_logic_vector (7 downto 0);
    mantissa       : in  std_logic_vector (25 downto 0);
    -- mantissa(23bit) + G + R
    carryWhenRound : in  std_logic;
    leading_zero   : in  std_logic_vector (4 downto 0);
    CLK            : in  std_logic;
    ret            : out std_logic_vector (31 downto 0));

end entity fadd_stage3;

architecture fadd_stage3 of fadd_stage3 is
  signal i_sign : std_logic := '0';
  signal i_exp : std_logic_vector (7 downto 0) := (others => '0');
  signal i_mantissa : std_logic_vector (25 downto 0) := (others => '0');
  signal i_carry : std_logic := '0';
  signal i_leading_zero : std_logic_vector (4 downto 0) := (others => '0');
  signal o_exp0 : std_logic_vector (7 downto 0) := (others => '0');
  signal o_exp : std_logic_vector (7 downto 0) := (others => '0');
  signal o_mantissa : std_logic_vector (22 downto 0) := (others => '0');

begin  -- architecture fadd_stage3
 
  o_mantissa <= i_mantissa (25 downto 3) + '1'
                when i_leading_zero (4 downto 2) = "000" and
                i_mantissa (2) = '1' and (i_mantissa (1) = '1' or i_mantissa (3) = '1') and
                i_carry = '0'
                else
                "00000000000000000000000"
                when i_leading_zero (4 downto 2) = "000" and
                i_mantissa (2) = '1' and (i_mantissa (1) = '1' or i_mantissa (3) = '1') and
                i_carry = '1'                
                else
                i_mantissa (25 downto 3)
                when i_leading_zero (4 downto 2) = "000"
                else
                i_mantissa (21 downto 0) & '0'
                when i_leading_zero (4 downto 2)  = "001"
                else
                i_mantissa (17 downto 0) & "00000"
                when i_leading_zero (4 downto 2)  = "010"
                else
                i_mantissa (13 downto 0) & "000000000"
                when i_leading_zero (4 downto 2)  = "011"
                else
                i_mantissa (9 downto 0) & "0000000000000"
                when i_leading_zero (4 downto 2)  = "100"
                else
                i_mantissa (5 downto 0) & "00000000000000000"
                when i_leading_zero (4 downto 2)  = "101"
                else
                i_mantissa (1 downto 0) & "000000000000000000000"
                when i_leading_zero (4 downto 2)  = "110"
                else
                "00000000000000000000000";

  o_exp0 <= i_exp + 1
          when i_leading_zero (4 downto 2) = "000" and
            i_mantissa (1) = '1' and (i_mantissa (0) = '1' or i_mantissa (2) = '1') and
            i_carry = '1'
          else
            i_exp;

  o_exp <= (others => '0')
           when i_leading_zero > 0 and (o_exp0 < (i_leading_zero - 1) or i_leading_zero >= 26)
           else o_exp0 - i_leading_zero + 1;

  ret <= i_sign & o_exp & o_mantissa;

  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_sign <= sign;
      i_exp <= exponent;
      i_mantissa <= mantissa;
      i_carry <= carryWhenRound;
      i_leading_zero <= leading_zero;      
    end if;
  end process set_loop;
end architecture fadd_stage3;
