library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity finv_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity finv_tb;

architecture testbench of finv_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "00100110110001100101000010011001",
    1 => "10010100010111100001101011110011",
    2 => "00101011101000100111010001110111",
    3 => "10000001101000000000010100111000",
    4 => "11100000001100100000111001010001",
    5 => "11100100001000110110100101101111",
    6 => "00000011001011110010101001000111",
    7 => "00110010011011010010011100100010");

  constant ans_lut : lut := (
    0 => "01011000001001010011101101110100",
    1 => "11101010100100111000100010011110",
    2 => "01010011010010011011010010000100",
    3 => "11111101010011001100011000011110",
    4 => "10011110101110000000100000110110",
    5 => "10011010110010001000011000100100",
    6 => "01111011101110110001000110110100",
    7 => "01001100100010100010110000101000");

  component finv is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component finv;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : std_logic_vector (31 downto 0) := (others => '0');  
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture finv_tb

  i_finv : finv port map (s_a,clk,c);

  judge: process (clk) is
  begin  -- process judge
    if rising_edge (clk) then  -- rising clock edge
      ccc <= cc ;
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
      cc <= ans_lut (addr);      
      if addr >= 7 then
        addr <= 0;
      else
        addr <= addr + 1;
      end if;
    end if;
  end process ram_loop;

end architecture;
