module Raelm.Layer.Tile.TileLayer exposing (..)
import Debug exposing (..)

-- Html imports
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)

import Raelm.Layer.Tile.Types exposing (..)
import Raelm.Geo.CRS exposing (scale)
import Raelm.Geo.CRS.EPSG3857 exposing (latLngToPoint, pointToLatLng)
import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds)
import Raelm.Utils.Coordinates exposing (..)

getTiledPixelBounds : LngLat -> Int -> (Float, Float) -> Bounds
getTiledPixelBounds center zoom (width, height) =
  let
    s = scale zoom
    (centreX, centreY) = latLngToPoint center zoom
    (halfWidth, halfHeight) = (width / s * 2, height / s * 2)
    ne = (centreX - halfWidth, centreY - halfHeight)
    sw = (centreX + halfWidth, centreY + halfHeight)
  in
    (ne, sw)

pxBoundsToTileRange : Bounds -> Bounds
pxBoundsToTileRange bounds =
  let
    tileSize : (Float, Float)
    tileSize = getTileSize
    (min, max) = getMinMaxBounds(bounds)
  in
    (floorPoint (unscaleBy min tileSize), subtractPoint (ceilPoint (unscaleBy max tileSize)) (1, 1))

getTileSize = (256, 256)

update centre zoom (width, height) =
  let
    pixelBounds = getTiledPixelBounds centre zoom (width, height)
    tileRange = pxBoundsToTileRange pixelBounds
    tileCenter = getBoundsCentre tileRange False
    d = Debug.log "c" pixelBounds
  in
    (pixelBounds)

-- Exports
view : Maybe String -> TileOptionSet -> { centre : (Float, Float), zoom : Int, size : (Float, Float) } -> Html a
view url options {centre, zoom, size} =
  let
    tileOptions = getTileOptions url options
    (width, height) = size
    s = update centre zoom size
  in
    div [ class "raelm-layer"
        , style [ ("opacity", toString tileOptions.opacity)
                , ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                , ("backgroundColor", "Lime")
                , ("height", "100%")
                ]
        ]
      [ text ("My Tile Layer: " ++ (toString zoom))
      , text (
        case tileOptions.url of
          Just x -> x
          Nothing -> "No url provided"
      )
      ]
