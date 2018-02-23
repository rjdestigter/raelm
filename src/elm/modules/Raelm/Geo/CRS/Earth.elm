module Raelm.Geo.CRS.Earth exposing (..)

import Raelm.Geo.CRS as CRS exposing (..)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geometry.Bounds as Bounds exposing (Bounds)


wrapLng : ( Float, Float )
wrapLng =
    ( -180, 180 )


r : Float
r =
    6371000


distance : LngLat -> LngLat -> Float
distance ( lng1, lat1, _ ) ( lng2, lat2, _ ) =
    let
        rad =
            Basics.pi / 180

        lat3 =
            lat1 * rad

        lat4 =
            lat2 * rad

        sinDLat =
            (lat2 - lat1) * rad / 2 |> Basics.sin

        sinDLng =
            (lng2 - lng1) * rad / 2 |> Basics.sin

        a =
            sinDLat * sinDLat + (Basics.cos lat3) * (Basics.cos lat4) * sinDLng * sinDLng

        c =
            Basics.atan2 (Basics.sqrt a) (Basics.sqrt (1 - a)) |> (*) 2
    in
        r * c


lngLatToPoint : Project -> Scale -> Transform -> LngLat -> Zoom -> Point
lngLatToPoint =
    CRS.lngLatToPoint


pointToLngLat : Unproject -> Scale -> Untransform -> Point -> Zoom -> LngLat
pointToLngLat =
    CRS.pointToLngLat


scale : Zoom -> Float
scale =
    CRS.scale


zoom : Float -> Zoom
zoom =
    CRS.zoom


getProjectedBounds : Bounds -> Scale -> Transform -> Zoom -> Bounds
getProjectedBounds =
    CRS.getProjectedBounds


infinite : Bool
infinite =
    CRS.infinite


wrapLngLat : Maybe ( Float, Float ) -> Maybe ( Float, Float ) -> LngLat -> LngLat
wrapLngLat =
    CRS.wrapLngLat
