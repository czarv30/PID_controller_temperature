# PID Temperature Controller
Implemented in Basys-3 FPGA


```python
import polars as pl
import seaborn as sns
sim_data = r'C:\prog\fpga\PID_temp_controller\PID_temp_controller.sim\sim_1\behav\xsim\pid_simulation_data.csv'
df = pl.read_csv(sim_data)

dfp = df.with_columns(
    ((pl.col('Time')*1e-9)*1e3).alias('time_ms')
)
#dfp.head()
```

## P-only response.
First as a sanity check we develop a P-only "PID"


```python
sns.relplot(dfp, x='time_ms',y='error_signal')
```




    <seaborn.axisgrid.FacetGrid at 0x282513b1880>




    
![png](README_files/README_3_1.png)
    


**Zooming in on value that it settles at:**


```python
sns.relplot(dfp.filter(pl.col('time_ms') > 24), x='time_ms',y='error_signal')
```




    <seaborn.axisgrid.FacetGrid at 0x2825230ba40>




    
![png](README_files/README_5_1.png)
    



```python

```
