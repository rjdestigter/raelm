module Raelm.Geometry.Transformation exposing (..)

import Raelm.Geometry.Point as Point exposing (Point)


type alias Transformation =
    ( Float, Float, Float, Float )


transform : Transformation -> Point -> Float -> Point
transform ( a, b, c, d ) ( x, y ) scale =
    let
        nextX =
            scale * (a * x + b)

        nextY =
            scale * (c * y + d)
    in
        ( nextX, nextY )


transform1 : Transformation -> Point -> Point
transform1 transformation point =
    transform transformation point 1


untransform : Transformation -> Point -> Float -> Point
untransform ( a, b, c, d ) ( x, y ) scale =
    let
        nextX =
            (x / scale - b) / a

        nextY =
            (y / scale - d) / c
    in
        ( nextX, nextY )


untransform1 : Transformation -> Point -> Point
untransform1 transformation point =
    untransform transformation point 1
