# dotfiles

These are my dotfiles. It's here so that I don't lose any of my setups when switching to a new machine, but you are welcome to use any and all of the stuff included.

## Prerequisites

### Operating system

This will set up NEARLY identical systems on macOS and debian-flavored Linux distros. YMMV as far as any other distros.

## Setup

Got all that? Great. Run this install script. It will do the following:

### If your operating system is macOS, it will:

- set your shell to zsh
- install [Homebrew](http://brew.sh) if you don't already have it, or run `brew update` if you do
- install [Homebrew Cask](https://caskroom.github.io/) (again, if you already have it, this won't do anything)
- install programs that I deem absolutely necessary
- clone this repo into  `~/github/.dotfiles`

Ready to get started?? Just paste this into your terminal. **WARNING:** Please make sure you have read through the setup script so you understand what this is doing before executing this.

```Shell
curl -L https://raw.githubusercontent.com/patrickjmcd/dotfiles/master/setup.sh | /bin/bash
```

## Updating

As you make changes to the files, you can push those changes so your configs will never be lost. If you are running this to keep multiple machines in sync, you can just pull this repo down on other machines after pushing changes. Since all the files are symlinked, you won't have to re-run any scripts unless you create new files that also need to be linked.

## Credit

Much credit is due to [@mmcbride1007](https://github.com/mmcbride1007) for his [dotfiles](https://github.com/mmcbride1007/dotfiles) repo, which I've basically ripped off. Thank you, Mike! (AMDG)
