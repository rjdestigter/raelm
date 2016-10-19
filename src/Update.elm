module Update exposing (..)

import Messages exposing (Msg(RaelmMsg))
import Models exposing (AppModel)
import Raelm.Map.Update exposing (..)

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
  case message of
    RaelmMsg subMsg ->
      let
        ( updatedMapModel, mapCmd ) =
          Raelm.Map.Update.update subMsg model.mapModel
      in
        ( { model | mapModel = updatedMapModel }, Cmd.map RaelmMsg mapCmd )
