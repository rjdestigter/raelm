module Raelm.Geo.Projection.Mercator
    exposing
        ( r
        , rMinor
        , bounds
        , project
        , unproject
        )

import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geo.LngLat as LngLat exposing (LngLat)


r : Float
r =
    6378137


rMinor : Float
rMinor =
    6356752.314245179


bounds : Bounds
bounds =
    Bounds.bounds ( -20037508.34279, -15496570.73972 ) ( 20037508.34279, 18764656.23138 )


project : LngLat -> Point
project ( lng, lat, _ ) =
    let
        d =
            Basics.pi / 180

        y =
            lat * d

        tmp =
            rMinor / r

        e =
            1
                - tmp
                * tmp
                |> Basics.sqrt

        con =
            y
                |> Basics.sin
                |> (*) e

        tanRes =
            Basics.pi
                / 4
                - y
                / 2
                |> Basics.tan

        powRes =
            ((1 - con) / (1 + con)) ^ (e / 2)

        ts =
            tanRes / powRes

        y2 =
            ts
                |> Basics.max 1.0e-10
                |> logBase Basics.e
                |> (*) -r
    in
        Point.point (lng * d * r) y2


unprojectLoop i ts e phi =
    let
        con =
            e * (Basics.sin phi)

        con1 =
            ((1 - con) / (1 + con)) ^ (e / 2)

        dphi =
            Basics.pi / 2 - 2 * (Basics.atan (ts * con1)) - phi

        phi2 =
            phi + dphi
    in
        if (i < 15 && (Basics.abs dphi) > 1.0e-7) then
            unprojectLoop (i + 1) ts e phi2
        else
            phi2


unproject : Point -> LngLat
unproject ( px, py ) =
    let
        d =
            180 / Basics.pi

        tmp =
            rMinor / r

        e =
            Basics.sqrt (1 - tmp * tmp)

        ts =
            Basics.e ^ (-py / r)

        phi =
            Basics.pi / 2 - 2 * (Basics.atan ts)

        res =
            unprojectLoop 0 ts e phi
    in
        ( px * d / r, res * d, Nothing )
