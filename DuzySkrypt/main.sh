#!/bin/bash
# Author           : Jakub Pastuszka (s198339@pg.edu.pl)
# Created On       : 30.05.2024
# Last Modified By : Jakub Pastuszka ( jaku6p@gmail.com )
# Last Modified On : 30,05,2024 
# Version          : 1.0
#
# Description      : Projekt polega na zmianie tapety urządzenia na podstawie aktualnej pogody
# Opis
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)


# Ustawienia użytkownika
API_KEY="8fc87fbd34eb03efd56fe9601d616583"
LAT="54.3520" # Szerokość geograficzna Gdańska
LON="18.6466" # Długość geograficzna Gdańska
WALLPAPER_DIR="$HOME/DuzySkrypt/wallpapers"
EXCLUDE="minutely,hourly,daily,alerts" # Części odpowiedzi do wykluczenia


# Pobierz dane pogodowe z OpenWeatherMap API
WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=${LAT}&lon=${LON}&exclude=${EXCLUDE}&appid=${API_KEY}&units=metric")

# Wyciągnij warunki pogodowe z odpowiedzi API
WEATHER_CONDITION=$(echo $WEATHER_DATA | jq -r '.current.weather[0].main')


# Wybierz odpowiednią tapetę na podstawie warunków pogodowych
case $WEATHER_CONDITION in
    Clear)
        WALLPAPER="clear.jpg"
        ;;
    Clouds)
        WALLPAPER="clouds.jpg"
        ;;
    Rain)
        WALLPAPER="rain.jpg"
        ;;
    Snow)
        WALLPAPER="snow.jpg"
        ;;
    Thunderstorm)
        WALLPAPER="thunderstorm.jpg"
        ;;
    Mist | Fog | Haze | Smoke | Dust | Sand | Ash | Squall | Tornado)
        WALLPAPER="mist.jpg"
        ;;
    *)
        WALLPAPER="default.jpg" # Domyślna tapeta w przypadku nieznanych warunków
        ;;
esac

# Zmień tapetę
feh --bg-scale "${WALLPAPER_DIR}/${WALLPAPER}"

echo "Tapeta zmieniona na podstawie warunków pogodowych: ${WEATHER_CONDITION}"