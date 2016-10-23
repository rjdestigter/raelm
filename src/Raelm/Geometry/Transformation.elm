module Raelm.Geometry.Transformation exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat)

transform : Float -> Float -> Float -> Float -> Point -> Int -> LngLat
transform a b c d (x, y) scale =
  ((toFloat scale) * (a * (toFloat x) + b), (toFloat scale) * (c * (toFloat y) + d))

untransform : Float -> Float -> Float -> Float -> Point -> Int -> LngLat
untransform a b c d (x, y) scale =
  (((toFloat x) / (toFloat scale) - b) / a, ((toFloat y) / (toFloat scale) - d) / c)
