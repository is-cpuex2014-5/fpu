library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fmul is 
  port (
    A   : in  std_logic_vector (31 downto 0);
    B   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    C   : out std_logic_vector (31 downto 0));
end entity fmul;

architecture behav of fmul is
  component fmul_stage1 is
    port (
      A : in std_logic_vector (31 downto 0);
      B : in std_logic_vector (31 downto 0);
      CLK : in std_logic;
      exp0 : out std_logic_vector (8 downto 0);
      HH : out std_logic_vector (25 downto 0);
      HL : out std_logic_vector (23 downto 0);
      LH : out std_logic_vector (23 downto 0);
      sign : out std_logic);
  end component fmul_stage1;

  component fmul_stage2 is
    port (
      HH            : in  std_logic_vector (25 downto 0);
      HL            : in  std_logic_vector (23 downto 0);
      LH            : in  std_logic_vector (23 downto 0);
      exp           : in  std_logic_vector (7 downto 0);
      underflow_bit : in  std_logic;
      exp0          : out std_logic_vector (7 downto 0);
      exp1          : out std_logic_vector (7 downto 0);
      mantissa      : out std_logic_vector (25 downto 0);
      CLK           : in  std_logic);
  end component fmul_stage2;

  component fmul_stage3 is
    port (
      m_in  : in  std_logic_vector (25 downto 0);
      exp0  : in  std_logic_vector (7 downto 0);
      exp1  : in  std_logic_vector (7 downto 0);
      CLK   : in  std_logic;
      m_out : out std_logic_vector (22 downto 0);
      exp   : out std_logic_vector (7 downto 0));
  end component fmul_stage3;

  --component fmul_special is
  --  port (
  --    A     : in  std_logic_vector (31 downto 0);
  --    B     : in  std_logic_vector (31 downto 0);
  --    CLK   : in  std_logic;
  --    C     : out std_logic_vector (31 downto 0);
  --    flag : out std_logic);
  --end component fmul_special;

  --signal special_flag : std_logic := '0';
  --signal special_out : std_logic_vector (31 downto 0) := (others => '0');

  signal e : std_logic_vector (15 downto 0) := (others => '0');
  signal m : std_logic_vector (47 downto 0) := (others => '0');
  signal re : std_logic := '0';
  signal HH : std_logic_vector (25 downto 0) := (others => '0');
  signal HL : std_logic_vector (23 downto 0) := (others => '0');
  signal LH : std_logic_vector (23 downto 0) := (others => '0');
  signal exp01 : std_logic_vector (8 downto 0) := (others => '0');
  signal exp0 : std_logic_vector (7 downto 0) := (others => '0');
  signal exp1 : std_logic_vector (7 downto 0) := (others => '0');
  signal underflow_bit : std_logic := '0';
  signal m2 : std_logic_vector (25 downto 0) := (others => '0');
  signal state : std_logic_vector (1 downto 0) := (others => '0');
  signal sign_o : std_logic := '0';
  signal sign : std_logic_vector (2 downto 0) := (others => '0');
  signal exp : std_logic_vector (7 downto 0) := (others => '0');
  signal mantissa : std_logic_vector (22 downto 0) := (others => '0');
  
begin  -- architecture behav

  --special : fmul_special port map (A,B,CLK,special_out,special_flag);

  stage1 : fmul_stage1 port map (A,B,CLK,exp01,HH,HL,LH,sign_o);

  stage2 : fmul_stage2 port map (HH,HL,LH,exp01 (7 downto 0),exp01 (8),exp0,exp1,m2,CLK);

  stage3 : fmul_stage3 port map (m2,exp0 ,exp1,CLK,mantissa,exp);

  -- purpose: change state
  -- type   : combinational
  -- inputs : CLK
  -- outputs: state
  main_loop: process (CLK) is
  begin  -- process main_loop
    if rising_edge (CLK) then
      if state = "00" then
        state <= "01";
        sign (0) <= sign_o;
        C <= sign (1) & exp & mantissa;
      elsif state = "01" then
        state <= "10";
        sign (1) <= sign_o;
        C <= sign (2) & exp & mantissa;
      else
        state <= "00";
        sign (2) <= sign_o;
        C <= sign (0) & exp & mantissa;
      end if;
    end if;
  end process main_loop;

end architecture behav;
