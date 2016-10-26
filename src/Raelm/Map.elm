module Raelm.Map exposing (..)

import Raelm.Types.Coordinates exposing (..)
import Raelm.Geo.Types exposing (..)
import Raelm.Types.Map exposing (..)
import Raelm.Utils.Coordinates exposing (..)
import Raelm.Map.Models exposing (MapModel)

getCentre : CRS -> Point -> Point -> Point -> Zoom -> LatLng
getCentre crs pixelOrigin panePos halfSize zoom =
  let
    layerPoint : Point
    layerPoint = subtractPoint halfSize panePos

    projectedPoint : Point
    projectedPoint = addPoint halfSize pixelOrigin

    pointToLatLng : Point -> Zoom -> LngLat
    pointToLatLng = crs.pointToLatLng
  in
    pointToLatLng projectedPoint zoom

getPixelOrigin : CRS -> Point -> Point -> LngLat -> Zoom -> Point
getPixelOrigin crs panePos halfSize centre zoom =
  roundPoint (addPoint (subtractPoint (crs.latLngToPoint centre zoom) halfSize) panePos)

mapType : CRS -> MapType
mapType crs =
  MapType (getCentre crs) (getPixelOrigin crs)

map : MapType -> MapModel -> Map
map mapType {centre, zoom, events, dom} =
  let
    (x, y) = events.click
    (downX, downY) =
      case events.downPosition of
        Just dp -> dp
        Nothing -> (-1, -1)

    (top, left, width, height) =
      case dom.rect of
        Nothing ->
          (0, 0, 0, 0)
        Just {top, left, width, height} ->
          (top, left, width, height)
    halfSize = divideBy (width, height) 2
    pixelCentre = mapType.crs.latLngToPoint centre zoom
    -- pixelOrigin = mapType.getPixelOrigin halfSize (left, top) centre zoom
    -- projectedPoint = mapPoint (+) (mapPoint (-) events.move (left, top)) pixelOrigin
    -- lngLat = mapType.crs.pointToLatLng projectedPoint zoom
    -- mapCentre = mapType.getCentre zoom halfSize (left, top) pixelOrigin
  in
    Map (mapType.getCentre (4,4) (5, 5) (2,2 ) 1)
      -- (mapType.getPixelOrigin (left, top) halfSize centre zoom)
      -- halfSize
