module Raelm.Map.Update exposing (..)

import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapPositionModel)
import Raelm.Types.Coordinates exposing (X, Y, Z, XY)

zoomTo : MapPositionModel -> Z -> MapPositionModel
zoomTo model z = ({ model | zoom = z })

centre : MapPositionModel -> XY -> MapPositionModel
centre model (x, y) = ({ model | centre = (x, y) })
-- panTo model (fromX, fromY, toX, toY) = ({ model | centre = (toX, toY) })

update : MapMessage -> MapPositionModel -> ( MapPositionModel, Cmd MapMessage )
update message model =
  case message of
    Centre (x, y) ->
      (centre model (x, y), Cmd.none)
    Zoom z ->
      (zoomTo model z, Cmd.none)
    Pan (fromX, fromY, toX, toY) ->
      (centre model (toX, toY), Cmd.none)
