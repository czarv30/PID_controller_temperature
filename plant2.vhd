library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity plant2 is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           temp_out : out signed(15 downto 0);
           control_in : in signed(15 downto 0);
           enable : in STD_LOGIC);
end plant2;

architecture Behavioral of plant2 is
    signal   tout_reg     : signed(15 downto 0);
    constant TPARAMETER   : signed(15 downto 0) := to_signed(25600,16);
    constant maxprod      : signed(31 downto 0) := to_signed(2**23-1,32);
    constant minprod      : signed(31 downto 0) := to_signed(-(2**23), 32);
    signal   delta_mirror : signed(15 downto 0);
    signal   clamp        : std_logic;
    signal   cin_mirror   : signed(15 downto 0);
begin
    process(clk, reset)
        variable diff      : signed(15 downto 0);
        variable delta     : signed(15 downto 0);
        variable prod      : signed(15 downto 0);
    begin
        if reset = '1' then
            tout_reg <= (others => '0');
            delta_mirror <= (others => '0');
            clamp <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                diff := TPARAMETER - tout_reg;
                cin_mirror <= control_in;
                prod := resize(shift_right(control_in*diff,8),16);
                
                if prod > maxprod then
                    delta := to_signed(127 * 256, 16);
                    clamp <= '1';
                elsif prod < minprod then
                    delta := to_signed(-128 * 256, 16);
                    clamp <= '1';
                else
                    delta := prod / to_signed(10,16);
                    clamp <= '0';
                end if;
                -- delta := delta / to_signed(10 *256,16);
                delta_mirror <= delta;
                tout_reg <= tout_reg + delta;
            end if;
        end if;
    end process;
    temp_out <= tout_reg;
end Behavioral;