library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fadd_stage2 is
  
  port (
    m_g            : in  std_logic_vector (26 downto 0);
    m_l            : in  std_logic_vector (26 downto 0);
    sign_in        : in  std_logic;
    exp_in         : in  std_logic_vector (7 downto 0);
    isAddition     : in  std_logic;
    sign_out       : out std_logic;
    exp_out        : out std_logic_vector (7 downto 0);    
    mantissa       : out std_logic_vector (25 downto 0);  -- the bit first
                                                          -- '1' seems to be
                                                          -- set is not included
    -- mantissa(23bit) + G + R
    carryWhenRound : out std_logic;
    leading_zero   : out std_logic_vector (4 downto 0);
    CLK            : in  std_logic);

end entity fadd_stage2;

architecture fadd_stage2 of fadd_stage2 is
  component ZLC is
    port (
      A : in  std_logic_vector (27 downto 0);
      Q : out std_logic_vector (4 downto 0));
  end component ZLC;

  signal i_m_g : std_logic_vector (26 downto 0) := (others => '0');  signal i_m_l : std_logic_vector (26 downto 0) := (others => '0');
  signal i_sign : std_logic := '0';
  signal i_exp : std_logic_vector (7 downto 0) := (others => '0');
  signal i_isAddition : std_logic := '0';
  signal m_added : std_logic_vector (27 downto 0) := (others => '0');
  signal m_leading_zero  : std_logic_vector (4 downto 0) := (others => '0');
begin  -- architecture fadd_stage2

  with i_isAddition select
    m_added <=
    "0000000000000000000000000000" + i_m_g + i_m_l when '1',
    "0000000000000000000000000000" + i_m_g - i_m_l when others;
  
  i_ZLC : ZLC port map (m_added,m_leading_zero);

  
  carryWhenRound <= '1'
                  when
                    (m_leading_zero = "00000" and m_added (26 downto 4) = "0000000000000000000000") or
                    (m_leading_zero = "00001" and m_added (25 downto 3) = "0000000000000000000000") or
                    (m_leading_zero = "00010" and m_added (24 downto 2) = "0000000000000000000000") or
                    (m_leading_zero = "00011" and m_added (23 downto 1) = "0000000000000000000000")
                  else '0';

  with m_leading_zero (1 downto 0) select
    mantissa <=
    m_added (26 downto 1)  when "00",
    m_added (25 downto 0)  when "01",
    m_added (24 downto 0) & '0'  when "10",
    m_added (23 downto 0) & "00" when others;
  
  sign_out <= i_sign;
  exp_out <= i_exp;
  leading_zero <= m_leading_zero;
  
  -- purpose: set params
  -- type   : combinational
  -- inputs : CLK
  set_loop: process (CLK) is
  begin  -- process set_loop
    if rising_edge (CLK) then
      i_m_g <= m_g;
      i_m_l <= m_l;
      i_sign <= sign_in;
      i_exp <= exp_in;
      i_isAddition <= isAddition;
    end if;
  end process set_loop;


end architecture fadd_stage2;
