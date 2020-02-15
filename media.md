
## FFMPEG

`for f in *.mkv; do ffmpeg -i "$f" -vcodec copy -acodec aac "${f%.mkv}.mp4"; done` = copy all mkv videos in ./ to mp4  
`for f in *; do ffmpeg -i "$f" -vcodec h264 -acodec aac "${f%.mkv}.mp4"; done` = transcode all videos in ./ to mp4

## IMAGE MAGICK

**see also:** http://www.gnu.org/software/parallel/  

`ls *.jpg | parallel convert -geometry 120 {} thumb_{}` = convert images **in parallel** 

