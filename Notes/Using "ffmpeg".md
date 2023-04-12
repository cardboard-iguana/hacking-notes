# Using "ffmpeg"

## M4A to MP3

```bash
ffmpeg -i ${INPUT}.m4a -c:v copy -c:a libmp3lame \
       -q:a 0 ${OUTPUT}.mp3
```

The `-q:a` parameters correspond to LAME's `-V` option, so 0 is the highest quality and 9 is the lowest quality. While everyone says to use 3 or 4 for this parameter, in my experience even using 0 will often result in a *smaller* file than an m4a original. (What's up with that? I thought that m4a was supposed to be more efficient than mp3?)

* [FFMPEG: Convert m4a to mp3 without significant loss](https://superuser.com/a/704535)
* [FFmpeg MP3 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/MP3)

## MP4 to GIF

```bash
# Generate an optimized palette.
#
ffmpeg -i $INPUT.mp4 \
       -filter_complex "[0:v] palettegen" $PALETTE.png

# Convert the MP4 to GIF (using the palette above).
#
ffmpeg -i $INPUT.mp4 -i $PALETTE.png \
       -filter_complex "[0:v][1:v] paletteuse" \
	                    $OUTPUT.gif
```

* [Create animated GIFs from MP4 with FFmpeg](https://homehack.nl/create-animated-gifs-from-mp4-with-ffmpeg/)

## MP4 to WebP

```bash
ffmpeg -i $INPUT.mp4 \
       -vf "fps=10,scale=720:-1:flags=lanczos" \
       -vcodec libwebp -lossless 0 -compression_level 6 \
       -q:v 50 -loop 0 -preset picture -an \
       -vsync 0 $OUTPUT.webp
```

* [Create animated GIF and WebP from videos using FFmpeg](https://mattj.io/posts/2021-02-27-create-animated-gif-and-webp-from-videos-using-ffmpeg/)
