#!/bin/bash

cmd='export LOCKPRG=true'
desc='LOCKPRG export (prevent screen from locking)'
add_to_file "${cmd}" "${desc}" "${HOME}/.bashrc"

# Set command key to C-o instead of the default C-a (which conflicts with bash
# and emacs, where C-a means "jump to beginning of the line")
touch ${HOME}/.screenrc
grep -q "escape ^Oo" ${HOME}/.screenrc || echo 'escape ^Oo' >>${HOME}/.screenrc

# I don't totally remember what this does anymore, but I think it makes it
# impossible to lock screen (which I don't know how to escape from)
grep -q "bind x" ${HOME}/.screenrc || echo 'bind x' >>${HOME}/.screenrc
