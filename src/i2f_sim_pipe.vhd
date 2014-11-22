library  ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity i2f_sim_pipe is  
  port (
    Q : out std_logic);
end entity i2f_sim_pipe;

architecture i2f_sim_pipe of i2f_sim_pipe is

  component i2f is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component i2f;

  signal a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');  
  signal clk : std_logic := '0';

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal cccc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
  signal s : std_logic := '0';
  constant clk_period : time := 10 ns;
begin  -- architecture i2f_sim_pipe

  i_i2f : i2f port map (a,clk,c);

  main_loop: process 
    variable l : line;
    variable aa : std_logic_vector (31 downto 0) := (others => '0');
    variable bb : std_logic_vector (31 downto 0) := (others => '0');
    variable ss : character;
    variable s : std_logic := '0';

  begin  -- process file_loop
    if not endfile(input) then
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
          state <= "00";
        when others =>
          state <= "00";
      end case;
      readline(input, l);
      read(l, aa);
      read(l, ss);           -- read in the space character
      read(l , bb);
      a <= aa;
      cccc <= bb;
      if cccc = c or s = '0' then
        Q <= '0';
      else
        Q <= '1';
        assert false report "i2f test not passed!!" severity failure;
      end if;
      s := '1';
    else
      wait;
    end if;
  end process main_loop;

end architecture i2f_sim_pipe;
