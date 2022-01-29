#!/usr/bin/env zsh

# Get last 100 merge commits
IFS=$'\n' merges=($(git log --pretty='format:%s' --merges -100))
# Get local branches
IFS=$'\n' branches=($(git branch))

echo "Delete:"

branches_to_remove=()

for branch in $branches;
do
  # Trim whitespace
  branch=${branch// /}

  # Skip master and current branch
  if [[ $branch == 'master' || $branch =~ "\*" ]]; then
    continue
  fi

  vared -p "  $branch (y/N): " -c user_input
  if [[ $user_input == 'y' ]]; then
    branches_to_remove+=($branch)
  fi

  user_input=""
done

if [ -z "$branches_to_remove" ]; then
  echo "\nNothing to do."; exit
fi

echo "\nWill delete:"
for branch in $branches_to_remove; do
  echo "* $branch"
done

echo
user_input=""
vared -p "Continue? (y/N): " -c user_input

if [[ $user_input == 'y' ]]; then
  for branch in $branches_to_remove; do
    git branch -D $branch
  done
fi
