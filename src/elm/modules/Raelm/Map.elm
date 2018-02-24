module Raelm.Map exposing (..)

import Html as H exposing (Html)
import Html.Attributes as A
import Raelm.Geo.CRS.EPSG3857 as Projection
import Raelm.Geometry.LngLat as LngLat exposing (LngLat)


type alias Model =
    { center : LngLat
    , zoom : Float
    }


toPixel x =
    toString x ++ "px"


styles x y =
    A.style
        [ ( "height", "100%" )
        , ( "width", "100%" )
        , ( "background-color", "Pink" )
        , ( "overflow", "hidden" )
        , ( "position", "absolute" )
        , ( "transform", "translateX(" ++ (toPixel x) ++ ") translateY(" ++ (toPixel y) ++ ")" )
        , ( "top", "0px" )
        , ( "left", "0px" )
        ]


render : Html a
render =
    H.div [ styles 0 0 ] []


main =
    render
