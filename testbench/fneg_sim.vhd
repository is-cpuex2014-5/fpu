library  ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity fneg_sim is  
  port (
    Q : out std_logic);
end entity fneg_sim;

architecture fneg_sim of fneg_sim is

  component fneg is
    port (A : in std_logic_vector (31 downto 0);
          CLK : in std_logic;
          Q : out std_logic_vector (31 downto 0));
  end component fneg;

  signal a : std_logic_vector (31 downto 0) := (others => '0');
  signal c : std_logic_vector (31 downto 0) := (others => '0');  
  signal clk : std_logic := '0';

  type buff is array (3 downto 0) of std_logic_vector (31 downto 0);
  signal cc : buff := (others => (others => '0'));
  signal cccc : std_logic_vector (31 downto 0) := (others => '0');
  signal tmpc : std_logic_vector (31 downto 0) := (others => '0');  
  signal state : std_logic_vector (1 downto 0) := (others => '0');
  signal s : std_logic := '0';
  constant clk_period : time := 10 ns;
  file inf : text open read_mode is "fneg.dat";
begin  -- architecture fneg_sim

  i_fneg : fneg port map (a,clk,c);

  main_loop: process 
    variable l : line;
    variable aa : std_logic_vector (31 downto 0) := (others => '0');
    variable bb : std_logic_vector (31 downto 0) := (others => '0');
    variable ss : character;
    variable s : std_logic_vector (1 downto 0) := "00";

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
          state <= "00";
        when others =>
          state <= "00";
      end case;
      readline(inf, l);
      read(l, aa);
      read(l, ss);           -- read in the space character
      read(l , bb);
      a <= aa;
      cccc <= bb;
      if cccc = c or s /= "11" then
        Q <= '0';
      else
        Q <= '1';
        assert false report "fneg test not passed!!" severity failure;
      end if;
      if s (0) = '0' then        
        s (0) := '1';
      else
        s (1) := '1';
      end if;
    else
      wait;
    end if;
  end process main_loop;

end architecture fneg_sim;
