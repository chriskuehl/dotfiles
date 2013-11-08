#!/usr/bin/env python
# alternative updater using python 2
import glob, os

os.system("git submodule init")
print "git submodule init"
os.system("git submodule update")
print "git submodule update"

for file in glob.glob("*"):
	if not(file.endswith(".py")):
		cmd = "ln -s {0} ~/.{1}".format(os.path.abspath(file), file)
		print cmd
		os.system(cmd)
