library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity feq_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity feq_tb;

architecture testbench of feq_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  type lut_ans is array ( 0 to 7) of std_logic;
  constant a_lut : lut := (
    0 => "11111010111111100011001001100111",
    1 => "00110111011000101111101111100101",
    2 => "01110011100110111101101011101011",
    3 => "11001001111011100001111110100000",
    4 => "11001011110111111011010011001110",
    5 => "01110011110111100001011111001100",
    6 => "11110011110001110101111001011101",
    7 => "00111111010110100110101011100111");

  constant b_lut : lut := (
    0 => "11110111111010110100010010101100",
    1 => "10111111110101110111010001000101",
    2 => "00110011111101010001001010010010",
    3 => "11111010111110101011001100111100",
    4 => "11111011110011111101111101011101",
    5 => "01110111110011110001110010111001",
    6 => "11111110111001011000011101110111",
    7 => "10111111111011100100011101100101");

  constant ans_lut : lut_ans := (
    0 => '0',
    1 => '0',
    2 => '0',
    3 => '0',
    4 => '0',
    5 => '0',
    6 => '0',
    7 => '0');

  component feq is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic);
  end component feq;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal s_b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic := '0';

  type buff is array (3 downto 0) of std_logic;
  signal cc : std_logic := '0';
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic := '0';  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture feq_tb

  i_feq : feq port map (s_a,s_b,clk,c);

  judge: process (clk) is
  begin  -- process judge
    if rising_edge (clk) then  -- rising clock edge
      ccc <= cc;
      if ccc = c then
        Q <= x"30";
      else
        Q <= x"31";
      end if;
    end if;
  end process judge;

  ram_loop: process (clk) is
    variable ss : character;

  begin  -- process file_loop
    if clk'event and clk = '1' then    -- rising clock edge
      s_a <= a_lut (addr);
      s_b <= b_lut (addr);
      cc <= ans_lut (addr);      
      if addr >= 7 then
        addr <= 0;
      else
        addr <= addr + 1;
      end if;
    end if;
  end process ram_loop;

end architecture;
