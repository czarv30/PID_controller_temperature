# PID Temperature Controller
Implemented in VHDL for Basys-3 FPGA using Vivado. 

Implementation details:
* 4bit target mapped to switches on board.
* Fixed-point arithmetic in Q8.8, manual implementation, not using fixed_pkg. 
* The plant is assumed to be a heat sink, like a water tank, to which heat is added from a source at a fixed temperature (like a stove burning hot gas beneath), and some convective process would provide cooling. 

```mermaid
graph LR
    %% --- Define all nodes first ---
    N_Target["target<br> (4bit)"]
    %% Using Sigma for the summing junction N_SumError
    N_SumError((Σ))
    N_P["pid_pterm.vhd (Kp)"]
    N_I["pid_iterm.vhd (Ki)"]
    N_D["pid_dterm.vhd (Kd)"]
    %% Using Sigma for the summing junction N_SumPID
    N_SumPID((Σ))
    %% Matched Plant node text to your screenshot
    N_Plant["plant2.vhd"]

    %% --- Define links between nodes ---
    N_Target --(+)--> N_SumError
    N_SumError --error_calc.vhd--> N_P
    N_SumError --error_calc.vhd--> N_I
    N_SumError --error_calc.vhd--> N_D

    N_P --> N_SumPID
    N_I --> N_SumPID
    N_D --> N_SumPID

    N_SumPID --control_in--> N_Plant
    N_Plant --(-)--> N_SumError
```

## Phase 1: P-only microcontroller. 
We develop all the code to run a p-only controller. Signals are exposed at the top level to export signals to csv, plotted below.

Set target to "0100" (4 in decimal).

On the plot below, we see two issues with the p-only controller:
1. The error oscillates before settling and,
2. The error does not actually settle very close to zero. After ~ 24 ms, the response settles to ~0.1. This is well above the precision capabilities of the controller. 


```python
import importlib, polars as pl, dataplotter
importlib.reload(dataplotter) # dataplotter is a separate script I wrote to make the plots.  

# Preprocess the data
sim_data = r'C:\prog\repos\PID_temperature_controller\data\pid_simulation_data_ponly.csv'
df = pl.read_csv(sim_data)
dfp = df.with_columns(((pl.col('Time')*1e-9)*1e3).alias('time_ms'))

my_figure = dataplotter.create_plot(dfp,24,y_zoom_limits=(-0.02, 0.14))
```


    
![png](README_files/README_2_0.png)
    


## Phase 2: PI controller 

Relevant code below:
```vhdl
process(clk, reset)
    variable    integral     :   signed(15 downto 0) := (others => '0');
    variable    prod_temp    :   signed(31 downto 0) := (others => '0');
begin
if reset = '1' then
    integral := (others => '0');
    i_reg <= (others => '0');
elsif rising_edge(clk) then
    if enable = '1' then
        integral  := integral + error_signal;
        if integral > INTEGRAL_MAX then
            integral := INTEGRAL_MAX;
        elsif integral < INTEGRAL_MIN then
            integral := INTEGRAL_MIN;
        end if;
        prod_temp := ki*integral;
        i_reg     <= resize(shift_right(prod_temp,8),16);
    end if;
end if;
end process;
```


```python

```
