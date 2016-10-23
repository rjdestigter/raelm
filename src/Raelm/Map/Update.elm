module Raelm.Map.Update exposing (..)

import Raelm.Map.Messages exposing (MapEvent(..), MapMessage(..))
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
click model (x, y) = ({
  model
    | events = (clickEvent x y model.events)
  })

move : MapPositionModel -> (Float, Float) -> MapPositionModel
move model (x, y) = ({
  model
    | events = (moveEvent x y model.events)
    , dom = if model.events.down then updateRect x y model.events.downPosition model.dom else model.dom
  })

updateRect : Float -> Float -> Maybe (Float, Float) -> {initialized: Bool, rect: Maybe Rectangle} -> DomModel
updateRect x y downPosition {initialized, rect} =
  if initialized == False then
    DomModel False Nothing
  else
    let
      (movedX, movedY) =
        case downPosition of
          Nothing -> (0, 0)
          Just (px, py) ->
            (x - px, y - py)
    in
      case rect of
        Just rectangle ->
          DomModel True (Just (Rectangle (rectangle.top + movedY) (rectangle.left + movedX) rectangle.width rectangle.height))
        Nothing ->
          DomModel False Nothing

down : MapPositionModel -> MapPositionModel
down model = ({ model | events = (downEvent model.events) })

up : MapPositionModel -> MapPositionModel
up model = ({ model | events = (upEvent model.events) })

clickEvent : Float -> Float -> MapEventsModel -> MapEventsModel
clickEvent x y mapEvent = ({
  mapEvent
    | click = (x, y)
  })

moveEvent : Float -> Float -> MapEventsModel -> MapEventsModel
moveEvent x y mapEvent = ({
  mapEvent
    | move = (x, y)
    , downPosition =
      if mapEvent.down == True then
        Just (x, y)
      else
        Nothing
  })

downEvent : MapEventsModel -> MapEventsModel
downEvent mapEvent = ({
  mapEvent
    | down = True
    , downPosition = Just mapEvent.move
  })

upEvent : MapEventsModel -> MapEventsModel
upEvent mapEvent = ({
  mapEvent
  | down = False
  , downPosition = Nothing
  })

update : MapMessage -> MapPositionModel -> ( MapPositionModel, Cmd MapMessage )
update message model =
  let
    d = 4 -- Debug.log "event" (message, model)
  in
    case message of
      Centre (x, y) ->
        (centre model (x, y), Cmd.none)
      Zoom z ->
        (zoomTo model z, Cmd.none)
      Pan (fromX, fromY, toX, toY) ->
        (centre model (toX, toY), Cmd.none)
      Event mapEvent ->
        case mapEvent of
          Init {boundingClientRect} ->
            (init model boundingClientRect, Cmd.none)
          Click (x, y) ->
            (click model (x, y), Cmd.none)
          Move (x, y) ->
            (move model (x, y), Cmd.none)
          Down ->
            (down model, Cmd.none)
          Up ->
            (up model, Cmd.none)
