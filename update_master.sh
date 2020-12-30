#!/bin/bash

BRANCH=$(curbr)

msg=$( git stash )

should_pop=true
if [[ "${msg}" =~ "No local changes to save" ]]; then
  should_pop=false
fi


git checkout master && git pull origin master && git checkout ${BRANCH}

if [[ "${should_pop}" == true ]]; then
  git stash pop
fi
