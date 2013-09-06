#!/usr/bin/env python3
import glob
import os

for file in glob.glob("*"):
	if not(file.endswith(".py")):
		cmd = "ln -s {} ~/.{}".format(os.path.abspath(file), file)
		print(cmd)
		os.system(cmd)
