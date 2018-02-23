module Main exposing (..)

import Debug
import Html exposing (Html, button, div, program, text)
import Html.Events exposing (onClick)
import Lazy exposing (Lazy, force, lazy)


-- MODEL


type Lang
    = En
    | Fr


type alias Model =
    { counter : Int
    , expensive : Lazy String
    , lang : Lang
    }


thunk : a -> (a -> b) -> (() -> b)
thunk a fn =
    \() -> fn a


expensive : Int -> String
expensive n =
    let
        void =
            Debug.log "Expensive eh!" n
    in
        List.range n 100000 |> List.sum |> toString |> String.append "Well!, that was expensive: "


createSelector n =
    thunk n expensive |> lazy


initialModel =
    Model 0 (createSelector 0) En


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGES


type Msg
    = Increment Int
    | SwitchLang
    | Dull (Lazy String)



-- VIEW


view : Model -> Html Msg
view model =
    let
        void =
            Debug.log "Rendering and thus forcing!" 42
    in
        div []
            [ button [ onClick (Increment 2) ] [ text "+" ]
            , button [ onClick (SwitchLang) ] [ text (toString model.lang) ]
            , button [ onClick (Dull (createSelector (model.counter ^ 2))) ] [ text (toString model.lang) ]
            , div []
                [ model.counter |> toString |> String.append "Counter: " |> text
                ]
            , div []
                [ model.expensive |> force |> String.append "Expensive: " |> text
                ]
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Dull lz ->
            ( { model | expensive = lz, counter = model.counter ^ 2 }, Cmd.none )

        SwitchLang ->
            let
                nextModel =
                    case model.lang of
                        En ->
                            { model | lang = Fr }

                        _ ->
                            { model | lang = En }
            in
                ( nextModel, Cmd.none )

        Increment howMuch ->
            let
                nextCounter =
                    model.counter + howMuch
            in
                ( Model nextCounter (createSelector nextCounter) model.lang, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
