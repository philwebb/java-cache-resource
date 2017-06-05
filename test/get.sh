#!/bin/bash
set -e

source $(dirname $0)/helpers.sh

# tests

it_needs_folders_to_run() {
  local dest=$TMPDIR/destination
  result=0
  jq -n "{
    source: {
    }
  }" | ${resource_dir}/in $dest | tee /dev/stderr || result=$?
  if [ $result -eq 0 ]; then
    echo "in script accepted empty folders"
    exit 1;
  fi
}

it_needs_source_folder_to_run() {
  local dest=$TMPDIR/destination
  result=0
  jq -n "{
    source: {
      folders: [
        {
          destination: \"foo\"
        }
      ]
    }
  }" | ${resource_dir}/in $dest | tee /dev/stderr || result=$?
  if [ $result -eq 0 ]; then
    echo "in script accepted empty folders"
    exit 1;
  fi
}

it_needs_destination_folder_to_run() {
  local dest=$TMPDIR/destination
  result=0
  jq -n "{
    source: {
      folders: [
        {
          source: \"foo\"
        }
      ]
    }
  }" | ${resource_dir}/in $dest | tee /dev/stderr || result=$?
  if [ $result -eq 0 ]; then
    echo "in script accepted empty folders"
    exit 1;
  fi
}


it_needs_commands_to_run() {
  local dest=$TMPDIR/destination
  result=0
  jq -n "{
    source: {
      folders: [
        {
          \"source\" : \"foo\",
          \"destination\" : \"bar\"
        }
      ]
    }
  }" | ${resource_dir}/in $dest | tee /dev/stderr || result=$?
  if [ $result -eq 0 ]; then
    echo "in script accepted empty commands"
    exit 1;
  fi
}

it_runs_the_commands() {
  local repo=$(init_repo)
  mkdir -p $repo/a/b
  local ref=$(make_commit_to_file $repo file)
  local dest=$TMPDIR/destination
  local sourcecache=$TMPDIR/source/cache
  result=0
  jq -n "{
    source: {
      uri: \"${repo}\",
      folders: [
        {
          \"source\" : \"${sourcecache}\",
          \"destination\" : \"destcache\"
        }
      ],
      commands: [\"touch ${sourcecache}/file\"]
    }
  }" | ${resource_dir}/in ${dest} | tee /dev/stderr | jq -e "
      .version == {ref: $(echo $ref | jq -R .)}"
  test "$(git -C $repo rev-parse HEAD)" = $ref
  if [ ! -f $TMPDIR/destination/destcache/file ]; then
    echo "$TMPDIR/destination/destcache/file does not exist"
    exit;
  fi
}

# helpers

# test suite

run it_needs_folders_to_run
run it_needs_source_folder_to_run
run it_needs_destination_folder_to_run
run it_needs_commands_to_run
run it_runs_the_commands
