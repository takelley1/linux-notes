
## VIDEO

### [ffmpeg](https://ffmpeg.org/ffmpeg.html)

- `mediainfo input.mp4` or `ffprobe input.mp4` = Get info on video.
<br><br>
- `for f in *.mkv; do ffmpeg -i "$f" -vcodec copy -acodec aac "${f%.mkv}.mp4"; done` = Copy all mkv videos in ./ to mp4.
- `for f in *; do ffmpeg -i "$f" -vcodec h264 -acodec aac "${f%.mkv}.mp4"; done` = Transcode all videos in ./ to mp4.
<br><br>
- `ffmpeg -i input.mp4 -vf select='eq(n\,864)' -frames:v 1 out.png` = Extract frame 864 from *input.mp4* and write it to *out.png*.
<br><br>
- `ffmpeg -i input.mp4 -ss 00:00:30 output.mp4` = Trim the first 30 seconds of *input.mp4*.
- `ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 output.mp4` = Extract minute 1 to minute 2 of *input.mp4*.
- `ffmpeg -i input.mp4 -filter:v "crop=width:height:start_x:start_y" output.mp4` = Crop video.

### Other

- `mp4box -force-cat -cat infile-1.mp4 -cat infile-2.mp4 -cat infile-3.mp4 outfile.mp4` = Combine mp4 videos.
- `mp4box infile.mp4 -split-chunk 0:end-10` = Split mp4 video from second 0 to 10 seconds before video end.
- `mp4box infile.mp4 -split-chunk 0:523` = Split mp4 video from second 0 to second 523.
<br><br>
- `mkvmerge -o outfile.mkv infile-1.mkv +infile-2.mkv` = Combine mkv videos (from mkvtoolnix).
- `mkvmerge infile.mkv --split duration:00:28:06.000 -o outfile.mkv` = Split mkv videos.
<br><br>
- `mpv --input-test --idle --force-window` = Start mpv in xev-style mode that shows keybindings when keys are pressed.


---
## IMAGES

- **See also:**
  - [GNU parallel](http://www.gnu.org/software/parallel/)

### [Image Magick](https://imagemagick.org/script/command-line-processing.php)

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

---
## AUDIO

### ALSA

- `alsamixer` = Open mixing interface, use `b` to balance L and R channel volumes.
