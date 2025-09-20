#!/bin/sh
killall conky
sleep 5s

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c time.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c date.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c cal.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c sys.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c net.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c hw.conf &

cd "$HOME/.config/conky/Sci_conky-main/"
conky -q -c weather.conf &

exit 0


