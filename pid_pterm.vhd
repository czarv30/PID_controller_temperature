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

entity pid_pterm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           error : in STD_LOGIC_VECTOR (7 downto 0);
           p_term : out STD_LOGIC_VECTOR (7 downto 0);
           LED : out STD_LOGIC;
           enable : in STD_LOGIC);
end pid_pterm;

architecture Behavioral of pid_pterm is
    signal p_reg : signed(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            p_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                p_reg <= shift_right(signed(error), 1);  -- K_p = 0.5
            end if;
        end if;
    end process;
    p_term <= std_logic_vector(p_reg);
    led <= '1' when p_reg > 0 else '0';
end Behavioral;