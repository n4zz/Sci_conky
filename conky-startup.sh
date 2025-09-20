#!/bin/sh
killall conky
sleep 5s


cd "$HOME/.config/conky/robust2/"
conky -q -c time.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c date.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c cal.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c sys.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c net.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c hw.conf &

cd "$HOME/.config/conky/robust2/"
conky -q -c weather.conf &

exit 1


