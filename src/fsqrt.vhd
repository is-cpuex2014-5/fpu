library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.fsqrt_types.all;

entity fsqrt is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    Q   : out std_logic_vector (31 downto 0));
end entity fsqrt;

architecture rtl of fsqrt is
  component fsqrt_stage1 is
    port (
      A   : in  std_logic_vector (31 downto 0);
      r   : out fsqrt_1;
      CLK : in  std_logic);
  end component fsqrt_stage1;

  component fsqrt_stage2 is
    port (
      r_in  : in  fsqrt_1;
      r_out : out fsqrt_2;
      CLK   : in  std_logic);
  end component fsqrt_stage2;

  component fsqrt_stage3 is
    port (
      r_in : in  fsqrt_2;
      CLK  : in  std_logic;
      Q    : out std_logic_vector (31 downto 0));
  end component fsqrt_stage3;


  signal data1_to_2 : fsqrt_1 := (others => (others => '0'));
  signal data2_to_3 : fsqrt_2 := (others => (others => '0'));
  
begin  -- architecture rtl

  stage1 : fsqrt_stage1 port map (A,data1_to_2,CLK);
  stage2 : fsqrt_stage2 port map (data1_to_2,data2_to_3,CLK);
  stage3 : fsqrt_stage3 port map (data2_to_3,CLK,Q);

end architecture rtl;
