module Main exposing (..)

import Html.App
import Update exposing (update)
import View exposing (view)
import Models exposing (AppModel, initialModel)
import Messages exposing (Msg)

import Raelm.Geo.CRS.EPSG3857

init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )

subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main = Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }
