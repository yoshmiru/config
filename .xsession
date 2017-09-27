#!/usr/bin/env bash

xset -b
xscreensaver &
stalonetray &
xss-lock systemctl suspend  & 
nm-applet --sm-disable &
pasystray &

while true; do
  feh --recursive --randomize --bg-fill ~/.wallpaper 
  sleep 15m
done &


export XIM_PROGRAM="fcitx"
export XIM="fcitx"
export XIM_ARGS="-d"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export ECORE_IMF_MODULE="xim"
export XMODIFIERS="@im=fcitx"
fcitx &

#exec dbus-launch --exit-with-session enlightenment_start
#xsetroot -cursor_name left_ptr
exec startfluxbox
