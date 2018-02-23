module Raelm.Geo.Projection.SphericalMercator
    exposing
        ( project
        , unproject
        , bounds
        , r
        , maxLatitude
        )

import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Debug


r : Float
r =
    6378137


maxLatitude : Float
maxLatitude =
    85.0511287798


project : LngLat -> Point
project ( lng, lat, _ ) =
    let
        d =
            Basics.pi / 180

        max =
            maxLatitude

        lat2 =
            Basics.min max lat |> Basics.max -max

        sin =
            lat2
                * d
                |> Basics.sin

        log =
            logBase Basics.e

        x =
            r * lng * d

        void =
            Debug.log "sin" sin

        y =
            -- (1 + sin) / (1 - sin) |> log |> flip (/) 2 |> (*) r
            r * (log ((1 + sin) / (1 - sin))) / 2
    in
        ( x, y )


unproject : Point -> LngLat
unproject ( x, y ) =
    let
        exp =
            (^) Basics.e

        d =
            180 / Basics.pi

        lng =
            x * d / r

        lat =
            (2 * Basics.atan (exp (y / r)) - (Basics.pi / 2)) * d
    in
        ( lng, lat, Nothing )


bounds : Bounds
bounds =
    Bounds.bounds ( -180, -90 ) ( 180, 90 )
