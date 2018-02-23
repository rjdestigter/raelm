module Raelm.Geometry.Point exposing (..)


type alias Point =
    ( Float, Float )


toFloat : ( Int, Int ) -> Point
toFloat ( x, y ) =
    ( Basics.toFloat x, Basics.toFloat y )


point : Float -> Float -> Point
point x y =
    ( x, y )


combine : (Float -> Float -> Float) -> Point -> Point -> Point
combine f ( x1, y1 ) ( x2, y2 ) =
    ( f x1 x2, f y1 y2 )


map : (Float -> Float) -> Point -> Point
map f ( x, y ) =
    ( f x, f y )


fold : (Float -> Float -> a) -> Point -> a
fold f ( x, y ) =
    f x y


add : Point -> Point -> Point
add =
    combine (+)


subtract : Point -> Point -> Point
subtract =
    combine (-)


multiply : Point -> Point -> Point
multiply =
    combine (*)


divide : Point -> Point -> Point
divide =
    combine (/)


divideBy : Float -> Point -> Point
divideBy factor =
    flip divide ( factor, factor )


multiplyBy : Float -> Point -> Point
multiplyBy factor =
    flip multiply ( factor, factor )


scaleBy : Point -> Point -> Point
scaleBy =
    multiply


unscaleBy : Point -> Point -> Point
unscaleBy =
    divide


round : Point -> Point
round =
    map (Basics.round >> Basics.toFloat)


floor : Point -> Point
floor =
    map (Basics.floor >> Basics.toFloat)


ceil : Point -> Point
ceil =
    map (Basics.ceiling >> Basics.toFloat)


distance : Point -> Point -> Float
distance ( x1, y1 ) ( x2, y2 ) =
    let
        x =
            x2 - x1

        y =
            y2 - y1
    in
        x
            * x
            + y
            * y
            |> Basics.sqrt


equals : Point -> Point -> Bool
equals ( x1, y1 ) ( x2, y2 ) =
    x1 == x2 && y1 == y2


contains : Point -> Point -> Bool
contains ( x1, y1 ) ( x2, y2 ) =
    Basics.abs (x2)
        <= Basics.abs (x1)
        && Basics.abs (y2)
        <= Basics.abs (y1)


toString : Point -> String
toString ( x, y ) =
    "Point(" ++ Basics.toString x ++ "," ++ Basics.toString y ++ ")"
