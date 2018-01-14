module Main exposing (main)

import Main.Models as Models exposing (..)
import Main.Ports as Ports exposing (..)
import Main.Views as Views exposing (view)
import Main.Updates as Updates exposing (update)
import Html exposing (Html, programWithFlags)
import Time exposing (Time, every, second)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, initPort "" )



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
