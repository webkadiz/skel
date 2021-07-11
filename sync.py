import os

files = open("skel")

for file in files:
    file = file.strip()
    path = os.path.expanduser("~/" + file)
    skelpath = os.getcwd() + "/" + file
    dirname = os.path.dirname(skelpath) 

    os.system(f"rm -rf '{skelpath}'")
    os.system(f"mkdir -p '{dirname}'")

    if os.path.isdir(path):
        command = f"cp -a '{path}' '{skelpath}'"
        print(command)
        os.system(command)
    else: 
        command = f"cp -a '{path}' '{skelpath}'"
        print(command)
        os.system(command)

