library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pid_top_tb is
end pid_top_tb;

architecture Behavioral of pid_top_tb is
-- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal target : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal led : STD_LOGIC;

    -- Clock period (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the DUT using entity syntax
    uut: entity work.pid_top(Behavioral)
        port map (clk => clk, reset => reset, target => target, led => led);

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Test 1: target = 4
        target <= "0100";
        wait for 50 ms;

        -- Test 2: target = 8
        target <= "1000";
        wait for 50 ms;

        -- Test 3: target = 2
        target <= "0010";
        wait for 50 ms;

        -- End simulation
        wait;
    end process;
end Behavioral;