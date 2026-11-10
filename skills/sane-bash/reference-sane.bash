#!/usr/bin/env bash
set -eEuo pipefail -o errtrace -o functrace
shopt -s inherit_errexit 2>/dev/null || true
export PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# shellcheck disable=SC2154
trap 'e=$?; set +x; s() { cmd="${BASH_COMMAND}"; >&2 echo "bash: *** [command] ${cmd}"; local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR # editorconfig-checker-disable-line
# shellcheck disable=SC2329
function exe() { printf '%s\n' "$(pwd)\$ $(printf '%q ' "$@")" >&2 && "$@"; } && export -f exe
[[ -z "${VERBOSE:-${V:-}}" ]] || set -x

#- reference-sane.bash 1.0
## Usage: reference-sane.bash
## Description placeholder
##
##   -h, --help     Display this help and exit
##   -v, --version  Output version information and exit

function on_exit() {
    :
}
trap on_exit EXIT

if { getopt --test >/dev/null 2>&1 && false; } || [[ "$?" = "4" ]] || false; then
    ARGS=$(getopt -o hv -l help,version \
        -n "$(basename "${BASH_SOURCE[0]}")" -- "$@") \
        || {
            grep "^##" "${0}" | cut -c 4-
            exit 1
        }
    eval set -- "${ARGS}"
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            grep "^##" "${0}" | cut -c 4-
            exit 0
            ;;
        -v | --version)
            grep "^#-" "${0}" | cut -c 4-
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            grep "^##" "${0}" | cut -c 4-
            exit 1
            ;;
        *)
            break
            ;;
    esac
done
[[ $# -eq 0 ]] || {
    grep "^##" "${0}" | cut -c 4-
    exit 1
}
