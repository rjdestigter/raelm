module Raelm.Map exposing (createMapType, getMapType, raelm, defaultMapType, defaultRaelm)

import Raelm.Types.Coordinates exposing (..)
import Raelm.Geo.Types exposing (..)
import Raelm.Types.Map exposing (..)
import Raelm.Utils.Coordinates exposing (..)
import Raelm.Map.Models exposing (MapModel)
import Raelm.Geo.CRS.EPSG3857 as EPSG3857 exposing (..)

getCentre : CRS -> Point -> Point -> Point -> Zoom -> LngLat
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

createMapType : CRS -> MapType
createMapType crs =
  MapType crs (getCentre crs) (getPixelOrigin crs)

getMapType : Maybe MapType -> MapType
getMapType mapType =
  case mapType of
    Just customMapType -> customMapType
    Nothing -> createMapType EPSG3857.crs

defaultMapType : MapType
defaultMapType = getMapType Nothing

defaultRaelm : MapModel -> Raelm
defaultRaelm = raelm (Just defaultMapType)

raelm : Maybe MapType -> (MapModel -> Raelm)
raelm maybeMapType =
  let
    mapType = getMapType maybeMapType
  in
    \{centre, zoom, events, dom} ->
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
        pixelOrigin = mapType.getPixelOrigin (left, top) halfSize centre zoom
        projectedPoint = mapPoint (+) (mapPoint (-) events.move (left, top)) pixelOrigin
        lngLat = mapType.crs.pointToLatLng projectedPoint zoom
        mapCentre = mapType.getCentre pixelOrigin (left, top) halfSize zoom
      in
        Raelm mapType.crs mapCentre zoom (width, height) halfSize pixelOrigin (left, top) lngLat events.move
