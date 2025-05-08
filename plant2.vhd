library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;

entity plant2 is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           temp_out : out sfixed(7 downto -8);
           control_in : in sfixed(7 downto -8);
           enable : in STD_LOGIC);
end plant2;

architecture Behavioral of plant2 is
    signal tout_reg : sfixed(7 downto -8) := to_sfixed(0, 7, -8);
    constant TPARAMETER : sfixed(7 downto -8) := to_sfixed(100, 7, -8);
begin
    process(clk, reset)
        variable diff : sfixed(7 downto -8);
        variable delta : sfixed(7 downto -8);
    begin
        if reset = '1' then
            tout_reg <= to_sfixed(0.0, 7, -8);
        elsif rising_edge(clk) then
            if enable = '1' then
                diff := TPARAMETER - tout_reg;
                delta := to_sfixed(to_real(control_in) * to_real(diff), 15, -16) / to_sfixed(128.0, 7, -8);
                delta := resize(delta, 7, -8);
                tout_reg <= tout_reg + delta;
            end if;
        end if;
    end process;
    temp_out <= tout_reg;
end Behavioral;