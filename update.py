#!/usr/bin/env python3
import glob
import os
import sys

if len(sys.argv) > 1:
	home = sys.argv[1]

	if home.endswith("/"):
		home = home[0:-1]
else:
	home = os.path.expanduser("~")

print("Target directory is: {}".format(home))

print("Updating submodules...")
os.system("git submodule init")
print("\tgit submodule init")
os.system("git submodule update")
print("\tgit submodule update")

print("Updating dotfiles...")
for file in glob.glob("*"):
	if not(file.endswith(".py")):
		path = home + "/." + file
		print("\t{}".format(path))
		
		if os.path.lexists(path):
			os.remove(path)

		cmd = "ln -s {} {}".format(os.path.abspath(file), path)
		print("\t\t" + cmd)
		os.system(cmd)

# leave me alone!
print("Getting rid of history files...")

histfiles = [
	"lesshst", # why does my pager keep history...?
	"grails_history",
	"histfile",
	"mysql_history",
	"nano_history",
	"sqlite_history",
	"bash_history",
	"zsh_history"
]

for histfile in histfiles:
	path = home + "/." + histfile
	print("\t" + path)

	if os.path.exists(path):
		os.remove(path)

	cmd = "ln -s /dev/null {}".format(path)
	print("\t\t" + cmd)
	os.system(cmd)

# handle special cases
os.system("touch {}/.mutt/muttrc-local".format(home))
print("touch {}/.mutt/muttrc-local".format(home))
