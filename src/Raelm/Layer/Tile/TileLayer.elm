module Raelm.Layer.Tile.TileLayer exposing (..)
import Debug exposing (..)

-- Html imports
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import String exposing (join)
import Raelm.Layer.Tile.Types exposing (..)
import Raelm.Geo.CRS exposing (scale)
import Raelm.Geo.CRS.EPSG3857 exposing (latLngToPoint, pointToLatLng, getProjectedBounds)
import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds, Coord, Coords, Zoom)
import Raelm.Utils.Coordinates exposing (..)

getTiledPixelBounds : LngLat -> Int -> (Float, Float) -> Bounds
getTiledPixelBounds center zoom (width, height) =
  let
    s = scale zoom
    (centreX, centreY) = latLngToPoint center zoom
    (halfWidth, halfHeight) = divideBy (width, height) 2
    ne = (centreX - halfWidth, centreY - halfHeight)
    sw = (centreX + halfWidth, centreY + halfHeight)
    -- d1 = Debug.log "halfSize" (halfWidth, halfHeight)
    -- d2 = Debug.log "pixelBounds" (ne, sw)
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

-- mapXRange : Float -> String
-- mapXRange x = toString x

mapYRange : Int -> List Float -> Float -> List Coord
mapYRange z xRange y = List.map (\x -> (x, y, z)) xRange

getOriginLevel : Int -> (Float, Float) -> (Float, Float)
getOriginLevel zoom origin =
  let
    unprojected = pointToLatLng origin zoom
    projected = latLngToPoint unprojected zoom
  in
    roundPoint projected


getTilePos : (Float, Float) -> (Float, Float, Int) -> (Float, Float)
getTilePos origin (x, y, zoom) =
  let
    scaled = scaleBy (x, y) getTileSize
    subtracted = subtractPoint scaled (getOriginLevel zoom origin)
  in
    subtracted

addTile : Point -> Coord -> Coord
addTile origin (x, y, zoom) =
  let
    (k, l) = getTilePos origin (x, y, zoom)
    -- key = tileCoordsToKey (x, y, zoom)
  in
    (k, l, zoom)

tileCoordsToKey : (Float, Float, Int) -> String
tileCoordsToKey (x, y, z) =
  (toString x) ++ ":" ++ (toString y) ++ ":" ++ (toString z)

-- isValidTile : (Float, Float, Float) -> Bool
-- isValidTile (x, y, z) =
--   let
--     pixelWorldBounds = getProjectedBounds z
--     globalTileRange = pxBoundsToTileRange pixelWorldBounds
-- 		var crs = this._map.options.crs;
--
-- 		if (!crs.infinite) {
-- 			// don't load tile if it's out of bounds and not wrapped
-- 			var bounds = this._globalTileRange;
-- 			if ((!crs.wrapLng && (coords.x < bounds.min.x || coords.x > bounds.max.x)) ||
-- 			    (!crs.wrapLat && (coords.y < bounds.min.y || coords.y > bounds.max.y))) { return false; }
-- 		}
--
-- 		if (!this.options.bounds) { return true; }
--
-- 		// don't load tile if it doesn't intersect the bounds in options
-- 		var tileBounds = this._tileCoordsToBounds(coords);
-- 		return L.latLngBounds(this.options.bounds).overlaps(tileBounds);
-- 	},

osm = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
subdomains = ["a", "b", "c"]

-- getSubdomain : Coord -> String
-- getSubdomain (x, y, z) =
--   let
--     index = (abs (x + y) % (List.length subdomains)
--   in
--     List.foldr (\s -> s) (List.head subdomains) subdomains
  -- var index = Math.abs(tilePoint.x + tilePoint.y) % this.options.subdomains.length;
  -- return this.options.subdomains[index];

getTileUrl : Coord -> String
getTileUrl (x, y, z) =
  let
    zxy = String.join "/" (List.map toString [z, round x, round y])
    url = "//a.tile.openstreetmap.org/" ++ zxy ++ ".png"
    d = Debug.log "url" url
  in
    url


-- createTile : Coord -> a
-- createTile (x, y, z) =


update : LngLat -> Zoom -> Point -> Point -> Bounds
update centre zoom (width, height) origin =
  let
    pixelBounds = getTiledPixelBounds centre zoom (width, height)
    tileRange = pxBoundsToTileRange pixelBounds
    tileCenter = getBoundsCentre tileRange False
    ((rangeMinX, rangeMinY), (rangeMaxX, rangeMaxY)) = tileRange

    tileCoords = List.concatMap (mapYRange zoom [rangeMinX..rangeMaxX]) [rangeMinY..rangeMaxY]
    i = List.map (addTile origin) tileCoords
    s = List.map getTileUrl tileCoords
    -- d1 = Debug.log "tileRange X" [rangeMinX..rangeMaxX]
    -- d2 = Debug.log "tileRange Y" [rangeMinY..rangeMaxY]
    -- d3 = Debug.log "result" tileCenter
  in
    (pixelBounds)

-- Exports
view : Maybe String -> TileOptionSet -> { centre : (Float, Float), zoom : Int, size : (Float, Float), origin : (Float, Float) } -> Html a
view url options {centre, zoom, size, origin} =
  let
    tileOptions = getTileOptions url options
    (width, height) = size
    s = update centre zoom size origin
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
