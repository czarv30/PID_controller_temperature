library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity plant2 is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           temp_out : out STD_LOGIC_VECTOR (7 downto 0);
           control_in : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC);
end plant2;

architecture Behavioral of plant2 is
    signal tout_reg : signed(7 downto 0) := (others => '0');  -- T(t)
    constant tparameter : integer := 100;
    -- signal tout_pipe : signed(7 downto 0) := (others => '0');
begin
    process(clk,reset)
        variable diff : signed(7 downto 0);
        variable temp_product : signed(15 downto 0);
        variable delta : signed(7 downto 0);    
        begin
        if reset = '1' then
            tout_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                diff := signed(to_signed(TPARAMETER, 8)) - tout_reg;
                temp_product := signed(control_in) * diff;
                delta := resize(shift_right(temp_product, 7), 8);
                tout_reg <= tout_reg + delta;
                -- tout_pipe <= tout_reg;
            end if;
        end if;
    end process;
    -- temp_out <= std_logic_vector(tout_pipe);
    temp_out <= std_logic_vector(tout_reg); 
end Behavioral;