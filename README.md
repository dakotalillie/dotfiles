# Dakota's Dotfiles

## Installation Instructions

Make sure you're on the latest versions of neovim and tmux.
Then make sure to back up your current dotfiles if you
have any, by running the following:

```bash
mv ~/.vimrc ~/.vimrc.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
```

Navigate to the directory root for this repo. Then run:

```bash
ln -sf "$(pwd)/.vimrc" ~/.vimrc
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf
```

This will create symbolic links to each of the files in your
home directory. The `-s` option makes the link symbolic, and
the `-f` option ensures that the symlink will overwrite any
currently existing file, which should be fine so long as you
backed them up!

To make sure neovim is properly hooked up to your vim config,
run the following from inside neovim (taken from running
`:help nvim-from-vim`):

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

To re-source the .vimrc. You'll also need to install
COC language extensions for the languages you intend to
use (the list can be found [here](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions))

### Installing Tmux plugins

Follow the [instructions](ihttps://github.com/tmux-plugins/tpm)
for installing Tmux Plugin Manager.

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

