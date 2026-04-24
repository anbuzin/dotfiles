# dotfiles

## non-brew clis

### rustup

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### lat.md

```sh
cd ~/path/to/lat.md && npm link
```

### vercel cli

for dev do alias in `zshrc`:

```bash
alias vc='node ~/path/to/vercel/packages/cli/dist/vc.js'
```

for non-dev, do:

```bash
npm i -g vercel
```
