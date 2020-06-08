breed [ants ant]
patches-own [pheromone food nest distance-from-nest]
ants-own [carrying-food speed metabolism hunger]
globals [ant-deaths ant-hatches ants-to-respawn]

to setup
  clear-all
  reset-ticks
  setup-nest
  setup-food
  setup-ants
  ask patches [p-paint-patch]
  ask ants [t-paint-ant]
  set ant-deaths 0
  set ants-to-respawn 0
end

to p-paint-patch
  set pcolor black
  if show-pheromone [
    set pcolor scale-color pheromone-color pheromone pheromone-min pheromone-max
  ]
  if show-distance [
    ; 35 * sqrt(2) = ~50
    set pcolor scale-color distance-color distance-from-nest 0.1 50
  ]
  if show-food and food = 1 [
    set pcolor food-color
  ]
  if show-nest and nest = 1 [
    set pcolor nest-color
  ]
end

to t-paint-ant
  set hidden? not show-ants
  ifelse carrying-food = 1 [
    set color ant-carrying-color
  ][
    set color ant-color
  ]
end

to setup-nest
  ask patches [
    p-setup-nest
  ]
end

to p-setup-nest
  ifelse (distancexy nest-x nest-y) < nest-size [
    set nest 1
  ][
    set nest 0
  ]
  set distance-from-nest distancexy nest-x nest-y
end

to setup-food
  add-food-1
  add-food-2
  add-food-3
end

to add-food-1
  ask patches [
    p-add-food food-x-1 food-y-1 food-size-1
  ]
end

to add-food-2
  ask patches [
    p-add-food food-x-2 food-y-2 food-size-2
  ]
end

to add-food-3
  ask patches [
    p-add-food food-x-3 food-y-3 food-size-3
  ]
end

to p-add-food [x y s]
  if (distancexy x y) < s [
    set food 1
  ]
end

to setup-ants
  set-default-shape ants "bug"
  create-ants ants-qty
  ask ants [t-setup-ant]
end

to respawn-ants
  create-ants ants-to-respawn [t-setup-ant]
  set ants-to-respawn 0
end

to t-setup-ant
  set color ant-color
  set carrying-food 0
  ; Ho usato dei float invece che degli int, va bene lo stesso?
  set speed (random (max-speed - min-speed + 1)) + min-speed
  set metabolism (random (max-metabolism - min-metabolism + 1)) + min-metabolism
  set hunger starting-hunger
  setxy nest-x nest-y
  fd nest-size
end

to p-evaporate-pheromone
  set pheromone pheromone * (100 - evaporation-pct) / 100
end

to-report t-pheromone-left
  report [pheromone] of patch-left-and-ahead 45 1
end

to-report t-pheromone-center
  report [pheromone] of patch-ahead 1
end

to-report t-pheromone-right
  report [pheromone] of patch-right-and-ahead 45 1
end

to t-rotate-pheromone
  ; TODO: aggiungere rotazione a caso
  let pleft t-pheromone-left
  let pcenter t-pheromone-center
  let pright t-pheromone-right
  if (pleft >= 0.05 and pleft <= 2) or (pcenter >= 0.05 and pcenter <= 2) or (pright >= 0.05 and pright <= 2)[
  ifelse pleft > pright and pleft > pcenter [
    left 45
  ][
    if pright > pcenter [
      right 45
    ]
  ]]
end

to-report t-nest-left
  report [distance-from-nest] of patch-left-and-ahead 45 1
end

to-report t-nest-center
  report [distance-from-nest] of patch-ahead 1
end

to-report t-nest-right
  report [distance-from-nest] of patch-right-and-ahead 45 1
end

to t-rotate-nest
  let nleft t-nest-left
  let ncenter t-nest-center
  let nright t-nest-right
   ifelse nleft > nright and nleft > ncenter [
     right 45
   ][
     if nright > ncenter [
       left 45
     ]
   ]
end

to-report t-is-over-food
  report ([food] of patch-here = 1)
end

to-report t-is-over-nest
  report ([nest] of patch-here = 1)
end

to t-pick-up-food
  ask patch-here [
    set food 0
  ]
  set carrying-food 1
  rt 180
end

to t-try-pick-up-food
  if carrying-food = 0 and t-is-over-food [
    t-pick-up-food
  ]
end

to t-drop-food
  set carrying-food 0
  rt 180
end

to-report t-try-drop-food
  if carrying-food = 1 and t-is-over-nest [
    t-drop-food
    report true
  ]
  report false
end

to t-add-pheromone
  ask patch-here [
    set pheromone pheromone + 60
  ]
end

to t-die
  set ant-deaths ant-deaths + 1
  ; Die interrompe la funzione!
  die
end

to-report t-partners
  report other turtles in-radius partner-radius with [hunger >= reproduction-hunger]
end

to t-inherit [parents]
  let top-speed max [speed] of parents
  let bottom-speed min [speed] of parents
  set speed (bottom-speed + random (top-speed - bottom-speed + 1))

  let top-metabolism max [metabolism] of parents
  let bottom-metabolism min [metabolism] of parents
  set metabolism (bottom-metabolism + random (top-metabolism - bottom-metabolism + 1))
end

to t-hatch
  let partners t-partners
  if any? partners [
    let partner item 0 sort-on [hunger] partners
    let parents (turtle-set self partner)
    ask parents [
      set hunger hunger - reproduction-cost
    ]
    hatch-ants 1 [
      t-setup-ant
      t-inherit parents
    ]
    set ant-hatches ant-hatches + 1
  ]
end

to t-resupply
  set hunger hunger + food-value
end

to t-consume-food
  set hunger hunger - metabolism
  if hunger <= 0 [
    t-die
  ]
  if hunger >= reproduction-hunger [
    t-hatch
  ]
end

to t-work
  ifelse carrying-food = 1 [
    t-rotate-nest
    t-add-pheromone
  ][
    t-rotate-pheromone
  ]
  left random random-angle
  right random random-angle
  t-consume-food
  repeat speed [
    fd 1
    t-try-pick-up-food
    if t-try-drop-food [
      t-resupply
    ]
  ]
end

to try-respawn-food-1
  if ticks mod food-r-1 = food-o-1 [
    add-food-1
  ]
end

to try-respawn-food-2
  if ticks mod food-r-2 = food-o-2 [
    add-food-2
  ]
end

to try-respawn-food-3
  if ticks mod food-r-3 = food-o-3 [
    add-food-3
  ]
end

to try-respawn-food
  try-respawn-food-1
  try-respawn-food-2
  try-respawn-food-3
end

to go
  tick
  if food-respawn [
    try-respawn-food
  ]
  respawn-ants
  ask ants [t-work]
  ask patches [p-evaporate-pheromone]
  diffuse pheromone (diffusion-pct / 100)
  ask patches [p-paint-patch]
  ask ants [t-paint-ant]
end
@#$#@#$#@
GRAPHICS-WINDOW
8
10
726
729
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-35
35
-35
35
1
1
1
ticks
30.0

BUTTON
730
10
860
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
730
115
902
148
nest-size
nest-size
1
10
5.0
1
1
patches
HORIZONTAL

INPUTBOX
905
90
955
150
nest-x
0.0
1
0
Number

INPUTBOX
960
90
1010
150
nest-y
0.0
1
0
Number

INPUTBOX
1015
90
1120
150
nest-color
12.0
1
0
Color

INPUTBOX
1125
155
1230
215
food-color
43.0
1
0
Color

INPUTBOX
905
155
955
215
food-x-1
21.0
1
0
Number

INPUTBOX
960
155
1010
215
food-y-1
0.0
1
0
Number

INPUTBOX
905
220
955
280
food-x-2
-21.0
1
0
Number

INPUTBOX
960
220
1010
280
food-y-2
-21.0
1
0
Number

INPUTBOX
905
285
955
345
food-x-3
-28.0
1
0
Number

INPUTBOX
960
285
1010
345
food-y-3
28.0
1
0
Number

SLIDER
730
180
902
213
food-size-1
food-size-1
0
15
5.0
1
1
patches
HORIZONTAL

SLIDER
730
245
902
278
food-size-2
food-size-2
0
15
5.0
1
1
patches
HORIZONTAL

SLIDER
730
310
902
343
food-size-3
food-size-3
0
15
5.0
1
1
patches
HORIZONTAL

TEXTBOX
760
380
910
398
NIL
11
0.0
1

SLIDER
730
350
902
383
diffusion-pct
diffusion-pct
0
100
57.0
1
1
%
HORIZONTAL

SLIDER
730
385
902
418
evaporation-pct
evaporation-pct
0
100
20.0
1
1
%
HORIZONTAL

BUTTON
730
45
793
78
tick
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
795
45
858
78
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
730
445
800
505
ants-qty
100.0
1
0
Number

INPUTBOX
880
445
950
505
ant-color
15.0
1
0
Color

INPUTBOX
955
445
1025
505
ant-carrying-color
18.0
1
0
Color

INPUTBOX
905
350
955
410
pheromone-min
0.1
1
0
Number

INPUTBOX
960
350
1010
410
pheromone-max
5.0
1
0
Number

INPUTBOX
1015
350
1120
410
pheromone-color
65.0
1
0
Color

PLOT
1235
90
1435
240
Ants with food
Ticks
Ants
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"with-food" 1.0 0 -1069655 true "" "plot count ants with [carrying-food = 1]"

PLOT
1235
245
1435
395
Patches with food
Ticks
Patches
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -7171555 true "" "plot count patches with [food = 1]"

SWITCH
360
735
530
768
show-pheromone
show-pheromone
0
1
-1000

SWITCH
185
735
355
768
show-ants
show-ants
0
1
-1000

SWITCH
10
735
180
768
show-nest
show-nest
0
1
-1000

SWITCH
535
735
705
768
show-food
show-food
0
1
-1000

INPUTBOX
1125
90
1230
150
distance-color
135.0
1
0
Color

SWITCH
710
735
880
768
show-distance
show-distance
1
1
-1000

INPUTBOX
805
445
875
505
random-angle
45.0
1
0
Number

INPUTBOX
805
510
875
570
max-speed
2.0
1
0
Number

INPUTBOX
955
510
1025
570
max-metabolism
5.0
1
0
Number

INPUTBOX
730
510
800
570
min-speed
1.0
1
0
Number

INPUTBOX
880
510
950
570
min-metabolism
1.0
1
0
Number

INPUTBOX
1030
510
1120
570
starting-hunger
400.0
1
0
Number

INPUTBOX
1015
155
1065
215
food-r-1
210.0
1
0
Number

INPUTBOX
1070
155
1120
215
food-o-1
0.0
1
0
Number

INPUTBOX
1015
220
1065
280
food-r-2
210.0
1
0
Number

INPUTBOX
1070
220
1120
280
food-o-2
70.0
1
0
Number

INPUTBOX
1015
285
1065
345
food-r-3
210.0
1
0
Number

INPUTBOX
1070
285
1120
345
food-o-3
140.0
1
0
Number

PLOT
1235
400
1435
550
Ant deaths
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ant-deaths"

PLOT
1440
90
1640
240
Ant speeds
NIL
NIL
1.0
3.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -13791810 true "" "histogram [speed] of ants"

PLOT
1440
295
1640
445
Ant metabolisms
NIL
NIL
1.0
6.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -6459832 true "" "histogram [metabolism] of turtles"

MONITOR
1550
450
1600
495
M 3
count ants with [metabolism = 3]
0
1
11

MONITOR
1495
450
1545
495
M 2
count ants with [metabolism = 2]
0
1
11

MONITOR
1440
450
1490
495
M 1
count ants with [metabolism = 1]
0
1
11

MONITOR
1605
450
1655
495
M 4
count ants with [metabolism = 4]
0
1
11

MONITOR
1660
450
1710
495
M 5
count ants with [metabolism = 5]
17
1
11

MONITOR
1440
245
1535
290
Speed 1
count ants with [speed = 1]
17
1
11

MONITOR
1540
245
1635
290
Speed 2
count ants with [speed = 2]
0
1
11

PLOT
1645
90
1845
240
Ant hunger
NIL
NIL
0.0
1000.0
0.0
10.0
true
false
"" ""
PENS
"default" 50.0 1 -5825686 true "" "histogram [hunger] of ants"

SWITCH
1125
285
1230
318
food-respawn
food-respawn
0
1
-1000

INPUTBOX
730
575
875
635
reproduction-hunger
800.0
1
0
Number

INPUTBOX
1125
220
1230
280
food-value
400.0
1
0
Number

INPUTBOX
880
575
1025
635
reproduction-cost
40.0
1
0
Number

PLOT
1235
555
1435
705
Ant hatches
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -14439633 true "" "plot ant-hatches"

PLOT
1440
555
1640
705
Ants
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -7500403 true "" "plot count ants"

INPUTBOX
1030
575
1175
635
partner-radius
3.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
