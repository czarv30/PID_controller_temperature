library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pid_top is
    Port ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           target : in  STD_LOGIC_VECTOR (3 downto 0);
           led    : out STD_LOGIC; 
           enable : out STD_LOGIC                       )  ;
end pid_top;

architecture Behavioral of pid_top is
    signal error_signal : signed(15 downto 0);
    signal pterm_signal : signed(15 downto 0);
    signal current_signal : signed(15 downto 0);
    -- signal enable : std_logic := '0';
    signal counter : unsigned(16 downto 0) := (others => '0');
    constant CLK_DIV : integer := 100000;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
            enable <= '0';
        elsif rising_edge(clk) then
            counter <= counter + 1;
            if counter = CLK_DIV - 1 then
                counter <= (others => '0');
                enable <= '1';
            else
                enable <= '0';
            end if;
        end if;
    end process;
    error_calc: entity work.error_calc(Behavioral)
        port map(target=>target, error=>error_signal,clk=>clk,reset=>reset,current=>current_signal, enable => enable);
    pid_pterm: entity work.pid_pterm(Behavioral)
        port map(error => error_signal, p_term => pterm_signal, led => led, clk => clk, reset => reset, enable => enable);
    plant: entity work.plant2(Behavioral)
        port map(reset=> reset, clk=>clk, temp_out=>current_signal, control_in => pterm_signal, enable => enable);
        
end Behavioral;