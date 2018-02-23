module Raelm.Geo.Projection.LngLat
    exposing
        ( project
        , unproject
        , bounds
        )

import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)


project : LngLat -> Point
project ( lng, lat, _ ) =
    Point.point lng lat


unproject : Point -> LngLat
unproject ( x, y ) =
    ( x, y, Nothing )


bounds : Bounds
bounds =
    Bounds.bounds ( -180, -90 ) ( 180, 90 )
