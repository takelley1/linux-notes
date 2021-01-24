
## VIDEO

-**See also:**
  - [ffmpeg docs](https://ffmpeg.org/ffmpeg.html)

### ffmpeg

- `mediainfo input.mp4` or `ffprobe input.mp4` = Get info on video.
<br><br>
- `for f in *.mkv; do ffmpeg -i "$f" -vcodec copy -acodec aac "${f%.mkv}.mp4"; done` = Copy all mkv videos in ./ to mp4.
- `for f in *; do ffmpeg -i "$f" -vcodec h264 -acodec aac "${f%.mkv}.mp4"; done` = Transcode all videos in ./ to mp4.
<br><br>
- `ffmpeg input.mp4 -vf select='eq(n\,864)' -frames:v 1 out.png` = Extract frame 864 from *input.mp4* and write it to *out.png*.
<br><br>
- `ffmpeg -i input.mp4 -ss 00:00:30 output.mp4` = Trim the first 30 seconds of *input.mp4*.
- `ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 output.mp4` = Extract minute 1 to minute 2 of *input.mp4*.
- `ffmpeg -i input.mp4 -filter:v "crop=width:height:start_x:start_y" output.mp4` = Crop video.

### Other

`mp4box -force-cat -cat video-part1.mp4 -cat video-part2.mp4 -cat video-part3.mp4 video.mp4` = Combine videos.


---
## IMAGES

- **See also:**
  - [GNU parallel](http://www.gnu.org/software/parallel/)

### Image Magick

- `ls *.jpg | parallel convert -geometry 120 {} thumb_{}` = Convert images in parallel.

Take a screenshot with ImageMagick:
```
import \
    -window root \
    -quiet \
    -silent \
    -quality 100 \
    -crop \
    "./screenshot.png"
```

### Other

`pngcrush -s "./screenshot.png" "./$(date +%Y-%m-%d)_${HOSTNAME}.png"` = Compress and rename *screenshot.png*.
