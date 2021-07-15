# update-scripts

A collection of scripts for updating my favorite programming software

I use this to set up new machines, and also keep the software on current
development machine(s) up-to-date. I've considered using e.g. Ansible for this,
but all of these update scripts are simple bash scripts (which means I don't
need almost any of Ansible's modules) and I often only want to run one at a
time (which is possible but AFAICT un-idiomatic in Ansible). Thus, I have a
Makefile that delegates to several small scripts.

For most of these, the goal is to use latest release of the given software, so
typically these scripts scrape the currently-latest version (from e.g. GitHub)
and then either download a precompiled binary from a known mirror or download
and build the source at that version. Sometimes the scripts do other setup,
e.g. by creating the `docker` group and adding the current user to it.

### Todos:

- [x] Factor out "add this code to `bashrc` if it's not in there already". Currently this is accomplished via grep, but I could probably use edit distance to find near matches and print a warning, or at least reduce the current repetitiveness.
  - [x] Fix `update_go.sh`
  - [x] Fix `update_direnv.sh`
- [x] Factor out "fetch the latest release of `user/repo` from GitHub"
  - [x] Fix `update_minikube.sh` (though maybe not needed--`latest` seems to work? Release doesn't come from GitHub)
  - [ ] Fix `go_get_*`
