#!/usr/bin/env bash
set -eEuo pipefail -o errtrace -o functrace
shopt -s inherit_errexit 2>/dev/null || true
export PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# shellcheck disable=SC2154
trap 'e=$?; set +x; s() { cmd="${BASH_COMMAND}"; >&2 echo "bash: *** [command] ${cmd}"; local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR # editorconfig-checker-disable-line
function exe() { printf '%s\n' "$(pwd)\$ $(printf '%q ' "$@")" >&2 && "$@"; } && export -f exe
[[ -z "${VERBOSE:-${V:-}}" ]] || set -x

# COPY-PASTE THE ABOVE TO YOUR BASH SCRIPT, RATHER THAN KEEP A COPY AND SOURCE sane.bash

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

# bash: *** [./example-inline:8 exe] Error 1
# bash: *** [./example-inline:19 main]
# ```

# ## `./example` when interrupting with `CTRL-C`

# ```text
# /Users/andrei/git/andreineculau/sane.bash$ false || true
# ^C
# ```

# ## `SHELLOPTS=xtrace ./example` or `V=1 ./example`

# ```text
# + set -eEuo pipefail
# + ((  BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4)  ))
# + shopt -s inherit_errexit
# + export 'PS4=+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# + PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# +(./example-inline:6): trap 'e=$?; set +x; s() { local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR
# +(./example-inline:9): '[' -z '' ']'
# +(./example-inline:15): exe 'false || true'
# ++(./example-inline:8): exe(): pwd
# +(./example-inline:8): exe(): eval '>&2 echo "/Users/andrei/git/andreineculau/sane.bash$ false || true"; false || true'
# ++(./example-inline:8): exe(): echo '/Users/andrei/git/andreineculau/sane.bash$ false || true'
# /Users/andrei/git/andreineculau/sane.bash$ false || true
# ++(./example-inline:8): exe(): false
# ++(./example-inline:8): exe(): true
# +(./example-inline:16): false
# +(./example-inline:16): true
# +(./example-inline:18): sleep 5
# +(./example-inline:19): exe false
# ++(./example-inline:8): exe(): pwd
# +(./example-inline:8): exe(): eval '>&2 echo "/Users/andrei/git/andreineculau/sane.bash$ false"; false'
# ++(./example-inline:8): exe(): echo '/Users/andrei/git/andreineculau/sane.bash$ false'
# /Users/andrei/git/andreineculau/sane.bash$ false
# ++(./example-inline:8): exe(): false
# +++(./example-inline:8): exe(): e=1
# +++(./example-inline:8): exe(): set +x

# bash: *** [./example-inline:8 exe] Error 1
# bash: *** [./example-inline:19 main]
# ```
