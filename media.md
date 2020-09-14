
## FFMPEG

- `for f in *.mkv; do ffmpeg -i "$f" -vcodec copy -acodec aac "${f%.mkv}.mp4"; done` = Copy all mkv videos in ./ to mp4.
- `for f in *; do ffmpeg -i "$f" -vcodec h264 -acodec aac "${f%.mkv}.mp4"; done` = Transcode all videos in ./ to mp4.

## IMAGE MAGICK

- **See also:**
  - [GNU parallel](http://www.gnu.org/software/parallel/)

- `ls *.jpg | parallel convert -geometry 120 {} thumb_{}` = Convert images in parallel.
