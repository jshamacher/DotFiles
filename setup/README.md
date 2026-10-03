# Host setup

Define hosts in `hosts/<hostname>`, then run:

```bash
./install [HOST]
./install --list [HOST]
./install --dry-run [HOST]
```

Omit `HOST` to use the current hostname. `--list` summarizes the resolved
configuration; `--dry-run` prints the commands without running installation or
configuration actions. When both flags are supplied, `--list` takes precedence.

Host files are Bash files defining arrays:

- `PACKAGE_SETS`: package lists under `packages/`, installed with pacman.
- `EXTRA_COMMANDS`: shell commands for software installed outside pacman.
- `CONFIG_SETS`: executable scripts under `config/`.
- `AUR_PACKAGES`: currently displayed only; AUR installation is deferred.

Installation runs package sets first, then extra commands in their declared
order, then configuration scripts. Omitted arrays default to empty.

## Extra commands

For example, if you keep a local package and an installer script in the setup
directory, a host can declare:

```bash
EXTRA_COMMANDS=(
    'sudo pacman -U ./downloads/zoom.pkg.tar.zst'
    'bash ./scripts/install-tool'
)
```

Use single quotes around command strings so variable expansion and command
substitution happen when the command runs, rather than when the host file is
read. Pipelines, redirects, and other Bash syntax work inside each entry.
`--list` and `--dry-run` display these strings without evaluating them.

Each entry runs in a separate `bash -euo pipefail` shell with the setup directory
as its working directory. A failed command or pipeline stops installation before
later entries or configuration scripts run. Shell state such as `cd`, variables,
and exports does not carry over between entries. Commands run as the invoking
user; include `sudo` where required. Extra commands run on every installation, so
use the installer's own repeat-safe options or an explicit check when necessary.

Composed host files can append commands with `EXTRA_COMMANDS+=('...')`, just as
they can append package and configuration sets. Keep host files declarative:
they are sourced in every mode, so put installation actions in the arrays rather
than executing them directly in the host file.
