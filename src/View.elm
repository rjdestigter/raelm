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
import Raelm.Base.Messages exposing(EventMsg(..))
import Raelm.Map.Messages exposing(MapMessage(..))
-- import Raelm.Base.Types exposing (EventMode(..))

-- Maps a local event message into a MapMessage
eventMapper : EventMsg -> MapMessage
eventMapper event =
  case event of
    Click (x, y) ->
      Centre ( toFloat x, toFloat y)
    Move (x, y) ->
      Pan ( toFloat x, toFloat y, 0, 0)
    Scroll z ->
      Zoom z

-- Exports
-- view : AppModel -> Html a
view model =
    let
      baseView = Raelm.Base.Views.mouseView
    in
      div [ style [ ("height", "100%"), ("backgroundColor", "Cyan") ] ]
        [ Html.App.map RaelmMsg (Raelm.Map.Views.view (eventMapper) (baseView) model.mapModel) ]
