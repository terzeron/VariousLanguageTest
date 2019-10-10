#!/usr/bin/env io

Bicycle := Object clone do(ride := method("ride a bicycle!"))
Bicycle println

MountainBike := Bicycle clone do(ride := method("ride a mountain bike!"))
MountainBike println

RoadBike := Bicycle clone do(ride := method("ride a road bike!"))
RoadBike println

TandemBike := Bicycle clone do(ride := method("ride a tandem bike!"))
TandemBike println

aBike := MountainBike clone
aBike println
aBike proto println
aBike isKindOf(MountainBike) println
aBike isKindOf(Bicycle) println
aBike isKindOf(Object) println
MountainBike isKindOf(Bicycle) println

# recursive style
fibonacci := method(n, 
  if(n < 2, n,
    fibonacci(n - 1) + fibonacci(n - 2))
)
fibonacci(10) println

# oo style
Number fibonacci := method(
  if(self < 2, self,
    (self - 1) fibonacci + (self - 2) fibonacci)
)
fibonacci(10) println