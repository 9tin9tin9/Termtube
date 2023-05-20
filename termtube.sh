#!/usr/local/bin/bash

# TODO: Change this variable to set default download directory
DL_DIR="/Volumes/Disk/Termtube"

HELP=(
"usage: $0 [OPTIONS] [URL...]"
""
"Download and play youtube videos."
""
"Arguments:"
"   URL"
"       Url to youtube video. Can provide more than one."
"       Recommanded to wrap the url with single quotes"
"       Prompt for search query and choose with fzf if none is given."
""
"Options:"
"   -d, --dir DIRECTORY"
"       Target directory to files at."
"       Defaults to \`${DL_DIR}\` if it exists, else \`/tmp\`"
""
"   --yt_dlp_args ARGS"
"       Arguments to be passed to yt-dlp"
""
"   --vlc_args ARGS"
"       Arguments to be passed to VLC"
""
"Examples:"
"   $0 -d $HOME/Music --vlc_args '--no-video --loop' 'https://youtu.be/dQw4w9WgXcQ'"
"       Downloads <url> to $HOME/Music, loop with audio only"
)

URLS=()
YT_DLP_ARGS=""
VLC_ARGS=""

# parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            for l in  "${HELP[@]}"; do
                echo "$l"
            done
            exit 0
            ;;
        -d|--dir)
            DL_DIR="$2"
            shift; shift
            ;;
        --yt_dlp_args)
            YT_DLP_ARGS="$2"
            shift; shift
            ;;
        --vlc_args)
            VLC_ARGS="$2"
            shift; shift
            ;;
        *)
            URLS+=($1)
            shift
            ;;
    esac
done

# check $DL_DIR
if [[ ! -e "$DL_DIR" ]]; then
    if [[ ! -z "$DL_DIR" ]]; then
        echo "\`$DL_DIR\` does not exist. Using \`/tmp\` as download directory"
    fi
    DL_DIR="/tmp"
fi

# query and search
if [[ -z "${URLS[@]}" ]]; then
    read -p "search> " query
    results=$(echo $query | COLUMNS=$(tput cols) ./search.py 20)
    URLS=$(echo "$results" | \
        fzf -m --delimiter="⁣" --with-nth 2,3,4,5 --disabled | \
        awk -F "⁣" '{ print $1 }')

    if [[ -z "${URLS[@]}" ]]; then
        exit 0
    fi
fi

# prepare playlist file
TEMP=/tmp/yt-dlp-playlist.VLC
if [[ -e "$TEMP" ]]; then
    rm -f "$TEMP"
fi

# download
for u in "${URLS[@]}"; do
    yt-dlp -P "$DL_DIR" \
        --print-to-file after_move:'%(filepath)s' $TEMP \
        $YT_DLP_ARGS \
        "$u" || exit 1
done

exec '/Applications/VLC.app/Contents/MacOS/VLC' \
    $VLC_ARGS "$TEMP" &>/dev/null &
