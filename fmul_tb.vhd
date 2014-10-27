library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fmul_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity fmul_tb;

architecture testbench of fmul_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "11100100110010110111001011000111",
    1 => "11100101111100001100110010110110",
    2 => "11010000000011011111001000100111",
    3 => "01101111110101111101110100101111",
    4 => "00100010011100111100101111000011",
    5 => "10010011101100111110001000100011",
    6 => "11100011100000100101111011000011",
    7 => "11010100111010001101101100001001");

  constant b_lut : lut := (
    0 => "01010110100110010011111010011110",
    1 => "11111100010110010000100000110111",
    2 => "10001100001001000110110001100111",
    3 => "01001100000001100001001111000110",
    4 => "11101000001010100000001001001111",
    5 => "00101110001110010100001110100111",
    6 => "01010100110001010001001100110000",
    7 => "10010111111011111011000001001110");

  constant ans_lut : lut := (
    0 => "11111011111100111001001010111001",
    1 => "00000000110011000010010101000000",
    2 => "00011100101101100101011001111001",
    3 => "01111100011000100001110011100110",
    4 => "11001011001000011110011110000010",
    5 => "10000010100000100010110111110101",
    6 => "11111000110010001011100101100011",
    7 => "00101101010110100000010011011011");

  component fmul is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic_vector (31 downto 0));
  end component fmul;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal s_b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (4 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture fmul_tb

  i_fmul : fmul port map (s_a,s_b,clk,c);

  judge: process (clk) is
  begin  -- process judge
    if rising_edge (clk) then  -- rising clock edge
      ccc <= cc (conv_integer (state));
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
      case state is
        when "00" =>
          state <= "01";
        when "01" =>
          state <= "11";
        when "11" =>
          state <= "10";
        when "10" =>
          state <= "00";
        when others =>
          state <= "00";
      end case;
      s_a <= a_lut (addr);
      s_b <= b_lut (addr);
      cc(conv_integer(state)) <= ans_lut (addr);      
      if addr >= 7 then
        addr <= 0;
      else
        addr <= addr + 1;
      end if;
    end if;
  end process ram_loop;

end architecture;
