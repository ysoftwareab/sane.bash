---
name: sane-bash-extended
description: >-
  Extension of sane-bash with explicit style and flow-control conventions for
  consistency, readability, and strict-mode-friendly Bash.
---

# sane-bash-extended

This skill inherits sane-bash and adds opinionated Bash style conventions.

## Inheritance

Base skill: sane-bash

All sane-bash rules still apply. The rules below are additive.

If sane-bash is missing, not installed, or cannot be resolved by name, this
extended skill must be ignored entirely (no partial application).

## Extended style rules

1.  Variable naming is uppercase-only, including local variables.
    *   Use `FOO`, `LOCAL_TMP`, `ARGS`.
    *   Avoid lowercase or mixed-case variable names unless required by an
        external interface.
    *   Declare function-local variables with the `local` keyword so they do
        not leak into the global scope: `local FOO=bar`.
1.  Function declarations use the explicit form
    `function foo_bar_qux() { ... }`.
    *   Do not omit the `function` keyword.
    *   Do not use `foo_bar_qux() { ... }` without `function` in this style
        profile.
    *   Function names must be lowercase snake_case, for example
        `foo_bar_qux`.
    *   Avoid uppercase, kebab-case, and camelCase for function names.
1.  Variable references always use braces: `${FOO}`.
    *   Prefer `${FOO}` over `$FOO`, even when unambiguous.
    *   Apply consistently in strings, tests, assignments, and command args.
1.  Prefer bouncer-style flow for single-branch guards.
    *   Prefer `[[ CONDITION ]] || COMMAND` over a multi-line single-branch `if`
        when no `else` branch is needed.
    *   Use `if` when the logic needs `else`, has multiple steps, or the negative
        guard would become harder to read.
1.  Use `[[ ... ]]` for tests and conditionals; avoid `[`.
1.  Keep argument parsing deterministic:
    *   Prefer `getopt` + `case` for option handling.
    *   Guard against non-enhanced (BSD) `getopt` with `getopt --test` before
        relying on it; on macOS the default `getopt` silently mangles args
        containing spaces. For simple one-letter options, prefer the `getopts`
        builtin instead.
    *   Handle `--` explicitly and reject unexpected extra args.
1.  Keep help/version text in script comments and print from source
    (`##` for help, `#-` for version) to avoid duplicate strings.
1.  Keep an explicit `on_exit` handler (`function on_exit() { ... }`) and
    attach `trap on_exit EXIT` early — before any resource allocation — so
    cleanup actually fires if a later step fails. Start as a no-op and grow it
    as resources are acquired.
1.  Try to quote all expansions in command arguments.
    *   Prefer `"${FOO}"` over bare `${FOO}` in command args, strings,
        tests, and assignments.
    *   Corner cases apply: arithmetic contexts (`((++i))`), intentionally
        word-splitting expansions (`caller $i`), and the regex on the right of
        `[[ ... =~ ... ]]` are left unquoted on purpose.
    *   Exception: the canonical `sane.bash` header (see the base skill) is
        byte-frozen and exempt from this rule; do not "fix" its unquoted
        expansions.
1.  Keep strict-mode-friendly short-circuit patterns explicit:
    Expected failure: `COMMAND || true`
    Validation bouncer: `[[ CONDITION ]] || { ...; exit 1; }`
    Error-and-die: `COMMAND || { echo "msg" >&2; exit 1; }`
1.  Always use `IFS= read -r` for `read`.
    *   Set `IFS=` so leading/trailing whitespace is preserved.
    *   Use `-r` so backslashes are literal (not escape sequences).
    *   Canonical loop: `while IFS= read -r LINE; do ...; done < file`.
1.  Pass `--` to destructive commands to stop option injection.
    *   `rm -rf -- "${DIR}"`, `find -- "${DIR}"`, `mv -- "${SRC}" "${DST}"`.
    *   Matters when a path operand may start with `-`.
1.  Define functions and variables before invocation.
    *   Order definitions top-to-bottom so each name exists before it is
        called; the script should read in execution order.
    *   Example:

        ```bash
        function foo() { ...; }
        function bar() { ...; foo; ... }
        bar
        ```

    *   `foo` is defined before `bar` calls it; `bar` is defined before the
        top-level invocation. Avoid hoisting reliance and forward references.

## Formatting rules

Apply these formatting defaults when generating or editing bash files:
`*.sh`, `*.bash`, `*.bats`, scripts with a bash shebang, and bash snippets
embedded in `Makefile` or `*.mk`. These are fallback defaults — use them only
when no other settings apply: a project `.editorconfig` or `.shfmtconf`, or
agent/IDE instructions for the target project take precedence.

Validate generated or edited bash files with the three tools below. If a tool
is not installed in the current environment, skip it silently — do not block
the task on a missing linter.

1.  validate with ShellCheck

1.  validate with shfmt

    Run shfmt with these flags:

    ```bash
    shfmt --binary-next-line --case-indent --indent 4
    ```

    Flag-to-behavior mapping:

    *   `--binary-next-line` — binary operators (`&&`, `||`, `|`) wrap to the
        next line.
    *   `--case-indent` — case patterns are indented (in addition to their
        bodies).
    *   `--indent 4` — 4-space indentation.

1.  validate with editorconfig-checker

    The following `.editorconfig` values are the fallback defaults this skill
    enforces; a project `.editorconfig` overrides them for files in that
    project:

    *   `charset = utf-8`
    *   `end_of_line = lf`
    *   `indent_size = 4`
    *   `indent_style = space`
    *   `insert_final_newline = true`
    *   `trim_trailing_whitespace = true`

## Notes

These conventions intentionally prioritize consistency and scanability over
minimal typing.
