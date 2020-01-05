#!/bin/sh

userresources=$HOME/.config/.Xresources
usermodmap=$HOME/.config/.Xmodmap
userbindkeys=$HOME/.config/.Xbindkeysrc
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

feh --bg-scale ~/Pictures/bg.jpg
if [ -f "$userbindkeys" ]; then
    xbindkeys --file "$userbindkeys"
fi
redshift -O3500

dte(){
    dte="$(date +"🕒 %m/%d %l:%M%p")"
    echo "$dte"
}

mem(){
    mem=`free | awk '/Mem/ {printf "%d/%d Mi\n", $3 / 1024.0, $2 / 1024.0 }'`
    echo "🖪 $mem"
}

cpu(){
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    echo "💻 $cpu%"
}

bat(){
    battery_path=/sys/class/power_supply/BAT1
    echo "🔋 $(cat $battery_path/capacity)%"
}

while true; do
    xsetroot -name " $(cpu) | $(mem) | $(bat) | $(dte)"
    sleep 7s
done &

export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
wmname LG3D

exec dwm

fcitx i&
