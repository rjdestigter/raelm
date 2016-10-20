module View exposing (..)

-- Elm imports
import Html exposing (Html, div, button, text)
import Html.App
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)

-- Local imports
import Models exposing (AppModel)
import Messages exposing (Msg(RaelmMsg))

-- Dependency imports
import Raelm.Map.Views exposing (..)
import Raelm.Base.Views exposing (..)
import Raelm.Base.MouseEvents exposing(eventMapper)
import Raelm.Base.Types exposing (EventMode(..))

-- Exports
-- view : AppModel -> Html a
view model =
    let
      baseView = Raelm.Base.Views.touchView
    in
      div [ style [ ("height", "100%"), ("backgroundColor", "Cyan") ] ]
        [ Html.App.map RaelmMsg (Raelm.Map.Views.view (eventMapper) (baseView) model.mapModel) ]
