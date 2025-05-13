library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pid_dterm is
Port (      reset               : in    std_logic;
            clk                 : in    std_logic;
            enable              : in    std_logic;
            error_signal        : in    signed(15 downto 0);
            d_term              : out   signed(15 downto 0)
);
end pid_dterm;

architecture Behavioral of pid_dterm is
    signal      prev_error   : SIGNED(15 downto 0) := (others => '0');
    signal      error_diff   : SIGNED(15 downto 0) := (others => '0');
    signal      d_term_reg   : SIGNED(15 downto 0) := (others => '0');
    constant    kd           : signed(15 downto 0) := to_signed(16,16);
begin
    process(clk, reset)
    begin
    if reset = '1' then
        prev_error <= (others => '0');
        d_term_reg <= (others => '0');
    elsif rising_edge(clk) then
        if enable = '1' then
            error_diff <= error_signal - prev_error;
            d_term_reg <= resize(shift_right(error_diff * kd, 8), 16);
            prev_error <= error_signal;
        end if;
    end if;
    end process;
    d_term <= d_term_reg;
end Behavioral;
