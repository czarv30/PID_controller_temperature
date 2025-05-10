import os
import shutil
from pathlib import Path
import subprocess

exclusions = ['plant.vhd']
additions =[]

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

# Now run the process to update the ReadMe file.
command = [
	"python",
	"-m",                   
	"nbconvert",            
	"--to", "markdown",     
	'README.ipynb',         
	"--output", 
	'README.md' 
]
result = subprocess.run(command, check=True, capture_output=True, text=True)
if result.stdout:
	print("nbconvert output:\n", result.stdout)
if result.stderr: # nbconvert sometimes puts informational messages in stderr
    print("nbconvert messages (stderr):\n", result.stderr)
