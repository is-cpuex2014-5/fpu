library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity floor is 
  port (
    A   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    Q   : out std_logic_vector (31 downto 0));
end entity floor;

architecture behav of floor is
  signal sign : std_logic := '0';
  signal expr : std_logic_vector (7 downto 0) := (others => '0');
  signal mantissa : std_logic_vector (22 downto 0) := (others => '0');
  signal ret : std_logic_vector (31 downto 0) := (others => '0');
  
begin  -- architecture behav
  with expr > 150 select
    ret <=
    std_logic_vector(
      shift_left (arg => unsigned("000000001" & mantissa),
                  count => conv_integer(expr - 150))) when true,
    std_logic_vector(
      shift_right (arg => unsigned("000000001" & mantissa),
                  count => conv_integer(150 - expr))) when others;

  with sign select
    Q <=
    ret  when '0',
    not ret when others;

  -- purpose: set input
  -- type   : combinational
  -- inputs : clk
  main_loop: process (clk) is
  begin  -- process main_loop
    if rising_edge (clk) then
      sign <= A (31);
      expr <= A (30 downto 23);
      mantissa <= A (22 downto 0);
    end if;
  end process main_loop;

end architecture behav;
