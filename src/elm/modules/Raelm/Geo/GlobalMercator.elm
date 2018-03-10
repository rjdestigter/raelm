module Raem.Geo.GlobalMercator exposing (..)

import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Bitwise


exp : Float -> Float
exp p =
    Basics.e ^ p


tileSize : Float
tileSize =
    256


initialResolution : Float
initialResolution =
    2 * Basics.pi * 6378137 / tileSize


originShift : Float
originShift =
    2 * Basics.pi * 6378137 / 2.0


resolution : Float -> Float
resolution zoom =
    initialResolution / (2 ^ zoom)


lngLatToMeters : LngLat -> Point
lngLatToMeters ( lng, lat, _ ) =
    let
        mx =
            lng * originShift / 180

        my =
            (logBase e) (Basics.tan ((90 + lat) * Basics.pi / 360.0)) / (Basics.pi / 180.0)
    in
        ( mx, my * originShift / 180 )


metersToLngLat : Point -> LngLat
metersToLngLat ( x, y ) =
    let
        lng =
            (x / originShift) * 180

        lat =
            (y / originShift)
                |> (*) 180
                |> (*) (Basics.pi / 180.0)
                |> exp
                |> Basics.atan
                |> (*) 2
                |> flip (-) (Basics.pi / 2)
                |> (*) (180 / Basics.pi)
    in
        ( lng, lat, Nothing )


pixelsToMeters : Point -> Float -> Point
pixelsToMeters ( px, py ) zoom =
    let
        res =
            resolution zoom

        mx =
            px * res - originShift

        my =
            py * res - originShift
    in
        ( mx, my )


metersToPixels : Point -> Float -> Point
metersToPixels ( mx, my ) zoom =
    let
        res =
            resolution zoom

        px =
            (mx + originShift) / res

        py =
            (my + originShift) / res
    in
        ( px, py )


pixelsToTile : Point -> Point
pixelsToTile ( px, py ) =
    let
        tx =
            Basics.ceiling (px / tileSize) - 1 |> toFloat

        ty =
            Basics.ceiling (py / tileSize) - 1 |> toFloat
    in
        ( tx, ty )


pixelsToRaster : Point -> Float -> Point
pixelsToRaster ( px, py ) zoom =
    let
        mapSize =
            Bitwise.shiftLeftBy (Basics.round tileSize) (Basics.round zoom) |> toFloat
    in
        ( px, mapSize - py )


metersToTile : Point -> Float -> Point
metersToTile meters zoom =
    metersToPixels meters zoom |> pixelsToTile


tileBounds : Point -> Float -> Bounds
tileBounds ( tx, ty ) zoom =
    let
        ( minX, minY ) =
            pixelsToMeters ( tx * tileSize, ty * tileSize ) zoom

        ( maxX, maxY ) =
            pixelsToMeters ( (tx + 1) * tileSize, (ty + 1) * tileSize ) zoom
    in
        ( minX, minY, maxX, maxY )


tileLngLatBounds : Point -> Float -> Bounds
tileLngLatBounds tile zoom =
    let
        ( minTx, minTy, maxTx, maxTy ) =
            tileBounds tile zoom

        ( minLng, minLat ) =
            metersToLngLat ( minTx, minTy )

        ( maxLng, maxLat ) =
            metersToLngLat ( maxTx, maxTy )
    in
        ( minLng, minLat, maxLng, maxLat )
