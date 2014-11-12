library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fsqrt_tb is  
  port (
    clk : in std_logic;
    Q : out std_logic_vector (7 downto 0));
end entity fsqrt_tb;

architecture testbench of fsqrt_tb is

  type lut is array ( 0 to 7) of std_logic_vector(31 downto 0);
  constant a_lut : lut := (
    0 => "01110111011110011011010010111000",
    1 => "01110111111101100110001100010111",
    2 => "01111011101001010110000110101000",
    3 => "00111011100111010000100111101101",
    4 => "01101111011111100110110111110100",
    5 => "00100001101101100011110000101111",
    6 => "01000101110111000100011100101001",
    7 => "00010101111111110000101010100100");

  constant ans_lut : lut := (
    0 => "01011011011111001101010101011000",
    1 => "01011011101100011001011010001111",
    2 => "01011101100100010111111010111111",
    3 => "00111101100011011100011100100010",
    4 => "01010111011111110011011010101010",
    5 => "00110000100110001011101010010100",
    6 => "01000010101001111110101001010111",
    7 => "00101010101101001010111000011110");

  component fsqrt is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component fsqrt;

  signal addr : integer :=  0;

  signal s_a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : std_logic_vector (31 downto 0) := (others => '0');  
  signal QQ : std_logic_vector (7 downto 0) := x"2f";
  signal ccc : std_logic_vector (31 downto 0) := (others => '0'); 
  signal Q_buff : std_logic_vector (7 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
begin  -- architecture fsqrt_tb

  i_fsqrt : fsqrt port map (s_a,clk,c);

  judge: process (clk) is
  begin  -- process judge
    if rising_edge (clk) then  -- rising clock edge
      ccc <= cc ;
      if ccc = c then
		  Q_buff(addr) <= '0';
        --Q <= x"30";
      else
		  Q_buff(addr) <= '0';		
        --Q <= x"31";
      end if;
    end if;
  end process judge;

  ram_loop: process (clk,Q_buff) is
    variable ss : character;

  begin  -- process file_loop
    if clk'event and clk = '1' then    -- rising clock edge
      s_a <= a_lut (addr);
      cc <= ans_lut (addr);
      if addr >= 7 then
        addr <= 0;
      else
		  if Q_buff = "00000000" then
		      Q <= x"30";
		  else
		      Q <= x"31";
		  end if;
        addr <= addr + 1;
      end if;
    end if;
  end process ram_loop;

end architecture;
