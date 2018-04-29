module Main.Updates exposing (update)

import Main.Models as Models exposing (..)
import Main.Ports exposing (closeModal)
import Main.Updates.SaveInput exposing (saveEntry)
import Main.Updates.Events exposing (handleTick, handleInput)
import Main.Updates.Editing exposing (editEntry)
import Main.Updates.Validation exposing (isValidEntry, addErrors)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Tick _ ->
            handleTick model

        ClearEntry ->
            { model
                | newEntry = blankEntry
                , action = Reviewing
            }
                ! [ closeModal "editing-modal" ]

        EditEntry entryType ->
            editEntry model entryType

        UserInput data ->
            handleInput model data

        ValidateEntry ->
            if isValidEntry model then
                (saveEntry model) ! [ closeModal "editing-modal" ]
            else
                (addErrors model) ! []

        StartTalk ->
            { model | action = Speaking } ! []

        StopTalk ->
            let
                talk =
                    model.talk

                newTalk =
                    { talk | time = 0 }
            in
                { model | action = Reviewing, talk = newTalk } ! []
