library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity error_calc is
    Port ( target : in STD_LOGIC_VECTOR(3 downto 0);
           error : out signed(15 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           current : in signed(15 downto 0);
           enable : in STD_LOGIC);
end error_calc;

architecture Behavioral of error_calc is
    signal error_reg : signed(15 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            error_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                -- error_reg <= to_signed('0000' & target & '00000000') - current;
                error_reg <= to_signed(to_integer(unsigned(target)) * 256, 16) - current;
            end if;
        end if;
    end process;
    error <= error_reg;
end Behavioral;