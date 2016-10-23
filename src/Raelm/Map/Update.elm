module Raelm.Map.Update exposing (..)

import Raelm.Map.Messages exposing (MapEvent(Click, Move, Init), MapMessage(..))
import Raelm.Map.Models exposing (MapPositionModel, MapEventsModel, DomModel)
import Raelm.Types.Coordinates exposing (X, Y, Z, XY)
import DOM exposing (Rectangle)

import Debug exposing (..)

zoomTo : MapPositionModel -> Z -> MapPositionModel
zoomTo model z = ({ model | zoom = z })

centre : MapPositionModel -> XY -> MapPositionModel
centre model (x, y) = ({ model | centre = (x, y) })

initialized : Maybe Rectangle -> DomModel
initialized rect = DomModel True rect

init : MapPositionModel -> Maybe Rectangle -> MapPositionModel
init model rect = ({ model | dom = (initialized rect) })

click : MapPositionModel -> (Float, Float) -> MapPositionModel
click model (x, y) = ({ model | events = (clickEvent x y model.events) })

move : MapPositionModel -> (Float, Float) -> MapPositionModel
move model (x, y) = ({ model | events = (moveEvent x y model.events) })

clickEvent : Float -> Float -> MapEventsModel -> MapEventsModel
clickEvent x y mapEvent = ({mapEvent | click = (x, y)})

moveEvent : Float -> Float -> MapEventsModel -> MapEventsModel
moveEvent x y mapEvent = ({ mapEvent | move = (x, y)})

update : MapMessage -> MapPositionModel -> ( MapPositionModel, Cmd MapMessage )
update message model =

  case message of
    Centre (x, y) ->
      (centre model (x, y), Cmd.none)
    Zoom z ->
      (zoomTo model z, Cmd.none)
    Pan (fromX, fromY, toX, toY) ->
      (centre model (toX, toY), Cmd.none)
    Event mapEvent ->
      let
        x = log "n" mapEvent
      in
        case mapEvent of
          Init {boundingClientRect} ->
            (init model boundingClientRect, Cmd.none)
          Click (x, y) ->
            (click model (x, y), Cmd.none)
          Move (x, y) ->
            (move model (x, y), Cmd.none)
