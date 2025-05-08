import os
import shutil
from pathlib import Path

copy_to_dir = Path(r'C:\prog\repos\PID_temperature_controller')
copy_from_dir = r'C:\prog\fpga\PID_temp_controller\PID_temp_controller.srcs'
for root, dirs, files in os.walk(copy_from_dir):
	for file in files:
		if file.endswith('.vhd'):
			path = Path(root) / file
			shutil.copy2(path, copy_to_dir)
			
