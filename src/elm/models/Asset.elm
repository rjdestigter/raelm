module Asset exposing (..)

import Html
import Dict exposing (Dict)
import Category exposing (..)


type alias Asset =
    { id : Int
    , label : String
    , category : Category
    , parent : Int
    , previous : List Int
    , season : Maybe Int
    }


type alias Region =
    { id : Int
    , label : String
    , parent : Int
    }


type alias Hub =
    { id : Int
    , label : String
    , parent : Int
    }


type alias Assets =
    Dict Int Asset


toList : Assets -> List Asset
toList assets =
    assets |> Dict.toList |> List.map right


right : ( a, b ) -> b
right ( a, b ) =
    b


toRegion : Asset -> Region
toRegion { id, label, parent } =
    Region id label parent


isRegion : Asset -> Bool
isRegion { category } =
    Category.toString category == Category.region


regions : Assets -> List Region
regions assets =
    assets |> toList |> List.filter isRegion |> List.map toRegion


main =
    Html.text "Hello World"
