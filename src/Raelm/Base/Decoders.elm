module Raelm.Base.Decoders exposing (..)

import Json.Decode as Json exposing ((:=), andThen)
import Json.Decode exposing (Decoder)
import DOM exposing (..)

import Raelm.Base.Messages exposing (MouseEventMsg(MouseClick, MouseMove), EventMsg(Init))
import Raelm.Base.Messages exposing (TouchEventMsg(TouchTap))
import Raelm.Base.Types exposing (Initialize)

import Debug exposing (..)

type Node = Node
  { id : String
  , rectangle: Maybe Rectangle
  , parent : Maybe Node
  }

offsetDecoder : Json.Decoder (Int, Int)
offsetDecoder =
  Json.object2 (,)
    ("offsetX" := Json.int)
    ("offsetY" := Json.int)

lazy : (() -> Decoder a) -> Decoder a
lazy getDecoder =
    Json.customDecoder Json.value <|
       \rawValue ->
            Json.decodeValue (getDecoder ()) rawValue

newNode : String -> Maybe Rectangle -> Maybe Node -> Node
newNode id rectangle parent =
  Node
    { id = id
    , rectangle = rectangle
    , parent = parent
    }

nodeDecoder : Decoder Node
nodeDecoder =
  Json.object3 newNode
    ("id" := Json.string)
    (Json.map Just boundingClientRect)
    ("parentElement" :=
      Json.oneOf
      [ Json.null Nothing
      , Json.map Just (lazy (\_ -> nodeDecoder))
      ]
    )

clickDecoder t = Json.map t offsetDecoder

-- initialMapper : Node -> E
initialMapper mapId node =
  case node of
    Node {id, rectangle, parent} ->
      if id == mapId then
        case rectangle of
          Just rect ->
            Init (Initialize (Just rect))
          Nothing ->
            Init (Initialize Nothing)
      else
        case parent of
          Just parentNode ->
            initialMapper mapId parentNode
          Nothing ->
            Init (Initialize Nothing)

initializeDecoder mapId = Json.map (initialMapper mapId) (target nodeDecoder)

mouseClickDecoder eventMapper =
  Json.map eventMapper (clickDecoder MouseClick)

mouseMoveDecoder eventMapper =
  Json.map eventMapper (clickDecoder MouseMove)

touchTapDecoder eventMapper =
  Json.map eventMapper (clickDecoder TouchTap)
