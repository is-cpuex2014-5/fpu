library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity flt_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity flt_tb;

architecture testbench of flt_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  type lut_ans is array ( 0 to 7) of std_logic;
  constant a_lut : lut := (
    0 => "11111100111111101010000000000001",
    1 => "10011111110111101101110010100001",
    2 => "01110111101011011001101010010111",
    3 => "11111100010101001100010101110011",
    4 => "01111110101111110001001110000000",
    5 => "01110111110011110000110011011100",
    6 => "01110111111011011110000001101101",
    7 => "01111101111101111101110000100110");

  constant b_lut : lut := (
    0 => "11110001011100010101000001101101",
    1 => "11111000101111111100100101100010",
    2 => "11111101101011111101011010001000",
    3 => "01111101011111111111000000111010",
    4 => "11100110110001111000011001101111",
    5 => "01011011101111011100110001100101",
    6 => "11110101011111110010110101011010",
    7 => "11111110111111110000000011100000");

  constant ans_lut : lut_ans := (
    0 => '0',
    1 => '1',
    2 => '1',
    3 => '0',
    4 => '1',
    5 => '0',
    6 => '1',
    7 => '1');


  component flt is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic);
  end component flt;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal s_b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic := '0';

  type buff is array (3 downto 0) of std_logic;
  signal cc : std_logic := '0';
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic := '0';  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture flt_tb

  i_flt : flt port map (s_a,s_b,clk,c);

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
