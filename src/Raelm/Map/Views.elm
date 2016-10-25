module Raelm.Map.Views exposing (view)

import Html.App
import Html exposing (Html, span, div, text)
import Html.Attributes exposing (style)

import String exposing (concat, join)

-- Local imports
import Raelm.Types.Options exposing (LayerOptions)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapPositionModel)

import Raelm.Map.Panes.Map exposing (mapPane)
import Raelm.Layer.Tile exposing (tileLayer)
import Raelm.Layer.Tile.Types exposing (TileOptionSet(..))

import Raelm.Geo.CRS.EPSG3857 exposing (latLngToPoint, pointToLatLng)

import Raelm.Utils.Coordinates exposing (..)
import Raelm.Utils.Style exposing (toPixel)

layerOptions = LayerOptions Nothing Nothing Nothing Nothing

-- Exports
coords label (x, y) =
  span [ style [ ("padding", "0 15px") ] ]
    [ text label
    , text " ("
    , text (toString x)
    , text ","
    , text (toString y)
    , text ")"
    ]

hun (x, y) = (toFloat (round x), toFloat (round y))

t : List (String, String) -> Float -> Float -> List (String, String)
t s x y =
  List.concat [s, [ ("position", "absolute")
  , ("transform", "translateX(" ++ (toPixel x) ++ ") translateY(" ++ (toPixel y) ++ ")")
  , ("top", "0px")
  , ("left", "0px")
  ]]

children {centre, zoom, dom, events} =
  let
    (x, y) = events.click
    (downX, downY) =
      case events.downPosition of
        Just dp -> dp
        Nothing -> (-1, -1)

    (top, left, width, height) =
      case dom.rect of
        Nothing ->
          (0, 0, 0, 0)
        Just {top, left, width, height} ->
          (top, left, width, height)

    halfSize = divideBy (width, height) 2
    pixelCentre = latLngToPoint centre zoom
    pixelOrigin = addPoint (subtractPoint pixelCentre halfSize) (left, top)
    projectedPoint = mapPoint (+) (mapPoint (-) events.move (left, top)) pixelOrigin
    lngLat = pointToLatLng projectedPoint zoom
  in
    div [ style [ ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                ]
        ]
        [
          div [ style (t [ ("backgroundColor", "Yellow")
                      , ("position", "absolute")
                      , ("width", "100vw")
                      , ("height", "50px")
                      , ("zIndex", "10")
                      ] -left -top)
              ]
          [ coords "LngLat" centre
          , coords "origin" pixelOrigin
          , coords "Move" projectedPoint
          , coords "Down position" (downX, downY)
          , text (concat ["(", (join "," (List.map toString [top, left, width, height])), ")"])
          , text (if events.down then " isDown " else " isUp ")
          ]
          , tileLayer (Just "http") (LayerOption layerOptions) { centre = centre
                                                                , zoom = zoom
                                                                , size = (width, height)
                                                                , origin = pixelOrigin
                                                                }
        ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.initialized (mapPane raelmModel.dom.rect (children raelmModel))
  in
    Html.App.map eventMapper renderedView
