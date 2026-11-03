#!/usr/bin/env python3
import time
start = time.monotonic()
import subprocess
import urllib.request
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
PROG_DIR = ROOT_DIR / ".prog"

APT_LIST = ["timidity", "frescobaldi", "python3-pip", "python3-venv", "python3-tk", "snapd", "musescore"]
PIP_LIST = ["customtkinter", "gitpython"]
SNAP_LIST = ["code --classic", "obsidian --classic"]
LILYPOND_URL = "https://gitlab.com/lilypond/lilypond/-/releases/v2.26.0/downloads/lilypond-2.26.0-linux-x86_64.tar.gz"
LY2VIDEO_URL = "git@github.com:StephaneKergall/ly2video.git"


def run(*args):
    subprocess.run(args, check=True)


def download(url: str, destination: Path):
    def report_progress(block_count, block_size, total_size):
        downloaded = block_count * block_size
        percent = min(downloaded * 100 // total_size, 100) if total_size > 0 else 0
        print(f"\r{destination.name} : {percent}%", end="", flush=True)

    urllib.request.urlretrieve(url, destination, reporthook=report_progress)
    print()


# apt
run("sudo", "apt", "update")
run("sudo", "apt", "install", "-y", *APT_LIST)
# lilypond désinstallé car téléchargé depuis le site officiel pour avoir la dernière version
run("sudo", "apt", "remove", "-y", "lilypond", "tex-common")
run("sudo", "apt", "autoremove", "-y")
print()

# pip
run("python3", "-m", "pip", "install", *PIP_LIST, "--break-system-packages")
print()

#snap
for package in SNAP_LIST:
    run("sudo", "snap", "install", *package.split())

# lilypond web
lilypond_archive = PROG_DIR / "lilypond-2.26.0-linux-x86_64.tar.gz"
download(LILYPOND_URL, lilypond_archive)
run("tar", "-xzf", str(lilypond_archive), "-C", str(PROG_DIR))
lilypond_archive.unlink()
lilypond_ly_dir = PROG_DIR / "lilypond-2.26.0" / "share" / "lilypond" / "2.26.0" / "ly"
for util_file in (ROOT_DIR / ".utils").iterdir():
    run("cp", str(util_file), str(lilypond_ly_dir))

# ly2video
ly2video_dir = PROG_DIR / "ly2video"
if not ly2video_dir.exists():
    run("git", "clone", LY2VIDEO_URL, str(ly2video_dir))
ly2video_venv = ly2video_dir / ".venv"
if not ly2video_venv.exists():
    run("python3", "-m", "venv", str(ly2video_venv))
ly2video_python = ly2video_venv / "bin" / "python"
run(str(ly2video_python), "-m", "pip", "install", "--upgrade", "pip")
run(str(ly2video_python), "-m", "pip", "install", "--editable", str(ly2video_dir))

# bashrc
print("Configuration...")
updater_alias = "alias updater='sudo apt update && sudo apt full-upgrade -y && sudo snap refresh && sudo flatpak update -y'\n"
lilypond_alias = f"alias lilypond='{PROG_DIR / 'lilypond-2.26.0' / 'bin' / 'lilypond'}'\n"
bashrc_path = Path.home() / ".bashrc"
with open(bashrc_path, "a") as bashrc:
    for alias in [updater_alias, lilypond_alias]:
        if alias not in bashrc_path.read_text():
            bashrc.write(alias)

# Git
run("git", "config", "--global", "user.name", "Stéphane Kergall")
run("git", "config", "--global", "user.email", "stef.kergall@gmail.com")
run("git", "config", "--global", "pull.rebase", "false")
print()

# Fin
print(f"Installation terminée en {time.monotonic() - start:.2f} secondes.")
