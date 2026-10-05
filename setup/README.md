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

- `PACKAGE_SETS`: Bash files under `packages/` declaring repository and AUR packages.
- `PACKAGES`: additional repository packages, installed with pacman.
- `AUR_PACKAGES`: additional AUR packages, installed with an AUR helper.
- `AUR_HELPER`: helper executable (defaults to `yay`; can also be set in the environment).
- `EXTRA_COMMANDS`: shell commands for software installed outside pacman.
- `CONFIG_SETS`: executable scripts under `config/`.

Installation runs repository packages first, then AUR packages, then extra
commands in their declared order, then configuration scripts. Omitted arrays
default to empty.

## Package sets

Each package set appends to `PACKAGES` and/or `AUR_PACKAGES`. For example,
`packages/media` contains:

```bash
PACKAGES+=(
    electron41
)

AUR_PACKAGES+=(
    plexamp-bin
)
```

The common profile includes `media`, so both hosts receive these packages.
Package sets are sourced in every mode, just like host files; keep them
declarative and use `+=` to preserve packages from other sets and the host.

Repository packages use `sudo pacman -S --needed`. AUR packages use
`yay -S --aur --needed` as the invoking user, with the helper's normal interactive
prompts. Install the helper before running setup (see the
[yay installation instructions](https://github.com/Jguer/yay#installation)).
For another compatible helper, set `AUR_HELPER=paru` in the host file or run
`AUR_HELPER=paru ./install HOST`. If AUR packages are selected, a missing helper
or running as root stops setup before any installation actions.
`--list` and `--dry-run` work without an installed helper.

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
