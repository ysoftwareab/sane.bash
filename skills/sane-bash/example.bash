#!/usr/bin/env bash
# set -x # or env ${SHELLOPTS} has xtrace

{
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
    # shellcheck source=/dev/null
    source "${DIR}/sane.bash"
}

# COPY-PASTE THE ABOVE TO YOUR BASH SCRIPT, AFTER YOU DOWNLOAD sane.bash

# EXAMPLE SCRIPT

exe false || true # allow non-zero exits
false || true     # allow non-zero exits (but no stdout output)
sleep 5           # try pressing CTRL-C
exe false         # this should fail and be trapped

# EXAMPLE SCRIPT OUTPUT
# editorconfig-checker-disable max-line-length

# ## `./example.bash`

# ```text
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false

# bash: *** [command] "$@"
# bash: *** [/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8 exe] Error 1
# bash: *** [./example.bash:17 main]
# ```

# ## `./example.bash` when interrupting with `CTRL-C`

# ```text
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# ^C
# ```

# ## `SHELLOPTS=xtrace ./example.bash` or `V=1 ./example.bash`

# ```text
# +(./example.bash:14): exe false
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): pwd
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): printf '%q ' false
# +(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): printf '%s\n' '/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false '
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# +(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): false
# +(./example.bash:14): true
# +(./example.bash:15): false
# +(./example.bash:15): true
# +(./example.bash:16): sleep 5
# +(./example.bash:17): exe false
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): pwd
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): printf '%q ' false
# +(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): printf '%s\n' '/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false '
# /Users/andrei/git/andreineculau/sane.bash/skills/sane-bash$ false
# +(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): false
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): e=1
# ++(/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8): exe(): set +x

# bash: *** [command] "$@"
# bash: *** [/Users/andrei/git/andreineculau/sane.bash/skills/sane-bash/sane.bash:8 exe] Error 1
# bash: *** [./example.bash:17 main]
# ```
