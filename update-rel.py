#!/usr/bin/env python3
import glob
import os

os.system("git submodule init")
print("git submodule init")
os.system("git submodule update")
print("git submodule update")

for file in glob.glob("*"):
	if not(file.endswith(".py")):
		cmd = "ln -s {} ~/.{}".format(os.path.abspath(file), file)
		print(cmd)
		os.system(cmd)
