module Raelm.Geo.CRS exposing (..)

import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geo.LngLatBounds as LngLatBounds exposing (LngLatBounds)
import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Raelm.Core.Util exposing (wrapNum)


type alias Zoom =
    Float


type alias Scale =
    Zoom -> Float


type alias Transform =
    Point -> Float -> Point


type alias Untransform =
    Transform


type alias Project =
    LngLat -> Point


type alias Unproject =
    Point -> LngLat


lngLatToPoint : Project -> Scale -> Transform -> LngLat -> Zoom -> Point
lngLatToPoint project scale transform lnglat zoom =
    let
        projectedPoint =
            project lnglat

        scaled =
            scale zoom
    in
        transform projectedPoint scaled


pointToLngLat : Unproject -> Scale -> Untransform -> Point -> Zoom -> LngLat
pointToLngLat unproject scale untransform point zoom =
    let
        zoomScale =
            scale zoom

        untransformedPoint =
            untransform point zoomScale
    in
        unproject untransformedPoint


scale : Zoom -> Float
scale zoom =
    256 * (2 ^ zoom)


zoom : Float -> Zoom
zoom scale =
    let
        log =
            logBase Basics.e
    in
        (log (scale / 256)) / (log 2)


getProjectedBounds : Bounds -> Scale -> Transform -> Zoom -> Bounds
getProjectedBounds ( minX, minY, maxX, maxY ) scale transform zoom =
    let
        s =
            scale zoom

        min =
            transform ( minX, minY ) s

        max =
            transform ( maxX, maxY ) s
    in
        Bounds.bounds min max


infinite : Bool
infinite =
    False


wrapLngLat : Maybe ( Float, Float ) -> Maybe ( Float, Float ) -> LngLat -> LngLat
wrapLngLat wrapLng wrapLat ( lng, lat, alt ) =
    let
        nextLng =
            case wrapLng of
                Just wl ->
                    wrapNum lng wl True

                Nothing ->
                    lng

        nextLat =
            case wrapLat of
                Just wl ->
                    wrapNum lat wl True

                Nothing ->
                    lat
    in
        ( nextLng, nextLat, alt )
