# Termtube

Some scripts to download and play youtube videos

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
       Defaults to `` if it exists. else `/tmp`

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
