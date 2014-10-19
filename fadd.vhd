library IEEE;
use IEEE.std_logic_1164.all;

entity fadd is  
  port (
    A   : in  std_logic_vector (31 downto 0);
    B   : in  std_logic_vector (31 downto 0);
    CLK : in  std_logic;
    C   : out std_logic_vector (31 downto 0));
end entity fadd;

architecture behav of fadd is
  component fadd_stage1 is
    port (
      A          : in  std_logic_vector (31 downto 0);
      B          : in  std_logic_vector (31 downto 0);
      CLK        : in  std_logic;
      m_g        : out std_logic_vector (26 downto 0);  -- mantissa of grater item
      m_l        : out std_logic_vector (26 downto 0);  -- mantissa of lesser item
      sign       : out std_logic;       -- signature
      exp        : out std_logic_vector (7 downto 0);   -- exponent
      isAddition : out std_logic);  -- add g and l in stage2 when this is true
  end component fadd_stage1;

  component fadd_stage2 is
    port (
      m_g            : in  std_logic_vector (26 downto 0);  -- mantissa of grater item
      m_l            : in  std_logic_vector (26 downto 0);  -- mantissa of lesser item
      sign_in        : in  std_logic;   -- signature
      exp_in         : in  std_logic_vector (7 downto 0);   -- exponent
      isAddition     : in  std_logic;
      sign_out       : out std_logic;
      exp_out        : out std_logic_vector (7 downto 0);
      mantissa       : out std_logic_vector (25 downto 0);  -- first '1' bit
                                                            -- cannot be included
      carryWhenRound : out std_logic;   -- carry when rounding
      leading_zero   : out std_logic_vector (4 downto 0);
      CLK            : in  std_logic);
  end component fadd_stage2;

  component fadd_stage3 is
    port (
      sign           : in  std_logic;
      exponent       : in  std_logic_vector (7 downto 0);
      mantissa       : in  std_logic_vector (25 downto 0);
      carryWhenRound : in  std_logic;
      leading_zero   : in  std_logic_vector (4 downto 0);
      CLK            : in  std_logic;
      ret            : out std_logic_vector (31 downto 0));
  end component fadd_stage3;
  
  -- Stage 1 -> 2
  signal m_g : std_logic_vector (26 downto 0) := (others => '0');
  signal m_l : std_logic_vector (26 downto 0) := (others => '0');
  signal sign1 : std_logic := '0';
  signal exp1 : std_logic_vector (7 downto 0) := (others => '0');
  signal isAddition : std_logic := '0';
  
  -- Stage 2 -> 3
  signal sign2 : std_logic := '0';
  signal exp2 : std_logic_vector (7 downto 0) := (others => '0');
  signal mantissa : std_logic_vector (25 downto 0) := (others => '0');
  signal carryWhenRound : std_logic := '0';
  signal leading_zero : std_logic_vector (4 downto 0) := (others => '0');

  -- Stage 3 -> out
  signal ret : std_logic_vector (31 downto 0) := (others => '0');

begin  -- architecture behav

  stage1 : fadd_stage1 port map (A,B,CLK,m_g,m_l,sign1,exp1,isAddition);

  stage2 : fadd_stage2 port map (m_g,m_l,sign1,exp1,isAddition,sign2,exp2,mantissa,carryWhenRound,leading_zero,CLK);

  state3 : fadd_stage3 port map (sign2,exp2,mantissa,carryWhenRound,leading_zero,CLK,ret);

  -- purpose: set ret -> C
  -- type   : combinational
  -- inputs : CLK
  -- outputs: C
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      C <= ret;
    end if;
  end process set_loop;
  
end architecture behav;
