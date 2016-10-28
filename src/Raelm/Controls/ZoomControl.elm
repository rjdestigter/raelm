module Raelm.Controls.ZoomControl exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Raelm.Types.Coordinates exposing (..)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Base.Messages exposing (EventMsg(..))

buttonStyle = style [ ("padding", "10px")
                    , ("text-align", "center")
                    , ("display", "flex")
                    , ("alignItems", "center")
                    , ("justifyContent", "center")
                    , ("width", "20px")
                    , ("height", "20px")
                    , ("cursor", "pointer")
                    ]

button : String -> (Int -> Int -> Int) -> Zoom -> Html EventMsg
button lbl fn zoom =
  div [ buttonStyle
      , (onClick (Scroll (fn zoom 1)))
      ]
      [text lbl ]

view : (List (String, String) -> List (String, String)) -> Zoom -> Html EventMsg
view t zoom =
  div [ style (t [ ("position", "absolute")
              , ("backgroundColor", "#ffffff")
              , ("top", "100px")
              , ("left", "50px")
              , ("box-shadow", " 0 0 2px rgba(0, 0, 0, 0.4)")
              ])
      ]
      [ button "+" (+) zoom
      , button "-" (-) zoom
      ]
