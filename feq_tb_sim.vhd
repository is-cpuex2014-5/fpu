library ieee;
use ieee.std_logic_1164.all;

entity feq_tb_sim is
  
end entity feq_tb_sim;

architecture sim of feq_tb_sim is
  component feq_tb is
    port (
      clk : in  std_logic;
      Q   : out std_logic_vector (7 downto 0));
  end component feq_tb;
  signal clk : std_logic := '0';
  signal Q : std_logic_vector (7 downto 0) := (others => '0');
  constant clk_period : time := 10 ns;
begin  -- architecture sim
  test_bench : feq_tb port map (clk,Q);

  -- purpose: clock generator
  -- type   : combinational
  -- inputs : 
  -- outputs: clk
  clock_gen: process is
  begin  -- process clock_gen
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
  end process clock_gen;
  

end architecture sim;
