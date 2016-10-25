module Raelm.Layer.Tile.TileLayer exposing (..)
import Debug exposing (..)

-- Html imports
import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, style, src)

import Raelm.Layer.Tile.Types exposing (..)
import Raelm.Geo.CRS exposing (scale)
import Raelm.Geo.CRS.EPSG3857 as EPSG3857 exposing (latLngToPoint, pointToLatLng)
import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds, Zoom, Coord, Coords)
import Raelm.Utils.Coordinates exposing (..)

getTiledPixelBounds : LngLat -> Int -> (Float, Float) -> Bounds
getTiledPixelBounds center zoom size =
  let
    s = 1
    pixelCentre = latLngToPoint center zoom
    halfSize = divideBy size (s * 2)
    ne = mapPoint (-) pixelCentre halfSize
    sw = mapPoint (+) pixelCentre halfSize
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

mapXRange : Zoom -> List Float -> Float -> Coords
mapXRange z xRange y =
  List.map (\x -> (x, y, z)) xRange

getTilePos : Coord -> Point -> Point
getTilePos (x, y, z) pixelOrigin =
  subtractPoint (scaleBy (x, y) getTileSize) pixelOrigin

getCoords : Bounds -> Zoom -> Coords
getCoords ((tileRangeMinX, tileRangeMinY), (tileRangeMaxX, tileRangeMaxY)) zoom =
  List.concatMap (mapXRange zoom [tileRangeMinX..tileRangeMaxX]) [tileRangeMinY..tileRangeMaxY]

createTile wrapX coord =
  wrapCoords wrapX coord

createTiles wrapX coords =
  case wrapX of
    Nothing ->
      List.map (createTile (0,1)) coords
    Just wrapLng ->
      List.map (createTile (wrapLng)) coords

getTileUrl (x, y, zoom) =
  "https://a.tile.openstreetmap.org/" ++ (toString zoom) ++ "/" ++ (toString x) ++ "/" ++ (toString y) ++ ".png"

update centre zoom (width, height) wrapX origin =
  let
    pixelBounds = getTiledPixelBounds centre zoom (width, height)
    tileRange = pxBoundsToTileRange pixelBounds
    tileCenter = getBoundsCentre tileRange False
    coords = getCoords tileRange zoom
    tiles = createTiles wrapX coords
    urls = List.map (\c -> (getTileUrl c, getTilePos c origin)) tiles
    -- images = List.map (\u -> (img [src u])) urls
  in
    urls

wrapCoords : (Float, Float) -> Coord -> Coord
wrapCoords wrapX (x, y, z) =
  (wrapNum x wrapX, y, z)

getWrapX : Int -> Maybe (Float, Float)
getWrapX zoom =
  case EPSG3857.wrapLng of
    Nothing ->
      Nothing
    Just (wrapLngX, wrapLngY) ->
      let
        (tileSizeX, tileSizeY) = getTileSize
        (x1, y1) = latLngToPoint (wrapLngX, 0) zoom
        (x2, y2) = latLngToPoint (wrapLngY, 0) zoom
        floored = floor (x1 / tileSizeX)
        ceiled = ceiling (x2 / tileSizeY)
      in
        Just (toFloat floored, toFloat ceiled)


-- Exports
view : Maybe String -> TileOptionSet -> { centre : (Float, Float), zoom : Int, size : (Float, Float), origin: (Float, Float) } -> Html a
view url options {centre, zoom, size, origin} =
  let
    tileOptions = getTileOptions url options
    (width, height) = size
    wrapX = getWrapX zoom
    s = update centre zoom size wrapX origin
    children = List.map (\(u, (x, y)) -> (img [ src u, style [ ("position", "absolute"), ("transform", "translate3d(" ++ (toString x) ++ "px," ++ (toString y) ++ "px,0)") ] ] [])) s
  in
    div [ class "raelm-layer"
        , style [ ("opacity", toString tileOptions.opacity)
                , ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                , ("pointerEvents", "none")
                ]
        ]
        children
