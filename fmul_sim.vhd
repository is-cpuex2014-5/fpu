library  ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity fmul_sim is  
  port (
    Q : out std_logic);
end entity fmul_sim;

architecture fmul_sim of fmul_sim is

  component fmul is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic_vector (31 downto 0));
  end component fmul;

  signal a : std_logic_vector (31 downto 0) := (others => '0');
  signal b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');  
  signal clk : std_logic := '0';

  type buff is array (4 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal cccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (2 downto 0) := (others => '0');
  constant clk_period : time := 10 ns;
  file inf : text;
begin  -- architecture fmul_sim

  file_open(inf, "fmul.dat",  read_mode);
  i_fmul : fmul port map (a,b,clk,c);

  judge: process (clk) is
  begin  -- process judge
    if rising_edge (clk) then  -- rising clock edge
      if cc(conv_integer(state)) = c then
        Q <= '0';
      else
        Q <= '1';
      end if;
    end if;
  end process judge;

  file_loop: process (clk) is
    variable l : line;
    variable aa : std_logic_vector (31 downto 0) := (others => '0');
    variable bb : std_logic_vector (31 downto 0) := (others => '0');
    variable ccc : std_logic_vector (31 downto 0) := (others => '0');
    variable ss : character;

  begin  -- process file_loop
    if clk'event and clk = '1' then    -- rising clock edge
      case state is
        when "000" =>
          state <= "001";
        when "001" =>
          state <= "010";
        when "010" =>
          state <= "011";
        when "011" =>
          state <= "100";
        when "100" =>
          state <= "000";        when others =>
          state <= "000";
      end case;
      readline(inf, l);
      read(l, aa);
      read(l, ss);           -- read in the space character
      read(l , bb);
      read(l, ss);           -- read in the space character
      read(l , ccc);
      a <= aa;
      b <= bb;
      cccc <= ccc;
      cc(conv_integer(state)) <= ccc;
    end if;
  end process file_loop;

  clk_gen: process
  begin  -- process clk_gen
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process clk_gen;

end architecture fmul_sim;
