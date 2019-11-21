#!/usr/bin/env bash

#######################################################################
#                          string examples                            #
#######################################################################

function test_heredoc() {
  local data=$(
    cat <<HEREDOC
{
  "k1": "v1",
  "k2": "v2"
}
HEREDOC
  )

  echo ${data}
}

function test_heredoc_escape() {
  local value="val"
  local data=$(
    cat <<HEREDOC
hello \"${value}\"
HEREDOC
  )
  echo ${data}
}

test_heredoc_escape
