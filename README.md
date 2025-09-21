![Platform](https://img.shields.io/badge/platform-manjaro-green)
![WM](https://img.shields.io/badge/window%20manager-Wayland-blue)
![Desktop](https://img.shields.io/badge/desktop-KDE6-blueviolet)

# Sci_conky
Sci-fi conky theme     
The repository contains the following directories:    
- Blue :         contains conky.config files for the blue version
- Orange :       contains conky.config files for the orange version
- wall :         here are the background wallpapers
- fonts :        with the fonts used
- conky_pocasi : weather.sh bash script that uses the API from https://openweathermap.org to get weather data.     
                 The data is saved in a .txt file, from where conky loads it weather.conf.     
----

Changing colors: open the blue/orange directory and copy all files to the main directory and run conky-startup.sh.      

----      

Wallpapers are created with Dall-E and Copilot and compiled in Krita editor.    

----

## How to install     

1. Unzip the downloaded Sci_conky-main.zip archive     
2. Move the Sci_conky-main directory to /home/user/.config/conky     
3. Move the files from the Blue or Orange directory to the Sci_conky-main directory.     
4. Run the bash script conky-startup.sh     
- In the terminal: bash conky-startup.sh     
- To automatically start after the old system, add the script to:     
System settings / automatic startup / login script. The system version varies.     
     
Or     
      
1. Edit conky-startup.sh    
In the terminal: nano conky -startup.sh     
2. Change the file paths.     
- cd "$HOME/.config/conky/sci_conky/"     
- change to: cd "your/way/directory/sci_conky/"

----     

For more my conky.config for x11 go to: [Codehack.cz](https://codehack.cz/conky.html#gsc.tab=0)     
Conky project [Homepage](https://github.com/brndnmtthws/conky/wiki)      

----     

<img src="OrangeP.png" alt="Screenshot_orange" width="600">     


<img src="BlueP.png" alt="Screenshot_blue" width="600">
