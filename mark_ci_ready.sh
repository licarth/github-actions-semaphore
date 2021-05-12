#! /bin/bash

# Bash arrays : get stdout, stderr and exitcode altogether.
remote_repo="https://ci:${GITHUB_TOKEN}@github.com/licarth/github-actions-semaphore.git"

FIRST_CI_PUSH_STDOUT=`git push "${remote_repo}" HEAD:first-ci-passed --porcelain 2>&1`
FIRST_CI_PUSH_STATUS=$?
echo "==> command exit code: $FIRST_CI_PUSH_STDOUT"
echo $FIRST_CI_PUSH_STATUS
  # Could be an error or a success
if [ $FIRST_CI_PUSH_STATUS -eq 0 ]; then
  if [[ "$FIRST_CI_PUSH_STDOUT" == *'[up to date]'* ]]; then
    # Other CI already passed
    echo '==> The other CI already pushed, carrying with a push to releases...'
    RELEASES_PUSH_STDOUT=$(git push "${remote_repo}" HEAD:releases --porcelain 2>&1)
    RELEASES_PUSH_STATUS=$?
    echo $RELEASES_PUSH_STDOUT
    echo "==> command exit code: $RELEASES_PUSH_STATUS"
    if  [ $RELEASES_PUSH_STATUS -eq 0 ]; then
      if [[ "$RELEASES_PUSH_STDOUT" == *'[up to date]'* ]]; then
        echo '==> WARNING: No deployment will get triggered! releases branch was already up-to-date.'
      else
        echo '==> Successfully pushed to releases'
      fi
        exit 0;
    else
      if [[ "$FIRST_CI_PUSH_STDOUT" == *'[rejected] (non-fast-forward)'* ]]; then
        echo '==> Could not push to "releases" branch, probably because CI ran faster on a more recent commit.'
        exit 0;
      else
        echo '==> Unknown error!'
        exit 1;
      fi
    fi
  else
    # Success, do nothing, the other CI will push to releases.
    echo "Successfully pushed to first-ci-build."
    exit 0;
  fi
else
  if [[ "$FIRST_CI_PUSH_STDOUT" == *'[rejected] (non-fast-forward)'* ]]; then
    echo '==> Could not push to "first-ci-passed" branch, probably because CI ran faster on a more recent commit.'
    exit 0;
  else
    echo '==> Unknown error!'
    exit 1;
  fi
fi




