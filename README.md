# sane.bash

For the future "you" 🫵 to keep on enjoying GNU Bash.

## Why sane.bash

For many decades now,
we've had [an unofficial Bash strict mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
([Reddit](https://www.reddit.com/r/programming/comments/25y6yt/use_the_unofficial_bash_strict_mode_unless_you/)),
essentially `set -euo pipefail`.

Except GNU Bash evolved - `errtrace` `functrace` `inherit_errexit`
and then there's one last thing (tm): `stack trace on failure`.

[sane.bash](./sane.bash) wraps all that up in a script to import (source)
or simply copy-paste since [a little copying is better than a little dependency](https://go-proverbs.github.io) .

[docs-sane.bash](./docs-sane.bahs) is the same code but with inline documentation.

[reference-sane.bash](./reference-sane.bash) is the same code,
minus the documentation, compact, adding argument parsing,\
acting as a full reference/template for a copy-paste approach instead of sourcing.

## Usage

Have a look at the [example](./example) and [example-inline](./example-inline) for usage and docs.

## bash mentions

*   https://github.com/alexanderepstein/Bash-Snippets
*   https://github.com/Bash-it/bash-it
*   https://github.com/basherpm/basher
*   https://github.com/bats-core/bats-core
*   https://github.com/koalaman/shellcheck
*   https://github.com/mvdan/sh
*   https://github.com/pforret/bashew
*   Misc
    *   https://github.com/topics/bash
    *   https://www.reddit.com/r/bash/comments/z09oiu/comment/ix642tx/

## License

[MIT](LICENSE)
