module Raelm.Geo.Projection.SphericalMercator exposing (..)
import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds)
import Raelm.Geo.Types exposing (R, MaxLatitude)

r : R
r = 6378137

maxLatitude : MaxLatitude
maxLatitude = 85.0511287798

project : LngLat -> Point
project (x, y) =
  let
    d : Float
    d = pi / 180

    lat : Float
    lat = max (min maxLatitude y) (-maxLatitude)

    sinVal: Float
    sinVal = sin (y * d)

    px : Float
    px = (toFloat r) * x * d

    py : Float
    py = (toFloat r) * ((logBase e)((1 + sinVal) / (1 - sinVal))) / 2
  in
    (px, py)

unproject : Point -> LngLat
unproject (x, y) =
  let
    d = pi / 180
    lng = x * d / (toFloat r)
    lat = (2 * atan(e ^ (y / (toFloat r))) - (pi / 2)) * d
  in
    (lng, lat)

bounds : Bounds
bounds =
  let
    d = (toFloat r) * pi
  in
    ((-d, -d), (d, d))
