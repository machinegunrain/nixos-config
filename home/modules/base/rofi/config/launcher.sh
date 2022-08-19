#!/usr/bin/env bash

## Author  : Manita Talcharus
## Mail    : manita.tcrs@pm.me
## Github  : @mekter
## Mastodon : @dash@mastodon.in.th


theme="style_nord-light.rasi"

dir="$HOME/.config/rofi/launchers/text"
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="${styles[$(( $RANDOM % 10 ))]}"

rofi -no-lazy-grab -show run \
-modi run,drun \
-theme $dir/"$theme"
