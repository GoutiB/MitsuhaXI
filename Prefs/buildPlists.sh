Apps=(Music Soundcloud Spotify Springboard Deezer)
Colors=("#fc3059" "#fc3059" "#fcfcfc" "#fcfcfc" "#fcfcfc")
FPS=("60" "60" "24" "24" "24")

for idx in ${!Apps[*]}
do
    APP_ID=${Apps[$idx]}
    APP_NAME=${Apps[$idx]}
    APP_COLOR=${Colors[$idx]}
    APP_FPS=${FPS[$idx]}

    cat PlistParts/_skeleton.plist | sed -e "s/%EXTRA%/$(cat PlistParts/${APP_ID}.extra.plist | tr -d '\n' | sed 's:/:\\/:g')/" | sed "s/%APP_ID%/$APP_ID/" | sed "s/%APP_NAME%/$APP_NAME/" | sed "s/%APP_COLOR%/$APP_COLOR/" | sed "s/%APP_FPS%/$APP_FPS/" | tr -d '\n' | tr -d '\t' | tr '$' '\n' > $2/Library/PreferenceBundles/$1.bundle/${APP_ID}Prefs.plist
done