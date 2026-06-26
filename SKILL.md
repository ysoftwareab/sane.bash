---
name: sane-bash
description: >-
  sane.bash — the modern Bash strict-mode boilerplate, an evolution of
  `set -euo pipefail` that adds errtrace, functrace, inherit_errexit, a
  stack-trace-on-failure ERR trap, an `exe()` echo-and-run helper, and
  opt-in xtrace. Use when generating or hardening any 'safe bash' /
  'sane bash' script, production shell script, CLI wrapper, or CI/CD
  bash step that should fail fast with a readable stack trace. Triggers:
  'sane bash', 'sane.bash', 'safe bash script', 'bash strict mode',
  'set -euo pipefail', 'set -eEuo pipefail', 'errtrace', 'functrace',
  'inherit_errexit', 'stack trace on failure', 'bash boilerplate',
  'robust bash script', 'defensive bash'. Do NOT use for POSIX sh or
  non-Bash shells (relies on Bash 4.4+ features).
---

# sane.bash

A "sane bash" script is a Bash script that starts with the `sane.bash` header:
the classic unofficial Bash strict mode (`set -euo pipefail`) **plus** the modern
additions Bash grew over the years — `errtrace`, `functrace`, `inherit_errexit`,
a stack-trace-on-failure `ERR` trap, an `exe()` helper for logging handpicked
commands, and opt-in `xtrace`. The result: scripts that fail fast, never expand
unset variables, don't hide pipeline failures, and — when they do fail — print
the failing command and a caller stack trace instead of a mystery exit code.

Design philosophy: *"a little copying is better than a little dependency."*
The header is small enough to copy-paste, so you may either `source` `sane.bash`
or inline it. No runtime, no imports beyond the shell itself.

## When to use

Apply this skill whenever you are about to **generate or harden a Bash script**
that should be safe and diagnosable in production:

- A new CLI script, wrapper, or automation task in `#!/usr/bin/env bash`.
- A CI/CD bash step or a `make` recipe that deserves strict mode + a stack trace.
- Hardening an existing script that uses `set -e` alone or nothing at all.
- A user asks for a "safe bash script", "sane bash script", "strict-mode bash",
  "robust shell script", "bash boilerplate", or "fail-fast bash".
- You see `set -euo pipefail` and want to upgrade it to the full sane.bash form.

## When NOT to use

- **POSIX `sh`** / `dash` / `ash` — the header uses Bash 4.4+ features
  (`inherit_errexit`, `BASH_SOURCE`, `FUNCNAME`, `caller`). Use plain POSIX
  strict mode instead.
- **Non-Bash shells** (zsh, fish, ksh) — the trap and `shopt` are Bash-specific.
- **Sourced libraries that must stay side-effect-free** — the header sets
  shell options and traps globally; prefer the inline form only at the top of an
  executable entry script, not in a library that others `source`.

## The canonical header (copy-paste this)

These eight lines ARE `sane.bash`. Paste them verbatim at the top of any Bash
script — this is the inline form used by [`example-inline`](./example-inline)
and [`reference-sane.bash`](./reference-sane.bash):

```bash
#!/usr/bin/env bash
set -eEuo pipefail -o errtrace -o functrace
shopt -s inherit_errexit 2>/dev/null || true
export PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# shellcheck disable=SC2154
trap 'e=$?; set +x; s() { cmd="${BASH_COMMAND}"; >&2 echo "bash: *** [command] ${cmd}"; local i=0; while caller $i; do ((++i)); done | while read l f p; do echo "bash: *** [$p:$l $f]${e:+ Error }$e"; e=""; done; }; >&2 echo; >&2 s' ERR # editorconfig-checker-disable-line
function exe() { printf '%s\n' "$(pwd)\$ $(printf '%q ' "$@")" >&2 && "$@"; } && export -f exe
[[ -z "${VERBOSE:-${V:-}}" ]] || set -x
```

Do not "improve" this block: the `# shellcheck disable=SC2154` and the trailing
`# editorconfig-checker-disable-line` are load-bearing (the repo's `make check`
enforces both shellcheck and editorconfig-checker). Keep the long trap line on a
single physical line.

## Two ways to adopt

### 1. Inline / copy-paste (preferred for standalone scripts)

Paste the eight-line header above directly at the top of your script. No
dependency, no extra file. This is the approach `reference-sane.bash` champions.

### 2. Source mode (when you vendor `sane.bash`)

Download [`sane.bash`](./sane.bash) next to your script and source it. This is
the approach used by [`example`](./example):

```bash
#!/usr/bin/env bash
# set -x # or env ${SHELLOPTS} has xtrace

{
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
    source "${DIR}/sane.bash"
}
```

> Copy-paste the block above into your script *after* you download `sane.bash`.

## What each line does

| Line | Effect |
|------|--------|
| `set -eEuo pipefail` | `-e` errexit (exit on error), `-E` errtrace (functions inherit ERR trap), `-u` nounset (no unset vars), `-o pipefail` (a pipeline fails if any part fails). |
| `-o errtrace` | The `ERR` trap fires inside shell functions and subshells, not just at the top level. |
| `-o functrace` | `DEBUG`/`RETURN` traps are inherited by functions — needed for full trace context. |
| `shopt -s inherit_errexit 2>/dev/null \|\| true` | Subshells/command substitutions inherit `errexit` (Bash 4.4+). Guarded with `\|\| true` so older Bash doesn't error. |
| `export PS4='+(${BASH_SOURCE[0]}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'` | When `xtrace` is on, every traced line is prefixed with `file:line: func():` instead of bare `+`. |
| `trap '...' ERR` | **Stack trace on failure.** On any error: disable xtrace, print the failing command, then walk `caller` to print `bash: *** [file:line func] Error <code>` for each frame. |
| `function exe() { ... } && export -f exe` | Echoes `pwd$ <quoted-command>` to stderr, then runs the command. Exported so it survives subshells. |
| `[[ -z "${VERBOSE:-${V:-}}" ]] \|\| set -x` | Opt-in xtrace: enable tracing by setting `VERBOSE=1` or `V=1` (or putting `xtrace` in `SHELLOPTS`). |

## The `exe()` helper

`exe` logs a command to stderr (as a copy-pasteable `pwd$ ...` prompt line) and
then runs it. Use it for the handful of commands you want visible in logs:

```bash
exe make build          # logs "/path$ make build" then runs it
exe rm -rf -- "$tmp"    # logs the exact command before doing something destructive
```

Rules:

- Pass the command as **separate arguments** (`exe make build`), not as one
  quoted string. `exe` runs `"$@"`, so a single string like `exe "a || b"` would
  try to execute a binary literally named `a || b`.
- To **tolerate a non-zero exit**, don't wrap the whole thing in `exe` as a
  string. Use the plain short-circuit form instead:
  ```bash
  grep -q needle haystack || true   # allowed to "fail", no trap fires
  ```
- `exe` itself is exported (`export -f exe`) so it works inside command
  substitutions and subshells.

## Opt-in tracing

Tracing is off by default and on when the user asks for it:

```bash
V=1 ./your-script        # xtrace on
VERBOSE=1 ./your-script  # same
SHELLOPTS=xtrace ./your-script  # same
```

The `ERR` trap calls `set +x` first, so the stack trace is always readable even
when tracing was on.

## Reference template: argument parsing + help

For a real CLI, model your script on [`reference-sane.bash`](./reference-sane.bash).
It adds, **after** the canonical header:

1. **A version line** starting with `#-` and **usage/help lines** starting with
   `##`. Help/version are printed by grepping these comments out of the script
   itself — no duplicated usage string:
   ```bash
   #- reference-sane.bash 1.0
   ## Usage: reference-sane.bash
   ## Description placeholder
   ##
   ##   -h, --help     Display this help and exit
   ##   -v, --version  Output version information and exit
   ```
   Printed via `grep "^##" "${0}" | cut -c 4-` (help) and
   `grep "^#-" "${0}" | cut -c 4-` (version).

2. **An `on_exit` cleanup trap**:
   ```bash
   function on_exit() {
       :
   }
   trap on_exit EXIT
   ```

3. **`getopt`-based parsing** with `-h/--help` and `-v/--version`, falling back
   to printing help on bad input, and a `while [[ $# -gt 0 ]]` loop over the
   remaining positional args. Copy the parsing block verbatim from
   `reference-sane.bash` rather than reinventing it.

When generating a new CLI, start from `reference-sane.bash` and edit the
`##`/`#-` header and the body — keep the parsing skeleton intact.

## Generation checklist

When asked to produce a "safe/sane bash script", follow this order:

1. **Shebang**: `#!/usr/bin/env bash` (never `#!/bin/bash` — portability).
2. **Header**: paste the eight-line canonical header verbatim (inline form), or
   the source block if `sane.bash` is vendored alongside.
3. **Args**: if the script takes options, copy the `getopt` + `##`/`#-` help
   skeleton from `reference-sane.bash` and adapt the usage text.
4. **Cleanup**: add `on_exit` + `trap on_exit EXIT` if resources need releasing.
5. **Logging**: wrap the few commands worth seeing in `exe`; leave the rest bare.
6. **Expected failures**: use `cmd || true` / `cmd || exit 0` — never quote a
   compound into `exe`.
7. **Validate**: in this repo run `make check`; elsewhere run
   `shellcheck your-script` and `shfmt -d your-script` (the same tools the
   repo's `make check` uses).

## Working in THIS repo

If you are editing files inside `sane.bash` itself:

- **Validate via `make`, never invoke linters directly.** The repo's
  [`Makefile`](./Makefile) wires editorconfig-checker, markdownlint, shellcheck,
  and shfmt into a single entrypoint:
  - `make check` — lint + format (this is the gate; run it after any edit).
  - `make test` — tests.
  - `make all` — build.
  - `make clean` — remove generated files.
- **File map** (all four `*.bash` files are the same code in different shapes):
  - [`sane.bash`](./sane.bash) — the file you `source`.
  - [`docs-sane.bash`](./docs-sane.bash) — same code, inline-documented.
  - [`reference-sane.bash`](./reference-sane.bash) — same code + arg parsing, the
    copy-paste CLI template.
  - [`example`](./example) / [`example-inline`](./example-inline) — usage demos
    for the source and inline forms respectively.
- Keep the four `.bash` files in sync: a change to the header belongs in all of
  them. The header lines must stay byte-identical (including the
  `# editorconfig-checker-disable-line` and `# shellcheck disable=SC2154`
  comments).
