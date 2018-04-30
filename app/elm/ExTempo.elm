module ExTempo exposing (main)

import ExTempo.Models exposing (..)
import ExTempo.Ports exposing (initPort)
import ExTempo.Views exposing (view)
import ExTempo.Updates exposing (update)
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
