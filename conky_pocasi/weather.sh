#!/bin/bash

########################################################
# KONFIGURACE
########################################################
# UNITY   = f pro Fahrenheit, c pro Celsius nebo k pro Kelvin
# API_KEY = Bezplatná registrace na https://openweathermap.org
#           pro získání vašeho API klíče
# CITY    = Název vašeho města
# COUNTRY = Zkratka vaší země: us, ru, br, cz atd.
# zdroj : http://github.com/luizfnunes
########################################################

UNITY="c"  # Jednotka teploty, výchozí je Celsius
API_KEY="fda5d52eb41f63b6db4534d35a50c613"  # Váš API klíč
CITY="Ústí nad Labem"  # Název města
COUNTRY="cz"  # Kód země

########################################################
# KONTROLA ZÁVISLOSTÍ
########################################################
# Ověříme, že jsou nainstalovány potřebné nástroje

dependencies=(curl jq)
for cmd in "${dependencies[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Závislost $cmd nebyla nalezena. Prosím nainstalujte ji."
    exit 1
  fi
done

########################################################
# ZPRACOVÁNÍ JEDNOTEK
########################################################
# Převod vstupní jednotky na formát pro API
case $UNITY in
  "k") UNITY="default" ;;  # Kelvin jako výchozí hodnota
  "c") UNITY="metric" ;;   # Celsius v metrickém systému
  "f") UNITY="imperial" ;; # Fahrenheit v imperiálním systému
  *) UNITY="default" ;;     # Výchozí Kelvin pro neplatný vstup
esac

########################################################
# NAČTENÍ DAT O POČASÍ
########################################################
# Převede název města do URL formátu (nahrazení mezer za %20)
CITY=$(echo $CITY | sed -e 's/ /%20/g')
url="http://api.openweathermap.org/data/2.5/weather?APPID=$API_KEY&q=$CITY,$COUNTRY&units=$UNITY"

# Načteme data z API
# Pokud API nevrátí data, ukončíme skript s chybovou zprávou
data=$(curl -s "$url")
if [ -z "$data" ]; then
  echo "Chyba připojení nebo prázdná odpověď z API."
  exit 1
fi

########################################################
# PARSOVÁNÍ DAT O POČASÍ
########################################################
# Používáme jq k extrakci potřebných informací z JSON odpovědi
city=$(echo "$data" | jq -r '.name')
country=$(echo "$data" | jq -r '.sys.country')
temp=$(echo "$data" | jq -r '.main.temp')
feels_like=$(echo "$data" | jq -r '.main.feels_like')
description=$(echo "$data" | jq -r '.weather[0].description')
rain=$(echo "$data" | jq -r '.rain["1h"]')
snow=$(echo "$data" | jq -r '.snow["1h"]')
temp_min=$(echo "$data" | jq -r '.main.temp_min')
temp_max=$(echo "$data" | jq -r '.main.temp_max')
humidity=$(echo "$data" | jq -r '.main.humidity')
pressure=$(echo "$data" | jq -r '.main.pressure')
wind=$(echo "$data" | jq -r '.wind.speed')
visibility=$(echo "$data" | jq -r '.visibility')
# Převedení visibility na kilometry (API vrací v metrech)
visibility_km=$(echo "scale=1; $visibility / 1000" | bc -l)
update=$(date +"%d-%m-%Y  %H:%M")  # Zaznamenání času poslední aktualizace

# Inicializace srážek na 0
precipitation="0"

# Pokud snow není null, použijeme jeho hodnotu

if [[ "$rain" != "null" ]];
then
  precipitation="$rain"
fi

if [[ "$snow" != "null" ]];
then
  precipitation="$snow"
fi

if [[ "$snow" != "null" ]] && [[ "$rain" != "null" ]];
then
  precipitation=$(echo "$rain + $snow" | bc -l)
fi

# Oprava formátu výstupu – zajištění dvou desetinných míst a české desetinné čárky
#precipitation=$(printf "%.2f" "$precipitation")


########################################################
# ULOŽENÍ DAT DO MEZIPAMĚTI
########################################################
# Ukládáme data do mezipaměti pro použití v Conky
touch ~/.cache/weather2.txt
echo -e "city>$city\ncountry>$country\ntemp>$temp\nfeels_like>$feels_like\nrain>$rain\nsnow>$snow\nprecipitation>$precipitation\ndescription>$description\nmin>$temp_min\nmax>$temp_max\nhumidity>$humidity\npressure>$pressure\nwind>$wind\nvisibility_km >$visibility_km\nupdate>$update" > ~/.cache/weather2.txt

########################################################
# ZPRACOVÁNÍ IKON POČASÍ
########################################################
# Definujeme mapu pro popisy počasí a odpovídající ikony

declare -A weather_icons=(
  ["clear sky"]="jasno_n1.png"
  ["few clouds"]="polojasno_n1.png"
  ["scattered clouds"]="oblacno_n1.png"
  ["broken clouds"]="oblacno_n1.png"
  ["overcast clouds"]="zatazeno1.png"
  ["light rain"]="slaby_dest1.png"
  ["rain"]="dest1.png"
  ["heavy intensity rain"]="prutrz.png"
  ["thunderstorm"]="bourka1.png"
  ["mist"]="mlha1.png"
  ["rain and snow"]="dest_snih1.png"
  ["light snow"]="snezeni1.png"
  ["snow"]="snow1.png"
)

# Určíme cestu k ikoně na základě popisu počasí
icon_file="${weather_icons[$description]}"
if [ -n "$icon_file" ]; then
  cp /home/$USER/.config/conky/robust2/conky_pocasi/ico_weather/$icon_file /home/$USER/.config/conky/robust2/conky_pocasi/ico/
  cd /home/$USER/.config/conky/robust2/conky_pocasi/ico/
  rm weather.png
  mv *.png weather.png
#else
#  echo "Pro popis počasí '$description' nebyla nalezena odpovídající ikona, použiji výchozí."
#  cp "~/.config/conky/conky_pocasi/ico_weather/default.png" "$HOME/.config/conky/conky_pocasi/ico/"
fi
