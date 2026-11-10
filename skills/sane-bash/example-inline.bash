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

exe false || true # allow non-zero exits
false || true     # allow non-zero exits (but no stdout output)
sleep 5           # try pressing CTRL-C
exe false         # this should fail and be trapped

# EXAMPLE SCRIPT OUTPUT
# editorconfig-checker-disable max-line-length

# ## `./example-inline.bash`

# ```text
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false

# bash: *** [command] "$@"
# bash: *** [./example-inline.bash:7 exe] Error 1
# bash: *** [./example-inline.bash:17 main]
# ```

# ## `./example-inline.bash` when interrupting with `CTRL-C`

# ```text
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# ^C
# ```

# ## `SHELLOPTS=xtrace ./example-inline.bash` or `V=1 ./example-inline.bash`

# ```text
# +(./example-inline.bash:14): exe false
# ++(./example-inline.bash:7): exe(): pwd
# ++(./example-inline.bash:7): exe(): printf '%q ' false
# +(./example-inline.bash:7): exe(): printf '%s\n' '/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false '
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# +(./example-inline.bash:7): exe(): false
# +(./example-inline.bash:14): true
# +(./example-inline.bash:15): false
# +(./example-inline.bash:15): true
# +(./example-inline.bash:16): sleep 5
# +(./example-inline.bash:17): exe false
# ++(./example-inline.bash:7): exe(): pwd
# ++(./example-inline.bash:7): exe(): printf '%q ' false
# +(./example-inline.bash:7): exe(): printf '%s\n' '/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false '
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# +(./example-inline.bash:7): exe(): false
# ++(./example-inline.bash:7): exe(): e=1
# ++(./example-inline.bash:7): exe(): set +x

# bash: *** [command] "$@"
# bash: *** [./example-inline.bash:7 exe] Error 1
# bash: *** [./example-inline.bash:17 main]
# ```
