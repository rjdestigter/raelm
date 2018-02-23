module Raelm.Geo.LngLatBounds exposing (..)

import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)


type alias LngLatBounds =
    Bounds


pad : LngLatBounds -> Float -> LngLatBounds
pad ( minLng, minLat, maxLng, maxLat ) bufferRatio =
    let
        widthBuffer =
            minLng - maxLng |> Basics.abs |> (*) bufferRatio

        heightBuffer =
            minLat - maxLat |> Basics.abs |> (*) bufferRatio
    in
        ( minLng - widthBuffer, minLat - heightBuffer, maxLng + widthBuffer, maxLat + heightBuffer )


getCenter : LngLatBounds -> LngLat
getCenter =
    Bounds.getCenter >> LngLat.fromPoint


getSouthWest : LngLatBounds -> LngLat
getSouthWest ( minLng, minLat, _, _ ) =
    ( minLng, minLat, Nothing )


getNorthEast : LngLatBounds -> LngLat
getNorthEast ( _, _, maxLng, maxLat ) =
    ( maxLng, maxLat, Nothing )


getNorthWest : LngLatBounds -> LngLat
getNorthWest ( minLng, _, _, maxLat ) =
    ( minLng, maxLat, Nothing )


getSouthEast : LngLatBounds -> LngLat
getSouthEast ( _, minLat, maxLng, _ ) =
    ( maxLng, minLat, Nothing )


getWest : LngLatBounds -> Float
getWest ( minLng, _, _, _ ) =
    minLng


getSouth : LngLatBounds -> Float
getSouth ( _, minLat, _, _ ) =
    minLat


getEast : LngLatBounds -> Float
getEast ( _, _, maxLng, _ ) =
    maxLng


getNorth : LngLatBounds -> Float
getNorth ( _, _, _, maxLat ) =
    maxLat


contains : LngLatBounds -> LngLatBounds -> Bool
contains =
    Bounds.contains


intersects : LngLatBounds -> LngLatBounds -> Bool
intersects =
    Bounds.intersects


toBBoxString : LngLatBounds -> String
toBBoxString ( minLng, minLat, maxLng, maxLat ) =
    [ minLng, minLat, maxLng, maxLat ] |> List.map Basics.toString |> String.join ","


equals : LngLatBounds -> LngLatBounds -> Bool
equals bounds1 bounds2 =
    LngLat.equals (getSouthWest bounds1) (getSouthWest bounds2)
        && LngLat.equals (getNorthEast bounds1) (getNorthEast bounds2)


equalsWithMargin : Float -> LngLatBounds -> LngLatBounds -> Bool
equalsWithMargin maxMargin bounds1 bounds2 =
    LngLat.equalsWithMargin maxMargin (getSouthWest bounds1) (getSouthWest bounds2)
        && LngLat.equalsWithMargin maxMargin (getNorthEast bounds1) (getNorthEast bounds2)
