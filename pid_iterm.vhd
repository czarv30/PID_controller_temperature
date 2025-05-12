library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pid_iterm is
    Port ( clk           : in    STD_LOGIC;
           reset         : in    STD_LOGIC;
           enable        : in    STD_LOGIC;
           error_signal  : in    signed(15 downto 0);
           i_term        : out   signed(15 downto 0));
end pid_iterm;

architecture Behavioral of pid_iterm is
    signal      i_reg           :   signed(15 downto 0) := (others => '0');
    constant    ki              :   signed(15 downto 0) := to_signed(13, 16); -- ki = 0.1 in Q8.8
    constant    INTEGRAL_MAX    :   signed(15 downto 0) := to_signed(32767, 16); -- 127.996 in Q8.8
    constant    INTEGRAL_MIN    :   signed(15 downto 0) := to_signed(-32768, 16); -- -128 in Q8.8
begin
    process(clk, reset)
        variable    integral     :   signed(15 downto 0) := (others => '0');
        variable    prod_temp    :   signed(31 downto 0) := (others => '0');
    begin
    if reset = '1' then
        integral := (others => '0');
        i_reg <= (others => '0');
    elsif rising_edge(clk) then
        if enable = '1' then
            integral  := integral + error_signal;
            if integral > INTEGRAL_MAX then
                integral := INTEGRAL_MAX;
            elsif integral < INTEGRAL_MIN then
                integral := INTEGRAL_MIN;
            end if;
            prod_temp := ki*integral;
            i_reg     <= resize(shift_right(prod_temp,8),16);
        end if;
    end if;
    end process;
    i_term <= i_reg;
end Behavioral;
