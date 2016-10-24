module Raelm.Utils.Coordinates exposing (..)
import Raelm.Types.Coordinates exposing (Point, Bounds)

getMinMaxBounds : Bounds -> Bounds
getMinMaxBounds ((x1, y1), (x2, y2)) =
  let
    minPoint : Point
    minPoint = (min x1 x2, min y1 y2)

    maxPoint : Point
    maxPoint = (max x1 x2, max y1 y2)
  in
    (minPoint, maxPoint)

scaleBy : (Float, Float) -> (Float, Float) -> Point
scaleBy (x, y) (scaleX, scaleY) =
  (x * scaleX, y * scaleY)

unscaleBy : (Float, Float) -> (Float, Float) -> Point
unscaleBy (x, y) (unscaleX, unscaleY) =
  (x / unscaleX, y / unscaleY)

floorPoint : (Float, Float) -> (Float, Float)
floorPoint (x, y) =
  (toFloat (floor x), toFloat (floor y))

ceilPoint : (Float, Float) -> (Float, Float)
ceilPoint (x, y) =
  (toFloat (ceiling x), toFloat (ceiling y))

subtractPoint : Point -> (Float, Float) -> Point
subtractPoint (x, y) (subtractX, subtractY) =
  (x - subtractX, y - subtractY)

divideBy : Point -> Float -> Point
divideBy (x, y) f =
  (x / f, y / f)

roundPoint : Point -> Point
roundPoint (x, y) =
  (toFloat (round x), toFloat (round y))

getBoundsCentre ((x1, y1), (x2, y2)) roundIt =
  let
    ((minX, minY), (maxX, maxY)) = getMinMaxBounds ((x1, y1), (x2, y2))
    (avgX, avgY) = ( (minX + maxX) / 2, (minY + maxY) / 2)
  in
    if roundIt == True then
      roundPoint (avgX, avgY)
    else
      (avgX, avgY)
