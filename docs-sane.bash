#!/usr/bin/env bash

# SOURCE sane.bash WITH
# { DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"; source "${DIR}/sane.bash"; }

# http://linuxcommand.org/lc3_man_pages/seth.html
set -o errexit                               # error exits script
set -o nounset                               # no unset variables
set -o pipefail                              # failure on any command errors
set -o errtrace                              # shell functions inherit ERR trap
set -o functrace                             # shell functions inherit DEBUG trap
shopt -s inherit_errexit 2>/dev/null || true # inherit errexit
# xtrace context
export PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Show stack trace on error
# shellcheck disable=SC2034,SC2154
trap 'e=$?; set +x; s() { cmd="${BASH_COMMAND}"; >&2 echo "bash: *** [command] ${cmd}"; local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR # editorconfig-checker-disable-line

# Helper function for logging handpicked commands before executing them
# shellcheck disable=SC2329
function exe() { printf '%s\n' "$(pwd)\$ $(printf '%q ' "$@")" >&2 && "$@"; } && export -f exe

# Enable xtrace if $VERBOSE/$V is non-null
[[ -z "${VERBOSE:-${V:-}}" ]] || set -x
