---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---


# **Dancing Queen**
![](https://datasturgeon.com/assets/logoname.svg)

![bg right 90%](qr.svg)


<!--
Explore the dancing behavior in Dung Beetles with the aid of AprilTags
You can scan the QR code here to view the presentation online
-->

---

 <video muted loop autoplay width="100%" src="https://dl.dropboxusercontent.com/scl/fi/kimt2tfhcl57xr5dy3ew2/dance.mp4?rlkey=l1aad2ic6yk9uruqejopcvg8s&dl=0"> </video> 

<!--
- Dung Beetles exhibit a dancing behavior
- Visually scan their environment before choosing a trajectory
- Test the role of the sun in this process  
-->

---

# Objectives

*"Connect" the azimuth of the sun to the orientation of the beetle* 

1. Adjust the degree of that connectivity 
2. Adjust the width, color, and brightness of the sun
3. Have multiple different suns

<!--
In order to test the role of the sun, we want to "connect" the sun to the beetle
main and secondary goals
one to one, static sun, reverse, etc...
-->

---

# Challenges

- Work in Infra Red
- Closed-loop system 
- Iteration time < camera FPS 
- Control must not interfere with the main loop

<!--
The animal has a closed loop system in regards to its body and environment. We are opening that loop in order to fiddle with it.
-->

---

# Solutions

- NoIR Raspberry Pi camera
- Dedicated RPI just for the main loop: Server
- Secondary RPI/computer for the GUI and control: Client
- asynchronous web communication between the server and client
- Post analysis with a dedicated tool

<!--
- Cheap and sturdy hardware that does what we need it to
- easy to dedicate a single Pi just for the main loop of detecting the beetle and updating the LEDs
- the monitoring loop for the user is secondary
-->

---

# The setup

- Flat arena 
- LED ring centered on the arena
- Overlooking camera
- Apriltag mounted on the beetle's back

<!--
We've built what we call the dancing queen
-->

---

# AprilTags

![bg left:50% 80%](https://april.eecs.umich.edu/media/apriltag/apriltagrobots_overlay.jpg)


Fiducial tagging: quickly detect tag's location and orientation in an image.

<!--
- These are tags, just like the QR code you saw in the beginning of this presentation, that together with a image analysis framework, convey their ID, location, and orientation in the image. 
- They're called APRIL-tags because they were introduced in April 2011
- ...and, here's a sketch of the main components
-->

---

![bg](https://dl.dropboxusercontent.com/scl/fi/tgyjdt4w9jrdp2bum5zwb/overview.jpg?rlkey=07fnd4wsfcxe2n5qtqlwvdqjr&dl=0)

<!--
- Here's an overview of the setup. 
- Ignore the arches
- You can see the Raspberry Pi at the top, and the camera
- I placed an Apriltag mounted on a plastic cap just for testing purposes
- The black cross on the arena is for calibration purposes
- Every surface on the inside is black 
-->

---

![bg contain](https://dl.dropboxusercontent.com/scl/fi/ryn0nhuf4igjwv4pupr2h/closeup.jpg?rlkey=c9o0efvxhchxqgci6rcwmd483&dl=0)

![bg contain](https://dl.dropboxusercontent.com/scl/fi/zw36sk642fy16ddl41pw2/with_pi.jpg?rlkey=8r5w39x86uel5ow81ltaelvm5&dl=0)

<!--
- You can see the way the camera is mounted, to allow for micro manipulations to adjust it 
-->

---

<video muted loop autoplay width="100%" src="https://dl.dropboxusercontent.com/scl/fi/4ipbtrzi92yz32zxuk841/with_beetle.mp4?rlkey=hzzkqpybmpqirqm75gz5881nv&dl=0"> </video>

<!--
- an overview of the whole thing, wha it looks like with a (half dead) beetle in it 
-->

---

### Client
<div>
<video muted loop autoplay height="100%" src="https://dl.dropboxusercontent.com/scl/fi/uw4khpob0zwk5b6q9elaa/client.webm?rlkey=cghk96zeye02q09z572who3cv&dl=0" style="float:left"> </video>

<video muted loop autoplay height="100%" src="https://dl.dropboxusercontent.com/scl/fi/7glvc16y76yheu2tmnay6/client2.webm?rlkey=f2wv8udcn3miaz8a4mca97ylt&dl=0" style="float:right"> </video>
</div>

<!--
- what it looks like on the user's screen 
- they can switch between predetermined (determined by the user) setups
- either with a mouse, or just by a keyboard press
-->

---

### Server

<video muted loop autoplay width="25%" src="https://dl.dropboxusercontent.com/scl/fi/0ohv518mhk2kdinlz3qa3/fast.mp4?rlkey=6d72dhcpedh3p4bqk6frh6czi&dl=0"> </video>

<!--
- I included this just to show that delays, lags, glitches on the client side occur only there. 
- on the server side, i.e. the loop between the camera and the LED strip is free of that.
-->

---

![bg](https://dl.dropboxusercontent.com/scl/fi/m73fwmlg9zof7oobdpxcn/with_beetle.jpg?rlkey=u18q95yr3615d5k4waieqmjyb&dl=0)

<!--
- I included this, just to show you what the beetle looks like with the tag on its back. 
-->

---

### Analysis

<video muted loop autoplay width="80%" src="https://dl.dropboxusercontent.com/scl/fi/55hsd865bxe1juoq6w0z8/analyse.webm?rlkey=dzag17fobfouj2di19td12d42&dl=0"> </video>

<!--
includes:
- a way to view their track, including their last `n` seconds
- they last heading
- a histogram of their bearing (the angle between their heading and the sun), per sun
- a track of their turning (accumulated turning relative to the world)
-->

---

# How does this work?
## Server
1. Grab a frame from the camera
2. Detect the AprilTag in a **small ROI**
3. If not detected: enlarge the ROI 
4. Send instructions to LED strip (via an arduino)

<!--
The speed is therefore independent of the image size
Steps 2 - 4 take ⪅ 5 ms, resulting in 200 FPS
-->

---

# How does this work?
## Client
1. Fetch last known frame, beetle location & orientation, as well as LEDs  
2. Plot graphics on the image
3. Log data to file -> used later in analysis
4. Send change of setup to the server
<!--
- All communication occurs via a router (Wi-Fi)
- any plotting and logging happens outside the main loop
-->

---

# Specs

Mode|Resolution|FPS|Brightness|FOV|Max height|Arena width
---|---|---|---|---|---|---
480|480×480|<font style="color:red;">206</font>|low|19°|70 cm|24 cm
1232|1232×1232|83|high|48.8°|70 cm|64 cm
1080|1080×1080|47|high|21.4°|120 cm|45 cm
2464|<font style="color:red;">2464×2464</font>|21|high|48.8°|120 cm|109 cm

---

![bg](https://dl.dropboxusercontent.com/scl/fi/q1bl7deqhe681zuqm95hb/dancingqueen.jpg?rlkey=qqkcdnq5orygejmbtd8478xok&dl=0)