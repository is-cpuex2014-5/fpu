library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.all;
use ieee.std_logic_textio.all;

entity fabs_tb_sim is
  
end entity fabs_tb_sim;

architecture sim of fabs_tb_sim is
  component fabs_tb is
    port (
      clk : in  std_logic;
      isRunning : out std_logic;
      result : out std_logic);
  end component fabs_tb;
  signal clk : std_logic := '0';
  constant clk_period : time := 10 ns;
  signal isRunning : std_logic := '1';
  signal result : std_logic := '1';
begin  -- architecture sim
  test_bench : fabs_tb port map (clk,isRunning,result);

  display: process (isRunning) is
  begin  -- process display
    if isRunning'event and isRunning = '0' then  -- rising clock edge
      if result = '1' then
        write (output,"test is passed!!");
      else
        write (output,"test is NOT passed!!");
      end if;
      finish;
    end if;
  end process display;

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
