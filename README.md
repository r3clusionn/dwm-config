# dwm-config

The whole dwm setup of one Gentoo laptop: dwm 6.8 with its `config.h` and one patch, the matching st and dmenu configs, and the `.xinitrc`, `.Xresources` and login hook that start it. It is made for one laptop (HP OmniBook 7, Ryzen AI 9 HX 475, 2880x1800 at 2x scale, no desktop environment), where the keys also run the [scripts](https://github.com/r3clusionn/scripts) for volume, backlight, Bluetooth and audio, and the bar text comes from [dwmstat](https://github.com/r3clusionn/dwmstat). Everything is plain Portage `savedconfig` and `/etc/portage/patches`, so nothing is a fork: the stock ebuilds build it.

**Status:** in daily use on the target laptop since October 2026.

![The dwm bar at 2x scale, on a dark background, left and right ends: tag "1" selected and tag "2" with a window on it, the tiled layout symbol "[]=", then at the right "⚙ auto:perf  ☀ 100%  ♪ off  Ƀ off  ⇅ on  ⚡99%+  Mon 12 Oct 21:06", meaning the power plan following the charger and now on performance, backlight 100%, audio off, Bluetooth off, Wi-Fi connected, battery at 99% and charging, and the date and time. The window title in the middle is cut out.](docs/images/bar.png)

## Features

- **dwm 6.8** with a grey bar (`#222222` / `#444444`, no blue), 1 px borders, 9 tags, `Alt` as the modifier, and a 120 Hz limit on move and resize redraws.
- **Hide-vacant-tags patch** (`portage/patches/hide-vacant-tags.patch`): the bar shows only tags that have a window or are selected, and clicks still hit the right tag. The window title is drawn in the normal colours instead of highlighted.
- **Keys added to the defaults:**

  | Key | Action |
  |---|---|
  | `Alt+F` | focused window fullscreen and back (stock dwm only does it when the program asks) |
  | `Alt+Shift+F` | floating layout |
  | `Alt+W` | browser (Thorium) |
  | `Alt+Shift+S` | region screenshot to the clipboard (`hacksaw` and `shotgun`, Esc cancels) |
  | volume, mute, mic mute keys | `vol`, which starts PipeWire first and tells the bar |
  | brightness keys | `bl +5` / `bl -5` |
  | `F1` (HP "display switch", sends `Super+P`) | `bt-toggle` |
  | `F2` (smiley key, sends `Super+Ctrl+Alt+Shift+Space`) | `audio toggle` |

  Everything else is stock dwm (`Alt+Shift+Return` terminal, `Alt+P` dmenu, `Alt+1..9` tags, `Alt+Shift+Q` quit).
- **st and dmenu** `savedconfig`s with the same font (`monospace`) and colours: st at size 11, dmenu with the bar's grey instead of dwm's default blue selection.
- **`xinitrc`:** merges `.Xresources`, sets a 48 px cursor and silences the accessibility bus, forks a session D-Bus daemon instead of keeping a `dbus-run-session` parent, starts `dwmstat`, and `exec`s dwm.
- **`Xresources`:** `Xft.dpi: 192` and the cursor theme and size, for the 2x screen.
- **`bash_profile-snippet`:** on tty1 the login shell becomes `xinit` (no resident `startx`, no auth cookie, TCP off), after killing old session buses.

## How to install

Requires Gentoo with Portage, `doas` or root, and the packages the keys call: `hacksaw`, `shotgun`, `xclip`, and the [scripts](https://github.com/r3clusionn/scripts) (`vol`, `bl`, `bt-toggle`, `audio`) and [dwmstat](https://github.com/r3clusionn/dwmstat) in your `PATH`.

```sh
git clone https://github.com/r3clusionn/dwm-config
cd dwm-config
doas sh install.sh                          # savedconfig, patch, USE flags, rebuild dwm, dmenu, st
cp session/xinitrc ~/.xinitrc
cp session/Xresources ~/.Xresources
cat session/bash_profile-snippet >> ~/.bash_profile    # optional: start X on tty1
```

Log in again to start the new dwm. Other distributions can apply `hide-vacant-tags.patch` to a dwm 6.8 tree and copy `portage/savedconfig/dwm-6.8` over `config.h`.

## How to use

- Edit `portage/savedconfig/dwm-6.8`, then `doas sh install.sh` to rebuild. Because of `USE=savedconfig` Portage uses that file as `config.h`.
- Change `col_cyan` (the selected tag and border colour) to bring colour back; `#005577` is dwm's default blue.
- The browser path in `browsercmd` is absolute (`/home/rec/.local/bin/thorium`); change it to your own.
- To restart dwm with new settings, quit with `Alt+Shift+Q`: `.xinitrc` ends with `exec dwm`, so that ends the X session.

## How it works

- **savedconfig:** `package.use/dwm` turns the `savedconfig` USE flag on for dwm, st and dmenu. The ebuilds copy `/etc/portage/savedconfig/<category>/<name>-<version>` to `config.h` before compiling, and save it back when it is missing.
- **Patch:** user patches in `/etc/portage/patches/x11-wm/dwm/` are applied by the ebuild with `eapply_user`. The patch changes `drawbar` and `buttonpress` in `dwm.c` to skip tags that are neither occupied nor selected, in the same way in both so the click position matches what is drawn.
- **Fullscreen:** `togglefullscr` is a three-line function in `config.h` that calls dwm's own `setfullscreen`.
- **Session:** `xinit` runs `.xinitrc` on `vt1`; when the script ends (dwm quits) X ends and the login shell, which `exec`ed `xinit`, goes with it.

## Verification

- The files in `portage/` are copies of what is installed on the laptop and what its dwm 6.8 was built from (`/etc/portage/savedconfig`, `/etc/portage/patches`, `/etc/portage/package.use/dwm`).
- The screenshot was taken from the running session with `shotgun`, and shows the patch at work (only tags 1 and 2 are drawn).
- `install.sh` was not re-run from a fresh clone for this repo; it does what the files on the laptop already show.

## Limits

- Gentoo only as written; the rest is plain dwm.
- Made for a 2x screen: the font sizes and the DPI in `Xresources` are for it.
- The key bindings for F1 and F2 depend on what this laptop's keyboard sends.
- The `Firefox` and `Gimp` rules in `config.h` are dwm's defaults and are unused.

## License

MIT (see `LICENSE`). dwm, st and dmenu are by suckless.org (MIT/X); the config files here are derived from their `config.def.h`.
