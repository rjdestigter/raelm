module Raelm.Core.Util exposing (..)


foo : number -> Int
foo n =
    n * 1000000 |> Basics.round


unfoo : Int -> Float
unfoo n =
    toFloat n / 1000000


wrapNum : Float -> ( Float, Float ) -> Bool -> Float
wrapNum x ( min, max ) includeMax =
    let
        d =
            max - min |> foo
    in
        if (x == max && includeMax == True) then
            x
        else
            (((x - min |> foo) % d + d) % d + (foo min)) |> unfoo
