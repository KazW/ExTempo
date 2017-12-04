module Main exposing (..)

import Html exposing (Html, programWithFlags)
import Main.Models as Models exposing (..)
import Main.Ports as Ports exposing (..)
import Main.Pages as Pages exposing (..)
import Time exposing (Time, every, second)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, initPort "" )



-- VIEW


view : Model -> Html Msg
view model =
    pages model



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Tick time ->
            { model | currentTime = Just time } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    every second Tick



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
