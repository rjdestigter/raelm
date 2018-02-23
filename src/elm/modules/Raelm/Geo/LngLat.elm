module Raelm.Geo.LngLat exposing (..)

import Raelm.Geometry.Point as Point exposing (Point)


maxMargin : Float
maxMargin =
    1.0e-9


type alias LngLat =
    ( Float, Float, Maybe Float )


fromPoint : Point -> LngLat
fromPoint ( x, y ) =
    ( x, y, Nothing )


equalsWithMargin : Float -> LngLat -> LngLat -> Bool
equalsWithMargin maxMargin ( lng1, lat1, _ ) ( lng2, lat2, _ ) =
    let
        margin =
            ( lng1 - lng2, lat1 - lat2 ) |> Point.map Basics.abs |> Point.fold Basics.max
    in
        margin <= maxMargin


equals : LngLat -> LngLat -> Bool
equals =
    equalsWithMargin maxMargin


toString : LngLat -> String
toString ( lng, lat, _ ) =
    "LngLat(" ++ Basics.toString lng ++ ", " ++ Basics.toString lat ++ ")"


wrap : LngLat -> Maybe a
wrap ( lng, lat, _ ) =
    Nothing


toBounds : Float -> LngLat -> ( Float, Float, Float, Float )
toBounds sizeInMeters ( lng, lat, _ ) =
    let
        latAccuracy =
            180 * sizeInMeters / 40075017

        lngAccuracy =
            latAccuracy / Basics.cos ((Basics.pi / 180) * lat)
    in
        ( lng - lngAccuracy, lat - latAccuracy, lng + lngAccuracy, lat + latAccuracy )
