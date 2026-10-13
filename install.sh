#!/bin/sh
# Install the dwm, st and dmenu configuration into Portage and rebuild them.
# Run as root: doas sh install.sh
set -e
cd "$(dirname "$0")"
P=/etc/portage
install -d $P/savedconfig/x11-wm $P/savedconfig/x11-misc $P/savedconfig/x11-terms $P/patches/x11-wm/dwm
install -m644 portage/savedconfig/dwm-6.8   $P/savedconfig/x11-wm/dwm-6.8
install -m644 portage/savedconfig/dmenu-5.4 $P/savedconfig/x11-misc/dmenu-5.4
install -m644 portage/savedconfig/st-0.9.3  $P/savedconfig/x11-terms/st-0.9.3
install -m644 portage/patches/hide-vacant-tags.patch $P/patches/x11-wm/dwm/
install -m644 portage/package.use/dwm $P/package.use/dwm
emerge --oneshot x11-wm/dwm x11-misc/dmenu x11-terms/st
echo "Now copy session/xinitrc to ~/.xinitrc and session/Xresources to ~/.Xresources, then log in again."
