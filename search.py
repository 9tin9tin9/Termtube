#!/usr/bin/env python3

from youtube_search import YoutubeSearch
from urwid.util import str_util
from urllib.parse import urlparse
import argparse
import os
import sys
import subprocess


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def strlen(str):
    return sum(map(lambda c: str_util.get_width(ord(c)), str))


def pad_or_cut_str(str, length):
    # cut
    if strlen(str) > length:
        newstr = ""
        for c in str:
            if strlen(newstr + c) >= length:
                return newstr + "…" * (length - strlen(newstr))
            newstr += c
        return newstr
    # pad
    return str + ' ' * (length - strlen(str))


def isYoutubeLink(query):
    url = urlparse(query)
    return all([url.scheme, url.netloc]) and \
        url.hostname in ["youtu.be", "www.youtube.com"]


def getVideoInfo(url):
    def process_output(out):
        return out.stdout.decode('utf-8').rstrip().split('\n')

    eprint("Feching video info")

    out = subprocess.run(
        ['yt-dlp', url, '--print', 'playlist_title'],
        capture_output=True)
    playlist_title = process_output(out)
    if playlist_title == ['']:
        return None

    if playlist_title != ["NA"]:
        return playlist_title[0]

    out = subprocess.run(
        ['yt-dlp', url, '--print', 'title'],
        capture_output=True)
    title = process_output(out)
    return title[0]


parser = argparse.ArgumentParser(
    description="Search youtube videos and return columnated results")
parser.add_argument(
    "max_results",
    metavar="N",
    type=int,
    nargs=1,
    default=10,
    help="Maximum display results")
args = parser.parse_args()

query = input()
info = getVideoInfo(query)
if info is not None:
    print("  ⁣".join([query, info]))
    exit(0)

eprint("Searching", query)
results = YoutubeSearch(query, max_results=args.max_results[0]).to_dict()
termcols = int(os.environ["COLUMNS"])

cols = {
    "title": 0.5,
    "duration": 0.1,
    "channel": 0.1,
    "publish_time": 0.1,
    "url_suffix": 0.2
}
for video in results:
    def info(col):
        if video[col] == 0:
            return "live" if col == "duration" else "NA"
        return video[col]
    components = [
        pad_or_cut_str(info(col), int(termcols * cols[col]) - 3)
        for col in filter(lambda x: x != "url_suffix", cols)
    ]
    print("  ⁣".join(
        ["https://youtube.com" + video["url_suffix"]] + components))
