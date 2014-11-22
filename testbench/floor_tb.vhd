library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity floor_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity floor_tb;

architecture testbench of floor_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "11001110101000001000110111101001",
    1 => "11001011111100000111000001100011",
    2 => "11001110100011010011111101110111",
    3 => "11001111011010100111011011100110",
    4 => "11001101011100000001011110011011",
    5 => "11001011011011000011100010001011",
    6 => "01001111001111000101110111011101",
    7 => "11001100010001110011010111111011");

  constant ans_lut : lut := (
    0 => "10101111101110010000101101111111",
    1 => "11111110000111110001111100111001",
    2 => "10111001011000000100010001111111",
    3 => "00010101100010010001100111111111",
    4 => "11110000111111101000011001001111",
    5 => "11111111000100111100011101110100",
    6 => "10111100010111011101110100000000",
    7 => "11111100111000110010100000010011");

  component floor is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component floor;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : std_logic_vector (31 downto 0) := (others => '0');  
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture floor_tb

  i_floor : floor port map (s_a,clk,c);

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
