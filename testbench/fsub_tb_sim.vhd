library ieee;
use ieee.std_logic_1164.all;

entity fsub_tb_sim is
  
end entity fsub_tb_sim;

architecture sim of fsub_tb_sim is
  component fsub_tb is
    port (
      clk : in  std_logic;
      Q   : out std_logic_vector (7 downto 0));
  end component fsub_tb;
  signal clk : std_logic := '0';
  signal Q : std_logic_vector (7 downto 0) := (others => '0');
  constant clk_period : time := 10 ns;
begin  -- architecture sim
  test_bench : fsub_tb port map (clk,Q);

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
