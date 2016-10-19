module Raelm.Map.Views exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Json exposing ((:=))

import Raelm.Base.Views exposing (..)
-- import Raelm.Base.Styles exposing (raelmContainer)
import Raelm.Map.Messages exposing (MapMessage(Centre))

import Raelm.Map.Models exposing (MapPositionModel)

type alias Position =
  (Float, Float)

decoder : Json.Decoder (Float, Float)
decoder =
  Json.object2 (,)
    ("offsetX" := Json.float)
    ("offsetY" := Json.float)

onClick =
  on "click" ( Json.map Centre decoder )

--children : MapPositionModel -> Html.Html a
children {centre} =
  let
    (x, y) = centre
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("height", "80%")
                ]
        , onClick
        ]
    [ text (toString x)
    , text ","
    , text (toString y)
    ]

view : MapPositionModel -> Html MapMessage
view mapPositionModel = Raelm.Base.Views.view (children mapPositionModel)
