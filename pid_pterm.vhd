library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pid_pterm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           error : in signed(15 downto 0);
           p_term : out signed(15 downto 0);
           LED : out STD_LOGIC;
           enable : in STD_LOGIC   );
end pid_pterm;

architecture Behavioral of pid_pterm is
    signal p_reg : signed(15 downto 0)  ;
    constant kp  : signed(15 downto 0) := to_signed(32,16) ;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            p_reg <=  (others => '0')  ;
        elsif rising_edge(clk) then
            if enable = '1' then
                p_reg <= resize(shift_right(kp*error,8),16)  ;  
                -- shift right to get back to implicit Q8.8, resize because product is Q16.16
            end if;
        end if;
    end process;
    p_term <= p_reg;
    led <= '1' when p_reg > 0 else '0';
end Behavioral;