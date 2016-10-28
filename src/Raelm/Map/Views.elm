module Raelm.Map.Views exposing (..)

import Html.App
import Html exposing (Html, span, div, text)
import Html.Attributes exposing (style)

import String exposing (concat, join)

-- Local imports
import Raelm.Types.Options exposing (LayerOptions)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapModel)

import Raelm.Map.Panes.Map exposing (mapPane)
import Raelm.Layer.Tile exposing (tileLayer)
import Raelm.Layer.Tile.Types exposing (TileOptionSet(..))

import Raelm.Types.Coordinates exposing (..)
import Raelm.Utils.Coordinates exposing (..)
import Raelm.Utils.Style exposing (toPixel)

import Raelm.Map exposing (defaultRaelm)

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

t : List (String, String) -> Point -> List (String, String)
t s (x, y) =
  List.concat [s, [ ("position", "absolute")
  , ("transform", "translateX(" ++ (toPixel x) ++ ") translateY(" ++ (toPixel y) ++ ")")
  , ("top", "0px")
  , ("left", "0px")
  ]]

openStreetMap = tileLayer (Just "http") (LayerOption layerOptions)

children : MapModel -> Html a
children raelmModel =
  let
    map = defaultRaelm raelmModel
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
                      , ("display", "flex")
                      , ("justify-content", "space-around")
                      ] (subtractPoint (0, 0) map.getMapPanePos))
              ]
              [ coords "Centre (lng,lat)" (toFixed 2 map.getCentre)
              , coords "Mouse (lng, lat)" (toFixed 2 map.mouseLngLat)
              , coords "Mouse (x, y)" (toFixed 2 map.mousePoint)
              , coords "Pane (x, y)" (toFixed 2 map.getMapPanePos)
              ]
          , openStreetMap map
        ]

-- view : (a -> b) -> c -> MapModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.initialized (mapPane raelmModel.dom.rect (children raelmModel))
  in
    Html.App.map eventMapper renderedView
