using PawsomeTracker
using BenchmarkTools
file = "20220228_1roll_midroll_B01.mov"
start = 29
stop = 75

# track(file; start, stop, diagnostic_file = "diagnostic.mp4")

@btime track(file; start, stop, window_size = 30, start_location = CartesianIndex(505, 767)) # a 46 second video, takes 8.686 s (14850 allocations: 17.73 MiB)
