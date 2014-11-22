library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fadd_tb is  
  port (
    clk : in std_logic;
    isRunning : out std_logic;
    result : out std_logic);
end entity fadd_tb;

architecture testbench of fadd_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "00010110010111100101001110000110",
    1 => "11111100011101101110101110111010",
    2 => "01100100101111001001011100010010",
    3 => "00010001011001101001100010101110",
    4 => "01100011100001010110000111010101",
    5 => "00000011111001010100011100011011",
    6 => "00100101111110101101100011011011",
    7 => "00101100110100110001001101000101");

  constant b_lut : lut := (
    0 => "00101101101011110111000101000000",
    1 => "11011110000001001111110010110110",
    2 => "00100011010000100001100001011100",
    3 => "01100011011001000011010110100010",
    4 => "01100011100110101001100000111111",
    5 => "11000100100101001011111010110010",
    6 => "01111010000111111100010111001101",
    7 => "10010100011111100000000111000100");

  constant ans_lut : lut := (
    0 => "00101101101011110111000101000000",
    1 => "11111100011101101110101110111010",
    2 => "01100100101111001001011100010010",
    3 => "01100011011001000011010110100010",
    4 => "01100100000011111111110100001010",
    5 => "11000100100101001011111010110010",
    6 => "01111010000111111100010111001101",
    7 => "00101100110100110001001101000101");

  component fadd is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic_vector (31 downto 0));
  end component fadd;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal s_b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');

  signal i_isRunning : std_logic := '0';
  signal i_result : std_logic := '1';
begin  -- architecture fadd_tb

  i_fadd : fadd port map (s_a,s_b,clk,c);
  isRunning <= i_isRunning;
  result <= i_result;

  judge: process (clk,i_isRunning) is
  begin  -- process judge
    if i_isRunning = '1' and rising_edge (clk) then  -- rising clock edge
      ccc <= cc (conv_integer (state));
      if ccc = c and i_result = '1' then
        i_result <= '1';
      else
        i_result <= '0';
      end if;
    end if;
  end process judge;

  ram_loop: process (clk) is
    variable ss : character;
    variable count : integer := 4;
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
        if count > 0 then
          count := count - 1;
        else
          i_isRunning <= '0';
        end if;
      else
        if addr = 5 then
          i_isRunning <= '1';
        end if;
        addr <= addr + 1;
      end if;
    end if;
  end process ram_loop;

end architecture;
