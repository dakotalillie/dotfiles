# Dakota's Dotfiles

## Installation Instructions

Make sure you're on the latest versions of neovim and tmux. Then make sure to
back up your current dotfiles if you have any, by running the following:

```bash
mv ~/.vimrc ~/.vimrc.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
mv ~/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json.bak
mv ~/vimwiki ~/vimwikibck
```

Navigate to the directory root for this repo. Then run:

```bash
ln -sf "$(pwd)/.vimrc" ~/.vimrc
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/coc-settings.json" ~/.config/nvim/coc-settings.json
ln -sf "$(pwd)/vimwiki" ~/vimwiki
```

This will create symbolic links to each of the files in your home directory. The
`-s` option makes the link symbolic, and the `-f` option ensures that the
symlink will overwrite any currently existing file, which should be fine so long
as you backed them up!

To make sure neovim is properly hooked up to your vim config, run the following
from inside neovim (taken from running `:help nvim-from-vim`):

```vim
:call mkdir(stdpath('config'), 'p')
:exe 'edit '.stdpath('config').'/init.vim'
```

Then add these contents to `init.vim`:

```vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
```

### Installing Vim plugins

You'll need to download Vim-Plug by following the instructions
[here](https://github.com/junegunn/vim-plug).

Open vim with:

```bash
vim ~/.vimrc
```

Then while inside vim, run:

```vim
:PlugInstall
```

This will install all of the plugins. Then run:

```vim
:so %
```

To re-source the .vimrc. You'll also need to install COC language extensions for
the languages you intend to use (the list can be found
[here](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions))

### Installing Tmux plugins

Follow the [instructions](ihttps://github.com/tmux-plugins/tpm) for installing
Tmux Plugin Manager.

Open a new tmux session by running:

```bash
tmux attach
```

Then press `prefix` + `I` to install all of the plugins.

### Additional Steps

You'll probably want to map your caps lock key to escape.

You may need to add this to your `.zshrc`:

```bash
export TERM=xterm-256color
```

You'll also want to install the silver surfer to speed up ctrl-p:

```bash
brew install the_silver_searcher
```

Install GNU-Grep to take advantage of Perl-compatible regular expressions:

```bash
brew install grep
```

And add this to your `.zshrc`:

```bash
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
```

Enable vi-mode by adding the plugin to your oh-my-zsh plugins in `.zshrc`:

```
plugins=(git vi-mode)
```

You can add italics to your terminal by following the instructions given
[here](https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be).
Most of the steps should already have been incorporated, but you will need to
create an `xterm-256color-italic.terminfo`:

```
xterm-256color-italic|xterm with 256 colors and italic,
  sitm=\E[3m, ritm=\E[23m,
  use=xterm-256color,
```

And `tmux-256color.terminfo`:

```
tmux-256color|tmux with 256 colors,
  ritm=\E[23m, rmso=\E[27m, sitm=\E[3m, smso=\E[7m, Ms@,
  khome=\E[1~, kend=\E[4~,
  use=xterm-256color, use=screen-256color,
```

And install them by running:

```bash
tic -x xterm-256color-italic.terminfo
tic -x tmux-256color.terminfo
```

In iTerm, you'll then need to go to Preferences > Profiles > Default, make sure
that Text > Italic text allowed is checked, and set Terminal > Report Terminal
Type to `xterm-256color-italic`

You can use vim for resolving git conflicts by running
`git config --global --edit` and adding the following:

```gitconfig
[merge]
    tool = vimdiff
[mergetool]
    keepBackup = false
    prompt = false
[mergetool "vimdiff"]
    cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
```

The markdown-preview plugin requires `yarn`. Make sure to install it with

```sh
brew install yarn
```

Previews for fzf require bat. Install with

```sh
brew install bat
```
