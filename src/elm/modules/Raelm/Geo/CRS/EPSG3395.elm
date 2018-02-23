module Raelm.Geo.CRS.EPSG3395 exposing (..)

import Raelm.Geo.Projection.Mercator as Projection
import Raelm.Geometry.Transformation as Transformation exposing (Transformation)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geo.CRS as CRS
import Raelm.Geo.CRS.Earth as Earth
import Raelm.Geometry.Bounds as Bounds exposing (Bounds)


code : String
code =
    "EPSG:3395"


project : LngLat -> Point
project =
    Projection.project


unproject : Point -> LngLat
unproject =
    Projection.unproject


transformation : Transformation
transformation =
    let
        scale =
            0.5 / (Basics.pi * Projection.r)
    in
        ( scale, 0.5, -scale, 0.5 )


transform : Point -> Float -> Point
transform =
    Transformation.transform transformation


transform1 : Point -> Point
transform1 =
    Transformation.transform1 transformation


untransform : Point -> Float -> Point
untransform =
    Transformation.transform transformation


untransform1 : Point -> Point
untransform1 =
    Transformation.transform1 transformation


distance : LngLat -> LngLat -> Float
distance =
    Earth.distance


bounds : Bounds
bounds =
    Projection.bounds


wrapLng : ( Float, Float )
wrapLng =
    Earth.wrapLng


r : Float
r =
    Earth.r


scale : CRS.Zoom -> Float
scale =
    Earth.scale


lngLatToPoint : LngLat -> CRS.Zoom -> Point
lngLatToPoint =
    Earth.lngLatToPoint project scale transform


pointToLngLat : Point -> CRS.Zoom -> LngLat
pointToLngLat =
    Earth.pointToLngLat unproject scale untransform


zoom : Float -> CRS.Zoom
zoom =
    Earth.zoom


getProjectedBounds : CRS.Zoom -> Bounds
getProjectedBounds =
    Earth.getProjectedBounds Projection.bounds Earth.scale transform


infinite : Bool
infinite =
    Earth.infinite


wrapLngLat : LngLat -> LngLat
wrapLngLat =
    Earth.wrapLngLat (Just Earth.wrapLng) Nothing
