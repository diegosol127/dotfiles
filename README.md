# Dependencies

Make sure you have homebrew installed. Paste the following code into a Linux shell prompt.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

With Homebrew, you can install many tools that will be used in the development environment we want to work with. A good list to get started with includes the following installations.

```bash
brew install chezmoi zsh fzf gcc neovim starship tmux eza
```

# Chezmoi

Chezmoi is a dotfile manager that works with GitHub (or other version control systems) under the hood. It uses a *source directory*, `~/.local/share/chezmoi`, as the clone of your dotfiles repo. For more information, visit the [Chezmoi User Guide](https://www.chezmoi.io/user-guide/command-overview/). To get set up, first make sure you have Chezmoi installed (use the above Homebrew installation command).

Clone dotfiles from GitHub into the source directory, then update the the dotfiles on your home directory (local machine).

```bash
chezmoi init --apply https://github.com/diegosol127/dotfiles
```

Add a file to the source repository. If it already exists, the source state is replaced with the current state of the file in the home (destination) directory.

```bash
chezmoi add <file>
```

Edit a dotfile directly in the source directory. Add the flag, ```--apply```, to immediately apply the changes to the home directory (local machine).

```bash
chezmoi edit <file>
```

To pull remote changes and immediately apply them locally.
```bash
chezmoi update
```

Pull the latest changes from the remote repository and see what would change, without actually applyng the changes.

```bash
chezmoi git pull -- --autostash --rebase && chezmoi diff
```

If you're happy with the changes, apply them.

```bash
chezmoi apply
```

# Zsh

Once zsh has been installed and is on the system path, make it the default shell.

```bash
echo /home/linuxbrew/.linuxbrew/bin/zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

Since you likely are originally running these commands from a `bash` shell, you will need to open a `zsh` instance to apply all settings. You can do this by closing the terminal and reopening (since `zsh` should now be configured to be the default shell) or by simply running `zsh`.

# Tmux

The `prefix` key for this configuration is `Ctrl-Space`. Below are some useful commands to remember.

Source tmux configuration.

```bash
prefix + R
```

Source zsh configuration in current pane.

```bash
prefix + r
```

Save tmux environment.

```bash
prefix + Ctrl-s
```

Restore tmux environment.

```bash
prefix + Ctrl-r
```
