module ExTempo.Updates.Events exposing (handleTick, handleInput)

import ExTempo.Models as Models exposing (..)
import ExTempo.Ports exposing (..)
import ExTempo.Views.Helpers exposing (stringToInt)
import ExTempo.Updates.Frames exposing (getCurrentFrame)


handleTick : Model -> ( Model, Cmd Msg )
handleTick model =
    if model.action == Talking then
        let
            newModel =
                { model | talkTime = model.talkTime + 1 }
        in
            { newModel | currentFrame = getCurrentFrame newModel } ! []
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
