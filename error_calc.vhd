library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;

entity error_calc is
    Port ( target : in STD_LOGIC_VECTOR(3 downto 0);
           error : out sfixed(7 downto -8);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           current : in sfixed(7 downto -8);
           enable : in STD_LOGIC);
end error_calc;

architecture Behavioral of error_calc is
    signal error_reg : sfixed(7 downto -8) := to_sfixed(0, 7, -8);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            error_reg <= to_sfixed(0, 7, -8);
        elsif rising_edge(clk) then
            if enable = '1' then
                error_reg <= resize(to_sfixed(to_integer(unsigned(target)), 7, -8) - current, 7, -8);
            end if;
        end if;
    end process;
    error <= error_reg;
end Behavioral;