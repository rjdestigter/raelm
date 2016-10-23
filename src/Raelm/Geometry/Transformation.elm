module Raelm.Geometry.Transformation exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat)

transform : Float -> Float -> Float -> Float -> Point -> Float -> LngLat
transform a b c d (x, y) scale =
  (scale * (a * x + b), scale * (c * y + d))

untransform : Float -> Float -> Float -> Float -> Point -> Float -> LngLat
untransform a b c d (x, y) scale =
  ((x / scale - b) / a, (y / scale - d) / c)
