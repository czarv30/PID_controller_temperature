library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity pid_top_tb is
end pid_top_tb;

architecture Behavioral of pid_top_tb is
    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC := '0';
    signal target         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal led            : STD_LOGIC;
    signal enable_out     : std_logic;
    signal error_out      : signed(15 downto 0);
    signal p_out          : signed(15 downto 0);
    signal i_out          : signed(15 downto 0);
    signal current_out    : signed(15 downto 0);
    signal control_out    : signed(15 downto 0);

    constant CLK_PERIOD   : time := 10 ns;  -- 100 MHz
    constant SIM_DURATION : time := 500 ms; -- Extended for better observation

begin
    uut: entity work.pid_top(Behavioral)
        port map (
            clk => clk,
            reset => reset,
            target => target,
            led => led,
            enable_out => enable_out,
            error_out => error_out,
            p_out => p_out,
            i_out => i_out,
            current_out => current_out,
            control_out => control_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_process: process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Test 1: target = 4
        target <= "0100";
        wait for SIM_DURATION / 2;

        -- Test 2: target = 8
        target <= "1000";
        wait for SIM_DURATION / 2;

        wait;
    end process;

    log_proc: process
        file file_handler : text open write_mode is "C:/prog/repos/PID_temperature_controller/data/sim_data_current_PI.csv";
        variable line_buffer : line;
        variable sim_time : time;
    begin
        write(line_buffer, string'("Time,target,error,p,i,current,control"));
        writeline(file_handler, line_buffer);

        wait until reset = '0';

        for i in 1 to 500 loop -- Collect 500 samples (500 ms / 1 ms per enable)
            wait until rising_edge(clk) and enable_out = '1';
            sim_time := now;
            write(line_buffer, sim_time / 1 ns);
            write(line_buffer, string'(","));
            write(line_buffer, to_integer(unsigned(target)));
            write(line_buffer, string'(","));
            write(line_buffer, real(to_integer(error_out)) / 256.0);
            write(line_buffer, string'(","));
            write(line_buffer, real(to_integer(p_out)) / 256.0);
            write(line_buffer, string'(","));
            write(line_buffer, real(to_integer(i_out)) / 256.0);
            write(line_buffer, string'(","));
            write(line_buffer, real(to_integer(current_out)) / 256.0);
            write(line_buffer, string'(","));
            write(line_buffer, real(to_integer(control_out)) / 256.0);
            writeline(file_handler, line_buffer);
        end loop;

        file_close(file_handler);
        wait;
    end process;
end Behavioral;