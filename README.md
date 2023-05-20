# Termtube

Some scripts to download and play youtube videos

NOTE: If you only want to play youtube videos without using browser and doesn't
care about downloading the vidoes, consider using the [vlc addon for youtube-dl
integration](https://github.com/mjasny/vlc-youtubeDL)

## Usage

```
usage: termtube.sh [OPTIONS] [URL...]

Download and play youtube videos.

Arguments:
   URL
       Url to youtube video. Can provide more than one.
       Recommanded to wrap the url with single quotes
       Prompt for search query and choose with fzf if none is given.

Options:
   -d, --dir DIRECTORY
       Target directory to files at.
       Defaults to `$HOME/Music/Termtube` if it exists. else `/tmp`

   --yt_dlp_args ARGS
       Arguments to be passed to yt-dlp

   --vlc_args ARGS
       Arguments to be passed to vlc

Examples:
   ./termtube -d $HOME/Music --vlc_args '--no-video --loop' 'https://youtu.be/dQw4w9WgXcQ'
       Downloads <url> to $HOME/Music, loop with audio only
```

## Dependencies

- [fzf](https://github.com/junegunn/fzf)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- VLC
- python3
- `search.py` dependencies

### Install `search.py` dependencies

run
```
pip3 install -r requirements.txt
```

## VLC addon for yt-dlp

The addon provided above can be used to play youtube video in VLC with some
patching. Note that youtube-dl is broken on my Mac so I am replacing youtube-dl
with yt-dlp.

Install the addon with
```sh
curl 'https://raw.githubusercontent.com/mjasny/vlc-youtubeDL/master/youtube-dl.lua' | sed 's/youtube-dl/yt-dlp/g' > youtube.luac
# assuming MacOS
cp youtube.luac /Applications/VLC.app/Contents/MacOS/share/lua/playlist/youtube.luac
```

and play youtube video with
```sh
vlc <url>
```

or on Mac
```sh
exec '/Applications/VLC.app/Contents/MacOS/VLC' <url>
```
