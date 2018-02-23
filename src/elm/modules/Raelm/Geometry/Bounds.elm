module Raelm.Geometry.Bounds exposing (..)

import Raelm.Geometry.Point as Point exposing (Point, point)


type alias Bounds =
    ( Float, Float, Float, Float )


min : Bounds -> Point
min ( minX, minY, _, _ ) =
    ( minX, minY )


max : Bounds -> Point
max ( _, _, maxX, maxY ) =
    ( maxX, maxY )


fromPoint : Point -> Bounds
fromPoint ( x, y ) =
    ( x, y, x, y )


extend : Bounds -> Point -> Bounds
extend ( minX, minY, maxX, maxY ) ( x, y ) =
    ( Basics.min x minX, Basics.min y minY, Basics.max x maxX, Basics.max y maxY )


bounds : Point -> Point -> Bounds
bounds p1 p2 =
    p1 |> fromPoint |> (flip extend) p2


getCenter : Bounds -> Point
getCenter bounds =
    Point.add (min bounds) (max bounds) |> Point.divideBy 2


getBottomLeft : Bounds -> Point
getBottomLeft ( minX, _, _, maxY ) =
    ( minX, maxY )


getTopRight : Bounds -> Point
getTopRight ( _, minY, maxX, _ ) =
    ( maxX, minY )


getTopLeft : Bounds -> Point
getTopLeft =
    min


getBottomRight : Bounds -> Point
getBottomRight =
    max


getSize : Bounds -> Point
getSize bounds =
    min bounds |> Point.subtract (max bounds)


contains : Bounds -> Bounds -> Bool
contains ( minX1, minY1, maxX1, maxY1 ) ( minX2, minY2, maxX2, maxY2 ) =
    minX2 >= minX1 && maxX2 <= maxX1 && minY2 >= minY1 && maxY2 <= maxY1


containsPoint : Bounds -> Point -> Bool
containsPoint bound point =
    fromPoint point |> contains bound


intersects : Bounds -> Bounds -> Bool
intersects ( minX1, minY1, maxX1, maxY1 ) ( minX2, minY2, maxX2, maxY2 ) =
    (maxX2 >= minX1) && (minX2 <= maxX1) && (maxY2 >= minY1) && (minY2 <= maxY1)


overlaps : Bounds -> Bounds -> Bool
overlaps ( minX1, minY1, maxX1, maxY1 ) ( minX2, minY2, maxX2, maxY2 ) =
    (maxX2 > minX1) && (minX2 < maxX1) && (maxY2 > minY1) && (minY2 < maxY1)
