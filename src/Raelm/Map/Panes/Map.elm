module Raelm.Map.Panes.Map exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing(style, class)

import DOM exposing (Rectangle)
import Raelm.Utils.Style exposing (toPixel)

const_MAP_PANE_CLASS = "raelm-map-pane"

mapPaneStyle : Float -> Float -> List (String, String)
mapPaneStyle x y =
  [ ("position", "absolute")
  , ("transform", "translateX(" ++ (toPixel x) ++ ") translateY(" ++ (toPixel y) ++ ")")
  , ("top", "0px")
  , ("left", "0px")
  ]

mapPane : Maybe Rectangle -> Html a -> Html a
mapPane rectangle children =
  let
    (x, y) =
      case rectangle of
        Just {top, left, width, height} ->
          (left, top)
        Nothing ->
          (0, 0)
  in
    div [ style (mapPaneStyle x y)
        , class const_MAP_PANE_CLASS
        ]
        [ children
        ]
