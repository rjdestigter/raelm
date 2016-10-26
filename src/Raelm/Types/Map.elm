module Raelm.Types.Map exposing (..)

import Raelm.Types.Coordinates exposing (..)

type alias MapType = {
  getCentre : Point -> Point -> Point -> Zoom -> LngLat,
  getPixelOrigin : Point -> Point -> LngLat -> Zoom -> Point
}

type alias Map = {
  getCentre : LngLat
  -- getPixelOrigin : Point,
  -- getHalfSize: Point
}
