#!/usr/bin/env bash

clean()
{
  REMOTES="$@";
  if [ -z "$REMOTES" ]; then
    REMOTES=$(git remote);
  fi
  REMOTES=$(echo "$REMOTES" | xargs -n1 echo)
  RBRANCHES=()
  while read REMOTE; do
    CURRBRANCHES=($(git ls-remote $REMOTE | awk '{print $2}' | grep 'refs/heads/' | sed 's:refs/heads/::'))
    RBRANCHES=("${CURRBRANCHES[@]}" "${RBRANCHES[@]}")
  done < <(echo "$REMOTES" )
  [[ $RBRANCHES ]] || exit
  LBRANCHES=($(git branch | sed 's:\*::' | awk '{print $1}'))
  for i in "${LBRANCHES[@]}"; do
    skip=
    for j in "${RBRANCHES[@]}"; do
      [[ $i == $j ]] && { skip=1; echo -e "\033[32m Keeping $i \033[0m"; break; }
    done
    [[ -n $skip ]] || { echo -e "\033[31m $(git branch -D $i) \033[0m"; }
  done
}

clean $@