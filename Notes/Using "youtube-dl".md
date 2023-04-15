# Using "youtube-dl"

You can download video and audio files for offline viewing from a variety of websites using youtube-dl. Be sure to install ffmpeg as well for tagging.

To grab an HD MP4 (720p or the next best *larger* size), use the following command (works well on YouTube):

```bash
youtube-dl \
	--output "%(title)s (%(id)s).%(ext)s" \
	--format "bestvideo[width<=1280][height>540][ext=mp4]+bestaudio[ext=m4a]/bestvideo[width<=1920][height>720][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
	--add-metadata "$URL"
```

Useful size specs:

* 480p: 854x480 (ish) - DVD quality
* 540p: 960x540 (ish) - quarter HD, pretty uncommon (except on VHX)
* 720p: 1280x720 (ish) - often just called "HD"
* 1080p: 1920x1080 (ish) - often called "full HD"

Most of the time, you'll need a newer version of youtube-dl than is available in your distro's repos. You can grab the latest youtube-dl source code from GitHub, or alternately install with pip. I prefer to do this in a Python virtual environment, though it still can help to pull in the system package (to ensure that you have all of the right dependencies).

```bash
virtualenv youtube-dl
cd youtube-dl
. bin/activate
pip install --upgrade youtube-dl
```

* [Common Python Tools: Using virtualenv, Installing with Pip, and Managing Packages](https://www.digitalocean.com/community/tutorials/common-python-tools-using-virtualenv-installing-with-pip-and-managing-packages)
* [ytdl-org / youtube-dl](https://github.com/ytdl-org/youtube-dl)
