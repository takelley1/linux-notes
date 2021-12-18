
## VIDEO

### [ffmpeg](https://ffmpeg.org/ffmpeg.html)

- `mediainfo in.mp4` or `ffprobe in.mp4` = Get info on video.
<br><br>
- `for f in *.mkv; do ffmpeg -i "$f" -vcodec copy -acodec copy "${f%.mkv}.mp4"; done` = Copy all mkv videos in ./ to mp4.
- `for f in *; do ffmpeg -i "$f" -vcodec h264 -acodec copy "${f%.mkv}.mp4"; done` = Transcode all videos in ./ to mp4.
<br><br>
- `ffmpeg -i in.mp4 -vf select='eq(n\,864)' -frames:v 1 out.png` = Extract frame 864 from *in.mp4* and write it to *out.png*.
<br><br>
- `ffmpeg -i in.mp4 -ss 00:00:30 out.mp4` = Trim the first 30 seconds of *in.mp4*.
- `ffmpeg -i in.mp4 -ss 00:01:00 -to 00:02:00 out.mp4` = Extract minute 1 to minute 2 of *in.mp4*.
- `ffmpeg -i in.mp4 -filter:v "crop=width:height:start_x:start_y" out.mp4` = Crop video.
- `ffmpeg -i in.mp4 -filter:v "transpose=1" -codec:v libx265 -codec:a copy out.mp4` = Rotate video 90 degrees clockwise.
- `ffmpeg -i in.mp4 -preset slow -vcodec libx265 -acodec copy -crf 25 -filter:v fps=30 out.mp4` = Transcode to 30 fps.
- `ffmpeg -i in.mp4 -preset slow -vcodec libx265 -acodec copy -vf scale=-1:1080 out.mp4` = Transcode to 1080p.
<br><br>
`ffmpeg -i in.mp4 -i thumbnail.jpg -map 0 -map 1 -c copy -c:v:1 png -disposition:v:1 attached_pic out.mp4` = Add *thumbnail.jpg* to *in.mp4*.
<br><br>
- [ffmpeg file concatenation of equal codecs](https://trac.ffmpeg.org/wiki/Concatenate)
  - All input videos must use the same encoding. Use `mediainfo file1.mp4 | grep 'Codec ID'` to determine encoding.
  - The file concatenation of ffmpeg appears to work better than mp4box.
```
$ printf "file '%s'\n" *.mp4 > mylist.txt

$ cat mylist.txt
file '/path/to/in1.mp4'
file '/path/to/in2.mp4'
file '/path/to/in3.mp4'

$ ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.mp4
```
- [ffmpeg file concatenation of different codecs](https://ffmpeg.org/ffmpeg-filters.html#concat)
```
ffmpeg -i in1.mkv -i in2.mkv -i in3.mkv -filter_complex "concat=n=3:v=1:a=1" out.mkv
```
- [ffmpeg concatenation with resolution correction](https://stackoverflow.com/a/48853654)
```
ffmpeg \
-i in1.mp4 \
-i in2.mp4 \
-i in3.mp4 \
-i in4.mp4 \
-preset slow
-vcodec libx265 \
-filter_complex \
"[0:v]scale=1920:1080:force_original_aspect_ratio=1[v0]; \
[1:v]scale=1920:1080:force_original_aspect_ratio=1[v1]; \
[2:v]scale=1920:1080:force_original_aspect_ratio=1[v2]; \
[3:v]scale=1920:1080:force_original_aspect_ratio=1[v3]; \
[v0][0:a][v1][1:a][v2][2:a][v3][3:a]concat=n=4:v=1:a=1[v][a]" -map '[v]' -map '[a]' \
out.mp4
```

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
