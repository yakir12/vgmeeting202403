---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---


# **PawsomeTracker**

*Automatically tracking an animal in a video*

[https://github.com/yakir12/PawsomeTracker.jl](https://github.com/yakir12/PawsomeTracker.jl)

<!--
Hi my name is Yakir, I work as a Research Software Engineer at Marie Dacke's lab, but I also work on hardware. Today I'll present an auto tracker I made for the Dacke Lab.  
-->

---

 <video muted loop autoplay width="100%" src="media/example.mp4"> </video> 

<!--
- Some behavioral experiments involve recording a video
- In order to later extract the location of the animal
- Usually the researcher needs many repetitions / runs for statistics
- This often results in hundreds of very similar short videos
- Perfect for automation 

SO HOW WOULD WE AUTODETECT THIS BEETLE?
-->

---

![bg center height:100%](media/ways.jpg)

<!--
Robust way to detect the target
-->

---

# Difference of Gaussians (DoG)
- A narrow gaussian minus a wide one
- An image with details "thicker" than the narrow gaussian minus one with details "thicker" than the wide gaussian
- All that remains are details between the two spatial frequencies
- A DoG filter is therefore a spatial band-pass filter

<!-- 
- read the slide and draw on blackboard
- Surround inhibition is a physiological mechanism to focus neuronal activity in the central nervous system. 
- This so-called center-surround organization is well-known in sensory systems, where central signals are facilitated and eccentric signals are inhibited in order to sharpen the contrast between them.
-->

---

# Fast 
- We need only process a neighborhood around the target
- That region of interest (ROI) follows the target
- Adapt the size of the ROI to the size of the target
- Speed is thus independent of the image size!

<!-- 
- read the slide and draw on blackboard
-->

---

# Process any video
- Uses `ffmpeg`
- Works with variable framerate
- Deals with data/pixel/storage aspect-ratios ≠1
- Accounts for non-zero start-time

<!-- 
- uses ffmpeg, which is the most complete, cross-platform solution to record, convert, and stream audio and video
- not all videos have a constant frame rate, and converting them loses (meta-data) information
- interlaced videos, or non square pixels can create distortions that the tracker needs to be aware of
- cameras will sometimes segments large video files into smaller ones (e.g FAT), subsequent segments will have a non-zero start time, which the tracker also needs to know of
-->

---
# Cross-platform
- Programmed in a dynamic cross-platform language (need you ask)
- All the tech underlining this is cross-platform


![bg right](media/animated-logo.gif)

---

# Unit Tests and Continuous Integration 


[![Build Status](https://github.com/yakir12/PawsomeTracker.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/yakir12/PawsomeTracker.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Coverage](https://codecov.io/gh/yakir12/PawsomeTracker.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/yakir12/PawsomeTracker.jl) [![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)


- High coverage (>95%) of unit tests
- Continuous Integration tested on all combinations of:
    - all three main architectures (Window, Mac, & Linux)
    - all major versions of Julie (LTS, prerelease, & nightly) 
    - single as well as multi-threaded instances
- Code quality included in the tests

<!-- 
- Unit tests are simple tests that guarantee that the program does what you think it should. i.e. if you have a function that adds 1 to a number, you can test that when you run fun(2) you get 3.
- High coverage means that your unit tests cover a large percent of your code base. That is, there are very few things in your program that are not tested for.
- Continuous integration is a pipeline that automatically runs your tests on every change you want to introduce into the program. This guarantees that the program does exactly what you expect it to on every architecture, version, and instance for every little change you make to the code.
- Code quality is specific to each language, where one can achieve the same end product via differently "good" ways, and the best way is assured with this additional check.
-->

---
# Thread safety
- Tracking in this program is sequential in nature
- But you could make the tracking thread-safe 
- Allowing tracking multiple videos in parallel (CPU goes to 100%) 


<!--
- you need to know where the previous location was to detect the next one
- Safe to run concurrently on multiple threads
- allows for maximal efficiency
-->

---

# Arguments
Everything except the file name has sensible defaults
- **File name**
- When in the video to start looking for the target (0 seconds)
- When in the video to stop looking for the target (24 hours)
- How wide is the target (25 pixels)

---

# Arguments (cont.)
- Where in the frame to start looking for the target (frame center)
- How large is the ROI (DoG filter size, depends on target width)
- Is the target darker or brighter than the background (darker)
- What frames per second should the video be tracked at (24 FPS)
- Save an optional diagnosis video (no)

<!-- 
Use a Difference of Gaussian (DoG) filter to track a target in a video `file`. 
- `start`: start tracking after `start` seconds. Defaults to 0.
- `stop`: stop tracking at `stop` seconds.  Defaults to 86399.999 seconds (24 hours minus one millisecond).
- `target_width`: the full width of the target (diameter, not radius). It is used as the FWHM of the center Gaussian in the DoG filter. Arbitrarily defaults to 25 pixels.
- `start_location`: one of the following:
    1. `missing`: the target will be detected in a large (half as large as the frame) window centered at the frame.
    2. `CartesianIndex{2}`: the Cartesian index (into the image matrix) indicating where the target is at `start`. Note that when the aspect ratio of the video is not equal to one, this Cartesian index should be to the raw, unscaled, image frame.
    3. `NTuple{2}`: (x, y) where x and y are the horizontal and vertical pixel-distances between the left-top corner of the video-frame and the target at `start`. Note that regardless of the aspect ratio of the video, this coordinate should be to the scaled image frame (what you'd see in a video player).
    Defaults to `missing`.
- `window_size`: Defaults to to a good minimal size that depends on the target width (see `fix_window_size` for details). But can be one of the following:
    1. `NTuple{2}`: a tuple (w, h) where w and h are the width and height of the window (region of interest) in which the algorithm will try to detect the target in the next frame. This should be larger than the `target_width` and relate to how fast the target moves between subsequent frames. 
    2. `Int`: both the width and height of the window (region of interest) in which the algorithm will try to detect the target in the next frame. This should be larger than the `target_width` and relate to how fast the target moves between subsequent frames. 
- `darker_target`: set to `true` if the target is darker than its background, and vice versa. Defaults to `true`.
- `fps`: frames per second. Sets how many times the target's location is registered per second. Set to a low number for faster and sparser tracking, but adjust the `window_size` accordingly. Defaults to an arbitrary value of 24 frames per second.
- `diagnostic_file`: specify a file path to save a diagnostic video showing a low-memory version of the tracking video with the path of the target superimposed on it. Defaults to nothing.


Returns a vector with the time-stamps per frame and a vector of Cartesian indices for the detection index per frame.
-->

---

 <video muted loop autoplay width="100%" src="media/diagnostic_elin.mp4"> </video> 

---

 <video muted loop autoplay width="100%" src="media/diagnostic_bastien.mp4"> </video> 

<!-- 
- even in difficult settings
-->