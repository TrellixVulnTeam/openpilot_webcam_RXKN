# Version 0.8.14 (April 2022)

## Installation

Close openpilot and make sure you are using the same commit as I am:
```bash
git clone git@github.com:commaai/openpilot.git
cd ~/openpilot
git checkout 515987838908c1a4f5c822919ccf2d78ebac144b
```

Next install it using:
```bash
cd ~/openpilot
git submodule update --init
tools/ubuntu_setup.sh
source ~/.bashrc
cd ~/openpilot && pipenv shell
USE_WEBCAM=1 scons -j$(nproc)
```

Test that everything is working by opening the GUI. Note you will need to run through the safety screens. You will also need to check that none of the green keywords in the terminal turn red.
```bash
cd ~/openpilot/tools/sim/
./launch_openpilot.sh
```

## Preparing the input video

Next we are going to feed it video. To do that we need to convert the video to 15fps. You can do that using FFMPEG.
```bash
ffmpeg -ss 10 -i <input_video> -c <output_video>
ffmpeg -i <input_video> -an <output_video>
ffmpeg -i <input_video> -r 24 <output_video>
```

The parameters are as follows:
* `-ss` skip from the start in seconds
* `-i` input video
* `-an` remove audio stream
* `-c` copy the video to output file
* `-r` change the framerate in fps

This can be done all in one line
```bash
ffmpeg -ss 10 -i <input_video> -an -r 5 <output_video>
```

## Launching OpenPilot

To run that video through the system you need to use the brdige. First replace the brige in the folder `tools/sim` with the one provided. Next after launching the GUI you can launch the bridge
```bash
# Terminal 1
cd ~/openpilo/tools/sim/
./launch_openpilot.sh
# Terminal 2
cd ~/openpilo/tools/sim/
python3 bridge_video.py --filename /Desktop/OpenPilotVideos/a_15.mp4
```


## Addition hacks

First I needed to install the nvidia toolkit
```bash
sudo apt install nvidia-cuda-toolkit
```

I also needed to go into the `model` folder and run
```bash
cd ~/openpilot/models/
git lfs pull
```

I then installed libzmq from source by first remove libzmq library
```bash
sudo apt purge libzmq* -y
```

Then compile from source:
```bash
git clone https://github.com/zeromq/libzmq.git
cd ~/libzmq
sudo apt-get install automake
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
```
Looks like I was using commit 515987838908c1a4f5c822919ccf2d78ebac144b
Another thing to check is did you compile using USE_WEBCAM=1 if I remember correctly that adds a bunch of opencv stuff to the compilation which I believe I use
