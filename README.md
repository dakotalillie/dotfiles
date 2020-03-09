# Dakota's Dotfiles

## Installation Instructions

Make sure you're on the latest versions of vim and tmux.
Make sure to back up your current dotfiles if you
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

