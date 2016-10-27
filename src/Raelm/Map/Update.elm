module Raelm.Map.Update exposing (..)

import Raelm.Map.Messages exposing (MapEvent(..), MapMessage(..))
import Raelm.Map.Models exposing (MapModel, MapEventsModel, DomModel)
import Raelm.Types.Coordinates exposing (X, Y, Z, XY)
import Raelm.Utils.Coordinates exposing (..)
import Raelm.Geo.CRS.EPSG3857 exposing (latLngToPoint, pointToLatLng)
import DOM exposing (Rectangle)
import Debug exposing (..)
import Raelm.Map exposing (defaultMapType)

zoomTo : MapModel -> Z -> MapModel
zoomTo model z = ({ model | zoom = z })

centre : MapModel -> XY -> MapModel
centre model (x, y) = ({ model | centre = (x, y) })

initialized : Maybe Rectangle -> DomModel
initialized rect = DomModel True rect

init : MapModel -> Maybe Rectangle -> MapModel
init model rect = ({ model | dom = (initialized rect) })

-- halfSize = divideBy (width, height) 2
-- pixelCentre = latLngToPoint centre zoom
-- pixelOrigin = getPixelOrigin halfSize (left, top) centre zoom
-- projectedPoint = mapPoint (+) (mapPoint (-) events.move (left, top)) pixelOrigin
-- lngLat = pointToLatLng projectedPoint zoom

click : MapModel -> (Float, Float) -> MapModel
click model (x, y) =
  let
   events = (moveEvent x y model.events)
   centre =
     case model.dom.rect of
       Nothing -> model.centre
       Just {top, left, width, height} ->
         let
           halfSize = divideBy (width, height) 2
           pixelCentre = defaultMapType.crs.latLngToPoint model.centre model.zoom
           pixelOrigin = defaultMapType.getPixelOrigin (left, top) halfSize model.centre model.zoom
           projectedPoint = mapPoint (+) (mapPoint (-) (x, y) (left, top)) pixelOrigin
           lngLat = defaultMapType.crs.pointToLatLng projectedPoint model.zoom
         in
           lngLat
  in
    ({
      model
        | centre = centre
        , events = (clickEvent x y model.events)
    })

move : MapModel -> (Float, Float) -> MapModel
move model (x, y) =
  let
    dom = if model.events.down then updateRect x y model.events.downPosition model.dom else model.dom
    events = (moveEvent x y model.events)
    centre = model.centre
  in
   ({
    model
      | events = events
      , dom = dom
      , centre = centre
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

down : MapModel -> MapModel
down model = ({ model | events = (downEvent model.events) })

up : MapModel -> MapModel
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

update : MapMessage -> MapModel -> ( MapModel, Cmd MapMessage )
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
