module Raelm.Types.Map exposing (..)

import Raelm.Types.Coordinates exposing (..)
import Raelm.Geo.Types exposing (..)

type alias MapType = {
  crs :  CRS,
  getCentre : Point -> PanePos -> Point -> Zoom -> LngLat,
  getPixelOrigin : Point -> Point -> LngLat -> Zoom -> Point
}

type alias Raelm = {
  crs : CRS,
  centre : LngLat,
  getCentre : LngLat,
  getZoom : Zoom,
  getSize: Point,
  getHalfSize: Point,
  getPixelCentre: Point,
  getPixelOrigin : Point,
  getMapPanePos : Point,
  mouseLngLat: LngLat,
  mousePoint: Point
}
