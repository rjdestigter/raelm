module Raelm.Map exposing (..)

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Raelm.Geo.CRS.EPSG3857 as Projection
import Raelm.Geo.LngLat as LngLat exposing (LngLat)
import Raelm.Geometry.Point as Point exposing (Point)
import Raelm.Geometry.Bounds as Bounds exposing (Bounds)
import Json.Decode as Decode
import Debug


initialZoom : Float
initialZoom =
    1


mapSize =
    ( 512, 512 )


tileSize =
    ( 256, 256 )


initialCenter : LngLat
initialCenter =
    ( 0, 0, Nothing )


project lnglat zoom =
    Projection.lngLatToPoint lnglat zoom


unproject point zoom =
    Projection.pointToLngLat point zoom


getContainerPoint model pageX offsetLeft pageY offsetTop =
    let
        halfSize =
            Point.divideBy 2 model.size
    in
        ( pageX - offsetLeft, pageY - offsetTop ) |> Point.toFloat |> Point.add (Point.subtract model.mapPanePos halfSize)


decodeClickLocation model =
    Decode.map4
        (getContainerPoint model)
        (Decode.at [ "pageX" ] Decode.int)
        (Decode.at [ "target", "offsetLeft" ] Decode.int)
        (Decode.at [ "pageY" ] Decode.int)
        (Decode.at [ "target", "offsetTop" ] Decode.int)


onClickMap model =
    Decode.map
        (\a -> OnClick a)
        (decodeClickLocation model)


type alias Model =
    { center : LngLat
    , zoom : Float
    , mapPanePos : Point
    , size : Point
    }


type Action
    = OnClick Point


getPixelOrigin { size, center, zoom, mapPanePos } =
    let
        viewHalf =
            Point.divideBy 2 size

        projected =
            project center zoom
    in
        project center zoom |> flip Point.subtract viewHalf |> flip Point.add mapPanePos |> Point.round


getTiledPixelBounds model =
    let
        pixelCenter =
            project model.center model.zoom |> Point.floor

        halfSize =
            Point.divideBy 2 model.size
    in
        Bounds.bounds (Point.subtract pixelCenter halfSize) (Point.add pixelCenter halfSize)


pixelBoundsToTileRange bounds =
    Bounds.bounds
        (Bounds.min bounds
            |> flip Point.unscaleBy tileSize
            |> Point.floor
        )
        (Bounds.max bounds
            |> flip Point.unscaleBy tileSize
            |> Point.ceil
            |> flip Point.subtract ( 1, 1 )
        )


initialModel =
    Model initialCenter initialZoom ( 0, 0 ) mapSize


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
        , ( "box-shadow", "0 -2px 2px rgba(0, 0, 0, 0.2), 2px 0 2px rgba(0, 0, 0, 0.2), 0 2px 2px rgba(0, 0, 0, 0.2), -2px 0 2px rgba(0, 0, 0, 0.2)" )
        ]


render : Model -> Html Action
render model =
    H.div [ styles 0 0, E.on "click" (onClickMap model) ] (tiles model)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        OnClick mapPanePos ->
            ( { model | mapPanePos = mapPanePos }, Cmd.none )



-- MAIN


getTilePos model position =
    let
        origin =
            (getPixelOrigin model) |> flip unproject model.zoom |> flip project model.zoom
    in
        Point.scaleBy position tileSize |> flip Point.subtract origin


addTile model ( x, y ) =
    let
        ( tx, ty ) =
            ( x, y ) |> Point.toFloat |> getTilePos model
    in
        H.div
            [ A.style
                [ ( "position", "absolute" )
                , ( "left", toString tx ++ "px" )
                , ( "top", toString ty ++ "px" )
                , ( "width", "256px" )
                , ( "height", "256px" )
                ]
            ]
            [ H.img
                [ (A.src ("https://a.tile.openstreetmap.org/" ++ toString model.zoom ++ "/" ++ toString x ++ "/" ++ toString y ++ ".png"))
                ]
                []
            ]


tiles model =
    let
        pixelBounds =
            getTiledPixelBounds model

        tileRange =
            pixelBoundsToTileRange pixelBounds

        tileCenter =
            Bounds.getCenter tileRange

        ( rangeMinx, rangeMinY, rangeMaxX, rangeMaxY ) =
            tileRange
    in
        List.range (Basics.round rangeMinY) (Basics.round rangeMaxY)
            |> List.concatMap
                (\y ->
                    List.range (Basics.round rangeMinx) (Basics.round rangeMaxX)
                        |> List.map
                            (\x ->
                                addTile model ( x, y )
                            )
                )


main : Program Never Model Action
main =
    H.program
        { init = ( initialModel, Cmd.none )
        , view = render
        , update = update
        , subscriptions = subscriptions
        }
