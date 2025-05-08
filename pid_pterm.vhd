library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;

entity pid_pterm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           error : in sfixed(7 downto -8);
           p_term : out sfixed(7 downto -8);
           LED : out STD_LOGIC;
           enable : in STD_LOGIC);
end pid_pterm;

architecture Behavioral of pid_pterm is
    signal p_reg : sfixed(7 downto -8) := to_sfixed(0.0, 7, -8);
    constant pt : sfixed(7 downto -8) := to_sfixed(0.5, 7, -8);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            p_reg <= to_sfixed(0.0, 7, -8);
        elsif rising_edge(clk) then
            if enable = '1' then
                p_reg <= resize(pt*error,7,-8);
            end if;
        end if;
    end process;
    p_term <= p_reg;
    led <= '1' when p_reg > 0 else '0';
end Behavioral;