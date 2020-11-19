# tl;dr
`Docker image` for `Raspberry Pi Camera` (i.e. `picam`) libraries and utilities
to run the `picam` for different applications in `Docker`.

## Utility Scripts
What follows are a collection of simple `scripts` (i.e. `python`, and `shell`
scripts) to help with different `picam`-related tasks.

### timelapse.sh
Just a simple `shell` script to wrap all the `timelapse`-related features. The
script will simply capture a photo every `minute` for `12 hours`, and `annotate`
the `datetime` onto the center of the picture (for aiding analysis on later
viewings). The script can be run as follows. First download the repo:
```
$ git clone https://github.com/RagingTiger/docker-picam
```

Then `cd` to the `src/shell` directory:
```
$ cd docker-picam/src/shell`
```

And finally run the script (in the background) as follows:
```
$ bash timelapse.sh &
```

## Post-Processing
Here we will discuss various `post-processing` methods and tools.

### timelapse video
After we have recorded our `timelapse` images we can **"stitch"** them together
using `ffmpeg`.[^fn1] We can use the
[`tigerj/hckr`](https://github.com/RagingTiger/docker-hckr) `docker` image
to do this (**Note**: this can be an `I/O` and `CPU` intensive process so it is
recommended that you run these commands on the most powerful machine you have).
First `cd` into the directory with all the `timelapse` images:
```
$ cd /my/timelapse/images/
```

Then run a `container` of the `tigerj/hckr` image:
```
$ docker run \
           --rm \
           -v /my/timelapse/image:/home/hckr \
           -it \
           tigerj/hckr
```

This will launch an `interactive` `bash` prompt (running in the `docker
container`) where we can run the `ffmpeg` commands:
```
# ffmpeg -r 12 -pattern_type glob -i '*.jpg' -c:v copy output.avi
```

This command will simply stitch the pictures together at a `rate` of `12 frames
per second` (`fps`). But the resulting `output.avi` will be rather large, so it
would be good to reduce that size. We can do that, again using `ffmpeg`, as
follows:
```
# ffmpeg -i output.avi -c:v libx264 -preset slow -crf 15 output-final.mkv
```

The resulting `mkv` file (`output-final.mkv`) will be significantly smaller, but
can be compressed even more by using a tool known as
[`handbrake`](https://handbrake.fr) of which an excellent `docker image` exists
created by [`jlesage`](https://github.com/jlesage) at
[`jlesage/handbrake`](https://github.com/jlesage/docker-handbrake). Click the
previous links to learn more about `handbrake` and the `jlesage/handbrake`
image.

## References
[^fn1]: [Recording a timelapse with a Raspberry Pi](https://blog.securem.eu/projects/2016/02/21/recording-a-timelapse-with-a-raspberry-pi/)
