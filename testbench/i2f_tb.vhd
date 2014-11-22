library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity i2f_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity i2f_tb;

architecture testbench of i2f_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "11011010001001110001011010100010",
    1 => "10001101010111100001100111010000",
    2 => "00000011000110101000011100001100",
    3 => "00010111001001000111111000001011",
    4 => "01000110100100000110001001110111",
    5 => "10000111110100010101111100110101",
    6 => "00000110100111100101000011001001",
    7 => "10111010001001101110000000110001");

  constant ans_lut : lut := (
    0 => "11001110000101110110001110100101",
    1 => "11001110111001010100001111001100",
    2 => "01001100010001101010000111000011",
    3 => "01001101101110010010001111110000",
    4 => "01001110100011010010000011000101",
    5 => "11001110111100000101110101000010",
    6 => "01001100110100111100101000011001",
    7 => "11001110100010111011001001000000");

  component i2f is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component i2f;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : std_logic_vector (31 downto 0) := (others => '0');  
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture i2f_tb

  i_i2f : i2f port map (s_a,clk,c);

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
