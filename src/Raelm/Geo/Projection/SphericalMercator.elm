module Raelm.Geo.Projection.SphericalMercator exposing (..)
import Raelm.Types.Coordinates exposing (..)
import Raelm.Geo.Types exposing (..)

r : R
r = 6378137

maxLatitude : MaxLatitude
maxLatitude = 85.0511287798

project : Project
project (x, y) =
  let
    d : Float
    d = pi / 180

    lat : Float
    lat = max (min maxLatitude y) (0 - maxLatitude)
    -- lat = Math.max(Math.min(max, latlng.lat), -max)

    sinVal: Float
    sinVal = sin (y * d)

    px : Float
    px = (toFloat r) * x * d

    py : Float
    py = (toFloat r) * ((logBase e)((1 + sinVal) / (1 - sinVal))) / 2
  in
    (px, py)

unproject : Unproject
unproject (x, y) =
  let
    d = 180 / pi
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

exports = Projection r project unproject bounds
