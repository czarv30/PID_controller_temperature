library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity plant2 is
    Port ( reset        : in STD_LOGIC;
           clk          : in STD_LOGIC;
           temp_out     : out signed(15 downto 0);
           control_in   : in signed(15 downto 0);
           enable       : in STD_LOGIC);
end plant2;

architecture Behavioral of plant2 is
    signal   tout_reg     : signed(15 downto 0);
    constant TPARAMETER   : signed(15 downto 0) := to_signed(25600,16);
    constant maxprod      : signed(31 downto 0) := to_signed(2**23-1,32);
    constant minprod      : signed(31 downto 0) := to_signed(-(2**23), 32);
    signal   delta_mirror : signed(15 downto 0);
    signal   clamp        : std_logic;
    signal   cin_mirror   : signed(15 downto 0);
    
    constant K_GAIN    : signed(15 downto 0) := to_signed(1*256, 16); -- Gain from control_in to delta_T
    constant K_LOSS    : signed(15 downto 0) := to_signed(1*64, 16); -- Loss factor
    constant T_AMBIENT : signed(15 downto 0) := to_signed(0*256, 16); -- Ambient Temp
    
begin
    process(clk, reset)
        variable delta     : signed(15 downto 0);
        variable heat_gain      : signed(31 downto 0);
        variable heat_loss      : signed(31 downto 0);
        variable delta_unclamped : signed(15 downto 0);
        
        constant DELTA_MAX : signed(15 downto 0) := to_signed(32767, 16); -- Max Q8.8 change
        constant DELTA_MIN : signed(15 downto 0) := to_signed(-32768, 16);-- Min Q8.8 change
        
    begin
        if reset = '1' then
            tout_reg <= (others => '0');
            delta_mirror <= (others => '0');
            clamp <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then                              
                heat_gain := K_GAIN * control_in; -- control_in is Q8.8, K_GAIN Q8.8 -> result Q16.16
                heat_loss := K_LOSS * (tout_reg - T_AMBIENT); -- Loss proportional to temp diff with ambient
                delta_unclamped := resize(shift_right(heat_gain - heat_loss, 8), 16);
                 
                if delta_unclamped > DELTA_MAX then
                   delta := DELTA_MAX;
                elsif delta_unclamped < DELTA_MIN then
                   delta := DELTA_MIN;
                else
                   delta := delta_unclamped;
                end if;
                
                tout_reg <= tout_reg + delta;
                delta_mirror <= delta;
            end if;
        end if;
    end process;
    temp_out <= tout_reg;
    cin_mirror <= control_in;
end Behavioral;