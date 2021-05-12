#! /bin/bash

# Bash arrays : get stdout, stderr and exitcode altogether.


FIRST_CI_PUSH_STDOUT=`git push origin main:first-ci-passed --porcelain 2>&1`
FIRST_CI_PUSH_STATUS=$?
echo "==> command exit code: $FIRST_CI_PUSH_STDOUT"
echo $FIRST_CI_PUSH_STATUS
  # Could be an error or a success
if [ $FIRST_CI_PUSH_STATUS -eq 0 ]; then
  if [[ "$FIRST_CI_PUSH_STDOUT" == *'[up to date]'* ]]; then
    # Other CI already passed
    echo '==> The other CI already pushed, carrying with a push to releases...'
    RELEASES_PUSH_STDOUT=$(git push origin main:releases --porcelain 2>1)
    RELEASES_PUSH_STATUS=$?
    echo $RELEASES_PUSH_STDOUT
    echo "==> command exit code: $RELEASES_PUSH_STATUS"
    if  [ $RELEASES_PUSH_STATUS -eq 0 ]; then
      echo '==> Successfully pushed to releases'
      exit 0;
    else
      echo '==> Could not push to "releases" branch, probably because CI ran faster on a more recent commit.'
      exit 0;
    fi
  else
    # Success, do nothing, the other CI will push to releases.
    echo "Successfully pushed to first-ci-build."
    exit 0;
  fi
else
  # Error, cannot push, means another branch was faster at pushing, fail silently.
  echo '==> Could not push to "first-ci-passed" branch, probably because CI ran faster on a more recent commit.'
  exit 0;
fi




