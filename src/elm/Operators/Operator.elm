module Main exposing (..)


type alias Operator a =
    { id : String
    , data : a
    , submitting : Bool
    , success : Bool
    , errors : List (List ( String, String, String ))
    }
