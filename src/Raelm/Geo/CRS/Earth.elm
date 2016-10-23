module Raelm.Geo.CRS.Earth exposing (..)

import Raelm.Geo.Types exposing (WrapLng, R)
import Raelm.Types.Coordinates exposing (LngLat)

wrapLng : WrapLng
wrapLng = Just (-180, 180)

r : R
r = 6371000

distance : LngLat -> LngLat -> Float
distance (x1, y1) (x2, y2) =
  let
    rad = pi / 180
    lat1 = y1 * rad
    lat2 = y2 * rad
    a = ((sin lat2) * (sin lat2)) + (cos(lat1) * cos(lat2) * cos((x2 - x1) * rad))
  in
    (toFloat r) * acos((min a 1))
