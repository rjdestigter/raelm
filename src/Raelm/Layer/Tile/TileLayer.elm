module Raelm.Layer.Tile.TileLayer exposing (..)

-- Html imports
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)

import Raelm.Layer.Tile.Types exposing (..)

-- Exports
view url options =
  let
    tileOptions = getTileOptions url options
  in
    div [ class "raelm-layer"
        , style [ ("opacity", toString tileOptions.opacity)
                , ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                , ("backgroundColor", "Lime")
                , ("height", "100%")
                ]
        ]
      [ text "My Tile Layer"
      , text (
        case tileOptions.url of
          Just x -> x
          Nothing -> "No url provided"
      )
      ]
