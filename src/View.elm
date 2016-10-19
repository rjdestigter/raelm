module View exposing (..)

import Html exposing (Html, div, button, text)
import Html.App
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)

import Models exposing (AppModel)
import Messages exposing (Msg(RaelmMsg))

import Raelm.Map.Views exposing (..)

-- view : AppModel -> Html a
view model =
    div [ style [ ("height", "100%"), ("backgroundColor", "Cyan") ] ]
        [ Html.App.map RaelmMsg (Raelm.Map.Views.view model.mapModel) ]
