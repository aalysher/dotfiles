#!/bin/bash

notification_timeout=2000  # Увеличено для лучшей видимости
download_album_art=true
show_album_art=true

# Функция для получения обложки альбома
function get_album_art {
    url=$(playerctl -f "{{mpris:artUrl}}" metadata)
    if [[ $url == "file://"* ]]; then
        album_art="${url/file:\/\//}"
    elif [[ $url == "http://"* ]] || [[ $url == "https://"* ]]; then
        filename="$(echo $url | sed "s/.*\///")"
        if [ ! -f "/tmp/$filename" ] && [ "$download_album_art" == "true" ]; then
            wget -O "/tmp/$filename" "$url"
        fi
        album_art="/tmp/$filename"
    else
        album_art=""
    fi
}

# Функция для отображения уведомления о музыке
function show_music_notif {
    song_title=$(playerctl -f "{{title}}" metadata)
    song_artist=$(playerctl -f "{{artist}}" metadata)
    song_album=$(playerctl -f "{{album}}" metadata)

    if [[ $show_album_art == "true" ]]; then
        get_album_art
    fi

    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title" "$song_artist - $song_album"
}

# Основная функция
case $1 in
    next_track)
        playerctl next
        sleep 0.5 && show_music_notif
        ;;

    prev_track)
        playerctl previous
        sleep 0.5 && show_music_notif
        ;;

    play_pause)
        playerctl play-pause
        show_music_notif
        ;;
esac
