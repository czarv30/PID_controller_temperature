library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity error_calc is
    Port ( target : in STD_LOGIC_VECTOR (3 downto 0);
           error : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           current : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC);
end error_calc;

architecture Behavioral of error_calc is
    signal error_reg : signed(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            error_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                error_reg <= signed("0000" & target) - signed(current);
            end if;
        end if;
    end process;
error <= std_logic_vector(error_reg);
end Behavioral;