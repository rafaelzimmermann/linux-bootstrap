# Linux Bootstrap

Scripts to set up and configure a Linux environment. Supports **Arch Linux** and **Debian-based** distributions.

> This project was created primarily for personal use. Feel free to use it, but do so at your own risk.

## Quick Start

```bash
git clone https://github.com/rafaelzimmermann/linux-bootstrap.git
cd linux-bootstrap
./bootstrap        # full desktop setup
# or
./bootstrap-server # minimal headless server setup
```

You will be prompted for your sudo password once at the start.

## Bootstrap Scripts

### `bootstrap`
Full desktop environment setup. Installs:
- Core tools: `vim`, `htop`, `tmux`, `git`, `zsh`, `jq`, `curl`, `python`, `ruby`
- [Oh My Zsh](https://ohmyz.sh/) + sets zsh as default shell
- Rust (via rustup)
- Java
- Neovim + [NvChad](https://nvchad.com/)
- Nerd Fonts + Font Awesome (Arch)
- yay AUR helper (Arch only)
- Dotfiles from `.config/`

### `bootstrap-server`
Minimal headless setup. Installs `vim`, `htop`, `tmux`, `git`, `zsh`, `jq`, `curl`, Oh My Zsh, and Neovim. Also disables sleep/suspend/hibernate.

## Install Scripts

| Script | What it installs |
|--------|-----------------|
| `install-docker` | Docker + Docker Compose, adds user to `docker` group, enables services |
| `install-gcli` | Google Cloud CLI |
| `install-go` | Go toolchain |
| `install-java` | Java (JDK) |
| `install-lazygit` | Lazygit TUI for git |
| `install-nvim` | Neovim + NvChad config |
| `install-nerdfonts` | Nerd Fonts (cloned + built from source) + Font Awesome on Arch |
| `install-ohmyzsh` | Oh My Zsh |
| `install-rust` | Rust via rustup |
| `install-vscode` | Visual Studio Code |
| `install-xmrig` | XMRig (built from source) |
| `install-yay` | yay AUR helper (Arch only) |

Run any script individually:

```bash
./install-docker
./install-go
```

## Config Scripts

Config scripts deploy dotfiles to their expected locations under `~/.config/`.

| Script | Deploys |
|--------|---------|
| `config-ghostty` | `~/.config/ghostty/` |
| `config-python` | virtualenv + virtualenvwrapper setup in `~/.zshrc` |
| `config-tmux` | `~/.tmux.conf` + TPM plugin manager |
| `config-waybar` | `~/.config/waybar/` (auto-detects wireplumber vs pulseaudio) |

## Utilities

### `backup-homedir`
Backs up a user's home directory via rsync, excluding paths listed in `config/rsync-homedir-local.txt`.

```bash
./backup-homedir <username> <destination>
```

## Supported Distributions

| Distribution | Status |
|---|---|
| Arch Linux | Supported |
| Debian / Ubuntu | Supported |

Package installation is abstracted in `lib/pkg.sh` — `pkg_install`, `pkg_update`, and `aur_install` route to the correct package manager automatically.
