library  ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity fsub_sim is  
  port (
    Q : out std_logic);
end entity fsub_sim;

architecture fsub_sim of fsub_sim is

  component fsub is
    port (A : in std_logic_vector (31 downto 0);
          B : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          C : out std_logic_vector (31 downto 0));
  end component fsub;

  signal a : std_logic_vector (31 downto 0) := (others => '0');
  signal b : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');  
  signal clk : std_logic := '0';

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal cccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
  signal s : std_logic := '0';
  constant clk_period : time := 10 ns;
  file inf : text open read_mode is "fsub.dat";
begin  -- architecture fsub_sim

  i_fsub : fsub port map (a,b,clk,c);

  main_loop: process 
    variable l : line;
    variable aa : std_logic_vector (31 downto 0) := (others => '0');
    variable bb : std_logic_vector (31 downto 0) := (others => '0');
    variable ccc : std_logic_vector (31 downto 0) := (others => '0');
    variable ss : character;

  begin  -- process file_loop
    if not endfile(inf) then
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      case state is
        when "00" =>
          state <= "01";
        when "01" =>
          state <= "11";
        when "11" =>
          state <= "10";
        when "10" =>
          s <= '1';
          state <= "00";
        when others =>
          state <= "00";
      end case;
      readline(inf, l);
      hread(l, aa);
      read(l, ss);           -- read in the space character
      hread(l , bb);
      read(l, ss);           -- read in the space character
      hread(l , ccc);
      a <= aa;
      b <= bb;
      cccc <= ccc;
      cc(conv_integer(state)) <= ccc;
      if s = '0' or cc(conv_integer(state)) = c then
        Q <= '0';
      else
        Q <= '1';
        assert false report "fsub test not passed!!" severity failure;
      end if;
    else
      wait;
    end if;
  end process main_loop;

end architecture fsub_sim;
