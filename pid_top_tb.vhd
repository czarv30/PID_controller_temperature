library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;             -- For writing data out to csv.
use IEEE.std_logic_textio.all;  -- For writing data out to csv.

entity pid_top_tb is
end pid_top_tb;

architecture Behavioral of pid_top_tb is
    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC := '0';
    signal target         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal led            : STD_LOGIC;
    signal enable         : std_logic;
    signal error_signal   : signed(15 downto 0);
    signal pterm_signal   : signed(15 downto 0);
    signal current_signal : signed(15 downto 0);

    -- Clock period (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the DUT using entity syntax
    uut: entity work.pid_top(Behavioral)
        port map (
            clk => clk, 
            current_out => current_signal, 
            enable_out => enable, 
            error_out => error_signal, 
            p_out => pterm_signal,
            reset => reset, 
            target => target, 
            led => led
        );

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
        wait;
    end process;
    
    -- TextIO process to log data
    log_proc: process
        file file_handler : text open write_mode is "pid_simulation_data.csv";
        variable line_buffer : line;
        variable sim_time : time;
    begin
        -- Write CSV header
        write(line_buffer, string'("Time,target,error_signal,pterm_signal,current_signal"));
        writeline(file_handler, line_buffer);

        -- Wait for reset to deassert
        wait until reset = '0';

        -- Log data whenever enable is high
        while true loop
            wait until rising_edge(clk);
            if enable = '1' then
                sim_time := now;  -- Get current simulation time
                write(line_buffer, sim_time / 1 ns);  -- Time in ns
                write(line_buffer, string'(","));
                
                -- Log target (convert to integer)
                write(line_buffer, to_integer(unsigned(target)));
                write(line_buffer, string'(","));
                
                -- Convert Q8.8 signals to decimal for easier plotting
                write(line_buffer, real(to_integer(error_signal)) / 256.0);  -- error_signal in decimal
                write(line_buffer, string'(","));
                
                write(line_buffer, real(to_integer(pterm_signal)) / 256.0);  -- pterm_signal in decimal
                write(line_buffer, string'(","));
                
                write(line_buffer, real(to_integer(current_signal)) / 256.0);  -- current_signal in decimal
                
                writeline(file_handler, line_buffer);
            end if;
        end loop;
        file_close(file_handler);
    end process;
    
end Behavioral;