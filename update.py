#!/usr/bin/env python3
import glob
import os
import sys


def exec(cmd, depth = 0):
	print(("\t" * depth) +  cmd)
	os.system(cmd)


if len(sys.argv) > 1:
	home = sys.argv[1]

	if home.endswith("/"):
		home = home[0:-1]
else:
	home = os.path.expanduser("~")

use_rel_link = len(sys.argv) > 2

print("Target directory is: {}".format(home))

print("Updating submodules...")
exec("git submodule sync", 1)
exec("git submodule update --init", 1)

ocf = os.path.exists(home + "/.ocf")
cs61b = os.path.exists(home + "/.61b")

special_cases = {
	"terminalrc": ".config/Terminal/terminalrc"
}

print("Updating dotfiles...")
for file in glob.glob("*"):
	if not file.endswith(".py") and not file == 'scripts':
		path = home + "/." + file

		if file in special_cases:
			path = home + "/" + special_cases[file]
			path_dir = os.path.dirname(path)

			# make directories if necessary
			if not os.path.exists(path_dir):
				os.makedirs(path_dir)

		print("\t{}".format(path))

		if os.path.lexists(path):
			os.remove(path)

		from_path = (".dotfiles/" + file) if use_rel_link else os.path.abspath(file)
		exec("ln -s {} {}".format(from_path, path), 2)

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

	exec("ln -s /dev/null {}".format(path), 2)

# handle special cases
exec("touch {}/.mutt/muttrc-local".format(home))
exec("touch {}/.tmux-local.conf".format(home))

# are we on ocf?
if ocf:
	exec("rm {}/.gitconfig".format(home))
	exec("ln -s {}/.gitconfig-ocf {}/.gitconfig".format(home, home))

# are we on cs61b?
if cs61b:
	exec("rm {}/.shell-custom".format(home))
	exec("ln -s {}/.shell-custom-61b {}/.shell-custom".format(home, home))
