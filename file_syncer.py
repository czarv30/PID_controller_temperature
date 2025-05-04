import os

def list_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            print(os.path.join(root, file))

# Get current directory and list all files
current_dir = os.getcwd()
print(current_dir)
list_files(current_dir)
