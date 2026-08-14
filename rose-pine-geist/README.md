# rose-pine-geist

[Rose Pine](https://rosepinetheme.com) accents on [Geist](https://vercel.com/geist/colors)
dark neutrals, layered catppuccin-style: secondary surfaces recede *below* the
editor (Geist background-200 under background-100), interactive states rise
above it. All neutrals are exact Geist dark values; all accents and text tones
are stock Rose Pine (main).

`palette.toml` is the single source of truth. Everything generated:

```sh
uv run build.py
```

Generated targets: `nvim/lua/rose-pine-geist/palette.lua`, `ghostty/themes/`,
`zsh/` (highlighting + prompt vars), `obsidian/` (code-block CSS snippet).
Hand-written: `nvim/colors/rose-pine-geist.lua` (thin wrapper over
`rose-pine/neovim`'s documented palette override — all highlight-group
mappings come from upstream).

## Palette

| Role | Hex | Geist token | Used for |
|---|---|---|---|
| `nc`, `surface` | `#000000` | background-200 | floats, Pmenu, statusline (below editor) |
| `base` | `#0a0a0a` | background-100 | editor / terminal background |
| `highlight_low` | `#1a1a1a` | gray-100 | subtle backgrounds |
| `overlay` | `#1f1f1f` | gray-200 | cursorline, PmenuSel |
| `highlight_med` | `#2e2e2e` | gray-400 | word-highlight, terminal selection |
| `highlight_high` | `#454545` | gray-500 | borders, cursor accents |
| `muted` | `#6e6a86` | Rose Pine | comments |
| `subtle` | `#908caa` | Rose Pine | punctuation, operators |
| `text` | `#e0def4` | Rose Pine | foreground, variables |
| `love` `#eb6f92` `gold` `#f6c177` `rose` `#ebbcba` `pine` `#31748f` `foam` `#9ccfd8` `iris` `#c4a7e7` `leaf` `#95b1ac` | | Rose Pine | accents |

Superseded neutral ramps (Vesper/Geist mix, Geist-flat) are kept as comment
blocks in `palette.toml` for A/B flips.

Notes: nvim `Visual` is upstream's iris @ 15% blend (a Rose Pine signature),
not `highlight_med`; ghostty ANSI 0 = `overlay` (upstream Rose Pine's role
for ANSI black) — `surface` receded to true black, which would leave ANSI-0
panels invisible on `base`.

## Install

On a new machine: run the dotfiles `install.sh` (links everything below),
launch nvim once so `vim.pack` clones `rose-pine/neovim`, then
`./install-obsidian.sh [vault-path]` and enable the snippet once in
Settings → Appearance → CSS snippets (re-run the script after regenerating).
Generated files are committed, so `uv` is only needed for tweaking. Details:

- **nvim**: `rose-pine/neovim` via `vim.pack.add`; this plugin symlinked:
  `~/.local/share/nvim/site/pack/themes/start/rose-pine-geist → <repo>/nvim`;
  `vim.cmd.colorscheme("rose-pine-geist")` in init.lua.
- **ghostty**: `config/ghostty/themes/rose-pine-geist` (symlink into repo),
  `theme = rose-pine-geist` in the config. Reload: cmd+shift+comma.
- **zsh**: `zshrc` sources `zsh/rose-pine-geist-prompt.zsh` (exports `$RPG_*`
  vars, used by `PS1`) and `zsh/rose-pine-geist-highlighting.zsh` (must load
  before zsh-syntax-highlighting).
- **obsidian**: `obsidian/rose-pine-geist-code.css` copied to
  `~/vaults/main/.obsidian/snippets/`, enabled in Settings → Appearance →
  CSS snippets. Overrides `--code-*` vars in dark mode only. Re-copy after
  regenerating.

## Tweaking

Edit `palette.toml`, run `uv run build.py`, then `:colorscheme
rose-pine-geist` in nvim (the wrapper busts lua caches), cmd+shift+comma in
ghostty, `source ~/.zshrc` for the shell. `:Inspect` shows the highlight
group under the cursor. Surgical per-group overrides go in
`highlight_groups` in `nvim/colors/rose-pine-geist.lua`.
