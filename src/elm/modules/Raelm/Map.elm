module Raelm.Map exposing (..)

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Raelm.Geo.CRS.EPSG3857 as Projection
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geometry.Point as Point exposing (Point)
import Json.Decode as Decode
import Debug


z =
    1


sz =
    ( 512, 512 )


project lnglat zoom =
    Projection.lngLatToPoint lnglat zoom


unproject point zoom =
    Projection.pointToLngLat point zoom


bar pageX offsetLeft pageY offsetTop =
    let
        res =
            ( pageX - offsetLeft |> toFloat, pageY - offsetTop |> toFloat )

        void1 =
            Debug.log "ltlng" (unproject res z)

        void =
            Debug.log "res" res
    in
        res


decodeClickLocation : Decode.Decoder ( Float, Float )
decodeClickLocation =
    Decode.map4
        bar
        (Decode.at [ "pageX" ] Decode.int)
        (Decode.at [ "target", "offsetLeft" ] Decode.int)
        (Decode.at [ "pageY" ] Decode.int)
        (Decode.at [ "target", "offsetTop" ] Decode.int)


foo =
    Decode.map
        (\a -> OnClick a)
        decodeClickLocation


type alias Model =
    { center : LngLat
    , zoom : Float
    , origin : LngLat
    , size : ( Float, Float )
    }


type Action
    = OnClick ( Float, Float )


getPixelOrigin size center zoom =
    let
        viewHalf =
            Point.divideBy 2 size
    in
        project center zoom |> Point.subtract viewHalf |> Point.add


initialModel =
    Model ( 0, 0, Nothing ) (z) ( 0, 0, Nothing ) ( 512, 512 )


toPixel x =
    toString x ++ "px"


styles x y =
    A.style
        [ ( "height", "512px" )
        , ( "width", "512px" )
        , ( "background-color", "Pink" )
        , ( "overflow", "hidden" )
        , ( "position", "absolute" )
        , ( "top", "100px" )
        , ( "left", "100px" )
        ]


render : Model -> Html Action
render model =
    H.div [ styles 0 0, E.on "click" (foo) ] []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    ( model, Cmd.none )



-- MAIN


main : Program Never Model Action
main =
    H.program
        { init = ( initialModel, Cmd.none )
        , view = render
        , update = update
        , subscriptions = subscriptions
        }
