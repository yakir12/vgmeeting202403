---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---

![bg left:40% 80%](https://datasturgeon.com/assets/logoname.svg)

# **Dancing Queen**

Explore the dancing behavior in Dung Beetles with the aid of AprilTags

---

 <video loop autoplay width="100%" src="https://dl.dropboxusercontent.com/scl/fi/kimt2tfhcl57xr5dy3ew2/dance.mp4?rlkey=l1aad2ic6yk9uruqejopcvg8s&dl=0"> </video> 

<!--
- Dung Beetles exhibit a dancing behavior
- Visually scan their environment before choosing a trajectory
- Test the role of the sun in this process  
-->

---

# Objectives

*Connect the azimuth of the sun to the orientation of the beetle* 

1. Adjust the degree of that connectivity 
2. Adjust the color and brightness of the sun
3. Have multiple different suns

<!--
main and secondary goals
one to one, static sun, reverse, etc...
-->

---

# The setup

- Flat arena 
- LED ring centered on the arena
- Overlooking camera
- Apriltag mounted on the beetle's back

---

![bg left:40% 80%](https://april.eecs.umich.edu/media/apriltag/tagformats_web.png)

# AprilTags

AprilTags is a popular form of fiducial tagging. It allows us to quickly detect the location and the orientation of all the tags in an image.

<!--
because they were introduced in April 2011
-->
---

![bg](https://dl.dropboxusercontent.com/scl/fi/tgyjdt4w9jrdp2bum5zwb/overview.jpg?rlkey=07fnd4wsfcxe2n5qtqlwvdqjr&dl=0)

---

![bg contain](https://dl.dropboxusercontent.com/scl/fi/ryn0nhuf4igjwv4pupr2h/closeup.jpg?rlkey=c9o0efvxhchxqgci6rcwmd483&dl=0)

---

![bg contain](https://dl.dropboxusercontent.com/scl/fi/zw36sk642fy16ddl41pw2/with_pi.jpg?rlkey=8r5w39x86uel5ow81ltaelvm5&dl=0)

---

# Challenges

- Functions in IR
- Closed-loop system 
- Iteration time < camera FPS 
- Control must not interfere with the main loop

<!--
The animal has a closed loop system in regards to its body and environment. We are opening that loop in order to fiddle with it.
-->

---

# Solutions

- NoIR Raspberry Pi camera
- Dedicated RPI just for the main loop
- Secondary RPI/computer for the GUI and control via a webserver

---

<video loop autoplay width="100%" src="https://dl.dropboxusercontent.com/scl/fi/4ipbtrzi92yz32zxuk841/with_beetle.mp4?rlkey=hzzkqpybmpqirqm75gz5881nv&dl=0"> </video>

---

<video loop autoplay height="100%" src="https://dl.dropboxusercontent.com/scl/fi/uw4khpob0zwk5b6q9elaa/client.webm?rlkey=cghk96zeye02q09z572who3cv&dl=0" style="float:left"> </video>
<video loop autoplay height="100%" src="https://dl.dropboxusercontent.com/scl/fi/7glvc16y76yheu2tmnay6/client2.webm?rlkey=f2wv8udcn3miaz8a4mca97ylt&dl=0" style="float:right"> </video>

---

<video loop autoplay width="30%" src="https://dl.dropboxusercontent.com/scl/fi/0ohv518mhk2kdinlz3qa3/fast.mp4?rlkey=6d72dhcpedh3p4bqk6frh6czi&dl=0" style="float:left; position: relative; left: 35%;"> </video>

---

![bg](https://dl.dropboxusercontent.com/scl/fi/m73fwmlg9zof7oobdpxcn/with_beetle.jpg?rlkey=u18q95yr3615d5k4waieqmjyb&dl=0)

---

<video loop autoplay height="100%" src="https://dl.dropboxusercontent.com/scl/fi/55hsd865bxe1juoq6w0z8/analyse.webm?rlkey=dzag17fobfouj2di19td12d42&dl=0"> </video>

---

# How does this work?
## Main loop
On the server:
1. Grab a (raw) frame from the camera
2. Detect the AprilTag in a small ROI
3. If not detected: enlarge the ROI 
4. Send instructions to LED strip (via an arduino)

<!--
The speed is independent of the image size
Steps 2 - 4 take ⪅ 5 ms, resulting in 200 FPS
-->

---
# How does this work?
## GUI loop
On the client:
1. Fetch last known frame, beetle location & orientation, as well as LEDs  
2. Plot graphics on the image
3. Log data to file
4. Send change of setup to the server
<!--
All communication occurs via a router (Wi-Fi)
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