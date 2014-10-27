library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fsub_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity fsub_tb;

architecture testbench of fsub_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "01110111011010100101010101000100",
    1 => "10010001100110110011010110100110",
    2 => "00101100011100110010111010011010",
    3 => "01100010101101100001111101011101",
    4 => "00111010111111100001101001000010",
    5 => "01101010011101111000110110111101",
    6 => "01001110111010001000101010100011",
    7 => "00001011111101100001001101100111");

  constant b_lut : lut := (
    0 => "11001011100110001101101100101101",
    1 => "11110001001100001000000111110000",
    2 => "01011011110010000110011110010011",
    3 => "10110111011101111000010011101110",
    4 => "01100001111111110001001000110110",
    5 => "01010110001110000111010000101000",
    6 => "11010000000000001001011001101010",
    7 => "01011110000001001100010111000110");

  constant ans_lut : lut := (
    0 => "01110111011010100101010101000100",
    1 => "01110001001100001000000111110000",
    2 => "11011011110010000110011110010011",
    3 => "01100010101101100001111101011101",
    4 => "11100001111111110001001000110110",
    5 => "01101010011101111000110110111101",
    6 => "01010000000111011010011110111110",
    7 => "11011110000001001100010111000110");

  component fsub is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic_vector (31 downto 0));
  end component fsub;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal s_b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (4 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture fsub_tb

  i_fsub : fsub port map (s_a,s_b,clk,c);

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
