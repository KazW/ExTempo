module Main.Updates.Events exposing (handleTick, handleInput)

import Main.Models as Models exposing (..)
import Main.Ports exposing (..)
import Main.Views.Helpers exposing (stringToInt)


handleTick : Model -> ( Model, Cmd Msg )
handleTick model =
    let
        talk =
            model.talk

        newTalk =
            { talk | time = model.talk.time + 1 }
    in
        if model.action == Speaking then
            { model | talk = newTalk } ! []
        else
            model ! [ updateTextFields "" ]


handleInput : Model -> NewInput -> ( Model, Cmd Msg )
handleInput model data =
    let
        oldEntry =
            model.newEntry

        newEntry =
            case data of
                Title input ->
                    { oldEntry | title = input }

                Minutes input ->
                    { oldEntry | minutes = stringToInt input }

                Seconds input ->
                    { oldEntry | seconds = stringToInt input }
    in
        { model | newEntry = newEntry } ! [ updateTextFields "" ]
