# config


#pre - commit hook
#--------------------
#!/usr/bin/env bash

golangci-lint run

returncode=$?
if [ $returncode -ne 0 ]; then
  echo "go check failed"
  exit 1
fi
#--------------------------
