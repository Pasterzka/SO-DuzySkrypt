#!/bin/bash
# Author           : Jakub Pastuszka (s198339@pg.edu.pl)
# Created On       : 30.05.2024
# Last Modified By : Jakub Pastuszka ( jaku6p@gmail.com )
# Last Modified On : 30,05,2024 
# Version          : 1.0
v="1.0"
#
# Description      : Projekt polega na zmianie tapety urządzenia na podstawie aktualnej pogody
# Opis
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)


# Ustawienia użytkownika
API_KEY="8fc87fbd34eb03efd56fe9601d616583"
WALLPAPER_DIR="$HOME/tapety"

pomoc(){
    echo "W celu uzyskania pomocy wpisz man DuzySkrypt"
}

wersja(){
    echo "Aktualna wersja aplikacji:${v}"
}

zmienTapete(){
    miasto
    # Pobierz dane pogodowe z OpenWeatherMap API
    WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=${LAT}&lon=${LON}&appid=${API_KEY}")

    # Pobierz opis pogody z odpowiedzi API
    MAIN=$(echo "$WEATHER_DATA" | jq -r '.current.weather[0].main')

    # Ustaw odpowiednią tapetę na podstawie głównego stanu pogody
    case "$MAIN" in
        "Clear") 
            WALLPAPER="$WALLPAPER_DIR/sunny.jpg";;
        "Clouds") 
            WALLPAPER="$WALLPAPER_DIR/cloudy.jpg";;
        "Rain" | "Drizzle") 
            WALLPAPER="$WALLPAPER_DIR/rainy.jpg";;
        "Thunderstorm") 
            WALLPAPER="$WALLPAPER_DIR/thunderstorm.jpg";;
        "Snow") 
            WALLPAPER="$WALLPAPER_DIR/snowy.jpg";;
        "Mist" | "Smoke" | "Haze" | "Dust" | "Fog" | "Sand" | "Ash" | "Squall" | "Tornado")
            WALLPAPER="$WALLPAPER_DIR/misty.jpg";;
        *) 
            WALLPAPER="$WALLPAPER_DIR/default.jpg";;
    esac

    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"

    echo "Zmieniono tapete na $WALLPAPER na podstawie pogody w $MIASTO"
}

cisnienie(){
    miasto;
    # Pobierz dane pogodowe z OpenWeatherMap API
    WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=${LAT}&lon=${LON}&appid=${API_KEY}")

    # Pobierz opis pogody z odpowiedzi API
    MAIN=$(echo "$WEATHER_DATA" | jq -r '.current.pressure')
    echo "Cisnienie wynosi $MAIN hPa w $MIASTO"
}

miasto(){
    if [ "$MIASTO" == "GDANSK" ]; then
        LAT="54.3520" # Szerokość geograficzna Gdańska
        LON="18.6466" # Długość geograficzna Gdańska
    elif [ "$MIASTO" == "SOPOT" ]; then
        LAT="54.4419"
        LON="18.5601"
    elif [ "$MIASTO" == "WARSZAWA" ]; then
        LAT="52.2297"
        LON="21.0122"
    else
        MIASTO="GDANSK"
        LAT="54.3520" # Szerokość geograficzna Gdańska
        LON="18.6466" # Długość geograficzna Gdańska
    fi


}

temperatura(){
    miasto
    # Pobierz dane pogodowe z OpenWeatherMap API
    WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=${LAT}&lon=${LON}&appid=${API_KEY}")

    temp=$(echo "$WEATHER_DATA" | jq -r '.current.temp')
    temp=$(printf "%.0f" "$temp")
    temp=$(($temp - 273))
    echo "Temperatura to okolo $temp stopni Celsiusza"
}

info(){
    miasto
    # Pobierz dane pogodowe z OpenWeatherMap API
    WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=${LAT}&lon=${LON}&appid=${API_KEY}")

    temp=$(echo "$WEATHER_DATA" | jq -r '.current.temp')
    temp=$(printf "%.0f" "$temp")
    temp=$(($temp - 273))

    cisnienie=$(echo "$WEATHER_DATA" | jq -r '.current.pressure')

    pogoda=$(echo "$WEATHER_DATA" | jq -r '.current.weather[0].description')

    echo "W $MIASTO jest $temp stopni celsjusza $cisnienie hPa oraz $pogoda"
}

noweMiasto(){
    MIASTO=$OPTARG
}

MIASTO="GDANSK"


while getopts hvpctm:i OPT; do
    case $OPT in
        h) pomoc;;
        v) wersja;;
        p) zmienTapete;;
        c) cisnienie;;
        t) temperatura;;
        m) noweMiasto;;
        i) info;;
        *) echo "Nieznana Opcja";;
    esac
done

# Sprawdź, czy żadna opcja nie została podana
if [ $OPTIND -eq 1 ]; then
    zmienTapete
fi
