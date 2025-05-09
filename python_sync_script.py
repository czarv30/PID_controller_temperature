import os
import shutil
from pathlib import Path

exclusions = ['plant.vhd']
additions = [r'C:\Users\Comanche\Dropbox\documents\jupyter_notebooks\README.ipynb']

# First copy the vhd files of interest. 
copy_to_dir = Path(r'C:\prog\repos\PID_temperature_controller')
copy_from_dir = r'C:\prog\fpga\PID_temp_controller\PID_temp_controller.srcs'
for root, dirs, files in os.walk(copy_from_dir):
	for file in files:
		if file.endswith('.vhd') and file not in exclusions:
			path = Path(root) / file
			shutil.copy2(path, copy_to_dir)

# Now copy the additions
for file in additions:
	if os.path.exists(file):
		shutil.copy2(file, copy_to_dir)
	else:
		print(f"File {file} does not exist.")
