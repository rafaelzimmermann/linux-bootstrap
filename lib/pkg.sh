#!/bin/bash

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        export OS="${ID}"
    else
        echo "Cannot detect OS: /etc/os-release not found" >&2
        exit 1
    fi
}

pkg_update() {
    case "$OS" in
        arch) sudo pacman -Syu --noconfirm ;;
        *)    sudo apt update ;;
    esac
}

pkg_install() {
    case "$OS" in
        arch) sudo pacman -S --noconfirm --needed "$@" ;;
        *)    sudo apt install -y "$@" ;;
    esac
}

aur_install() {
    yay -S --noconfirm "$@"
}

detect_os
