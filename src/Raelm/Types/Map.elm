module Raelm.Types.Map exposing (..)

import Raelm.Types.Coordinates exposing (..)
import Raelm.Geo.Types exposing (..)

type alias MapType = {
  crs :  CRS,
  getCentre : Point -> Point -> Point -> Zoom -> LngLat,
  getPixelOrigin : Point -> Point -> LngLat -> Zoom -> Point
}

type alias Raelm = {
  crs : CRS,
  getCentre : LngLat,
  getZoom : Zoom,
  getSize: Point,
  getHalfSize: Point,
  getPixelOrigin : Point,
  getMapPanePos : Point,
  mouseLngLat: LngLat,
  mousePoint: Point
}
