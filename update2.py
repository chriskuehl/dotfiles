#!/usr/bin/env python
from __future__ import print_function

import glob
import os
import sys


def eexec(cmd, depth=0):
    print(("\t" * depth) +  cmd)
    os.system(cmd)


if len(sys.argv) > 1:
    home = sys.argv[1]

    if home.endswith("/"):
        home = home[0:-1]
else:
    home = os.path.expanduser("~")

use_rel_link = len(sys.argv) > 2

print("Target directory is: {0}".format(home))

print("Updating submodules...")
eexec("git submodule sync", 1)
eexec("git submodule update --init", 1)

ocf = os.path.exists(home + "/.ocf")
rackspace = os.path.exists(home + "/.rackspace")
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

        print("\t{0}".format(path))

        if os.path.lexists(path):
            os.remove(path)

        from_path = (".dotfiles/" + file) if use_rel_link else os.path.abspath(file)
        eexec("ln -s {0} {1}".format(from_path, path), 2)

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

    eexec("ln -s /dev/null {0}".format(path), 2)

# handle special cases
eexec("touch {0}/.mutt/muttrc-local".format(home))
eexec("touch {0}/.tmux-local.conf".format(home))

# are we on ocf?
if ocf:
    eexec("rm {}/.gitconfig".format(home))
    eexec("ln -s {0}/.gitconfig-ocf {1}/.gitconfig".format(home, home))

# are we on rackspace?
if rackspace:
    eexec("rm {0}/.gitconfig".format(home))
    eexec("ln -s {0}/.gitconfig-rackspace {1}/.gitconfig".format(home, home))

# are we on cs61b?
if cs61b:
    eexec("rm {0}/.shell-custom".format(home))
    eexec("ln -s {0}/.shell-custom-61b {1}/.shell-custom".format(home, home))
