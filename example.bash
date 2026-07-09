#!/usr/bin/env bash
# set -x # or env ${SHELLOPTS} has xtrace

{
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
    source "${DIR}/sane.bash"
}

# COPY-PASTE THE ABOVE TO YOUR BASH SCRIPT, AFTER YOU DOWNLOAD sane.bash

# EXAMPLE SCRIPT

exe "false || true" # allow non-zero exists
false || true       # allow non-zero exists (but no stdout output)
sleep 5             # try pressing CTRL-C
exe false           # this should fail and be trapped

# EXAMPLE SCRIPT OUTPUT
# editorconfig-checker-disable max-line-length

# ## `./example`

# ```text
# /Users/andrei/git/andreineculau/sane.bash$ false || true
# /Users/andrei/git/andreineculau/sane.bash$ false

# bash: *** [/Users/andrei/git/andreineculau/sane.bash/sane.bash:22 exe] Error 1
# bash: *** [./example:12 main]
# ```

# ## `./example` when interrupting with `CTRL-C`

# ```text
# /Users/andrei/git/andreineculau/sane.bash$ false || true
# ^C
# ```

# ## `SHELLOPTS=xtrace ./example` or `V=1 ./example`

# ```text
# +++ dirname ./example
# ++ cd .
# ++ pwd
# + DIR=/Users/andrei/git/andreineculau/sane.bash
# + source /Users/andrei/git/andreineculau/sane.bash/sane.bash
# ++ set -o errexit
# ++ set -o nounset
# ++ set -o pipefail
# ++ set -o errtrace
# ++ set -o functrace
# ++ ((  BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4)  ))
# ++ shopt -s inherit_errexit
# ++ export 'PS4=+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# ++ PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:18): trap 'e=$?; set +x; s() { local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): export -f exe
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:25): '[' -z '' ']'
# +(./example:8): exe 'false || true'
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): pwd
# +(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): eval '>&2 echo "/Users/andrei/git/andreineculau/sane.bash$ false || true"; false || true'
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): echo '/Users/andrei/git/andreineculau/sane.bash$ false || true'
# /Users/andrei/git/andreineculau/sane.bash$ false || true
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): false
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): true
# +(./example:9): false
# +(./example:9): true
# +(./example:11): sleep 5
# +(./example:12): exe false
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): pwd
# +(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): eval '>&2 echo "/Users/andrei/git/andreineculau/sane.bash$ false"; false'
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): echo '/Users/andrei/git/andreineculau/sane.bash$ false'
# /Users/andrei/git/andreineculau/sane.bash$ false
# ++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): false
# +++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): e=1
# +++(/Users/andrei/git/andreineculau/sane.bash/sane.bash:22): exe(): set +x

# bash: *** [/Users/andrei/git/andreineculau/sane.bash/sane.bash:22 exe] Error 1
# bash: *** [./example:12 main]
# ```
