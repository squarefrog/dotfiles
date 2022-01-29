#!/usr/bin/env zsh

################################################################################
# Clean merged local branches
#
# This script fetches the local branch names and checks to see if they have
# been merged into `master`.
#
###############################################################################

###############################################################################
# Set maximum number of merge commits to check. Increase this if you have
# ancient branches.
###############################################################################

max_merges=100

###############################################################################
# No need to change anything below
###############################################################################

IFS=$'\n' merges=($(git log --pretty='format:%s' --merges -$max_merges))
IFS=$'\n' branches=($(git branch))

branches_to_remove=()
unmerged_branches=()

for branch in $branches; do
  # Trim whitespace
  branch=${branch// /}

  # Skip master and current branch
  if [[ $branch == "master" || $branch =~ "\*" ]]; then
    continue
  fi

  if [[ $merges =~ $branch ]]; then
    branches_to_remove+=($branch)
  else
    unmerged_branches+=($branch)
  fi
done

if [ -z "$branches_to_remove" ]; then
  echo "\nNothing to do."; exit
fi

echo "\nWill delete:"
for branch in $branches_to_remove; do
  echo "* $branch"
done

echo
vared -p "Continue? (y/N): " -c user_input

if [[ $user_input == 'y' ]]; then
  for branch in $branches_to_remove; do
    git branch -D $branch
  done
  echo "Deleted ${#branches_to_remove[@]} branches. 🎉"
fi

if [ -n "$unmerged_branches" ]; then
  echo "\nUnmerged branches: "
  for branch in $unmerged_branches; do
    echo "* $branch"
  done
fi

