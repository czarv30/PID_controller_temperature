library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;

entity plant2 is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           temp_out : out signed(15 downto 0);
           control_in : in signed(15 downto 0);
           enable : in STD_LOGIC);
end plant2;

architecture Behavioral of plant2 is
    signal   tout_reg   : signed(15 downto 0);
    constant TPARAMETER : signed(15 downto 0) := to_signed(25600,16);
begin
    process(clk, reset)
        variable diff  : signed(15 downto 0);
        variable delta : signed(15 downto 0);
    begin
        if reset = '1' then
            tout_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                diff := TPARAMETER - tout_reg;
                delta := resize(shift_right(control_in*diff,8),16); 
                -- Shifting right by 8 to maintain Q8.8
                tout_reg <= tout_reg + delta;
            end if;
        end if;
    end process;
    temp_out <= tout_reg;
end Behavioral;