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
-- Use Base for Mouse events
import Raelm.Base.Messages exposing(EventMsg)
import Raelm.Base.Views exposing (..)

-- Use Map for MapMessages
import Raelm.Map.Views exposing (..)
import Raelm.Map.Messages exposing(MapEvent, MapMessage(..))

-- Translates between Base and Map
eventMapper : EventMsg -> MapMessage
eventMapper event =
  case event of
    Raelm.Base.Messages.Init i ->
      Event (Raelm.Map.Messages.Init i)
    Raelm.Base.Messages.Click (x, y) ->
      Event (Raelm.Map.Messages.Click ( toFloat x, toFloat y))
    Raelm.Base.Messages.Move (x, y) ->
      Event (Raelm.Map.Messages.Move ( toFloat x, toFloat y ))
    Raelm.Base.Messages.Scroll z ->
      Zoom z

-- Exports
-- view : AppModel -> Html a
view model =
    let
      baseView = Raelm.Base.Views.mouseView "myMap"
    in
      div [ style [ ("height", "100%"), ("backgroundColor", "Cyan") ] ]
        [ Html.App.map RaelmMsg (Raelm.Map.Views.view (eventMapper) (baseView) model.mapModel) ]
