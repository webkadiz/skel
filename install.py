import os

files = open("skel")

for file in files:
    file = file.strip()
    path = os.path.expanduser("~/" + file)
    dirname = os.path.dirname(path) 

    os.system(f"mkdir -p '{dirname}'")

    if os.path.isdir(path):
        command = f"cp -a '{file}' '{path}'"
        print(command)
        os.system(command)
    else: 
        command = f"cp -a '{file}' '{path}'"
        print(command)
        os.system(command)

