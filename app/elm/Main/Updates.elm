module Main.Updates exposing (update)

import Main.Models as Models exposing (..)
import Main.Ports exposing (closeModal, updateTextFields)
import Main.Updates.Events exposing (handleTick, handleInput)
import Main.Updates.EditEntry exposing (editEntry)
import Main.Updates.DeleteEntry exposing (deleteEntry)
import Main.Updates.ValidateEntry exposing (validateEntry)


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
                , errorMessage = Nothing
            }
                ! [ closeModal "editing-modal" ]

        EditEntry entryType ->
            editEntry model entryType

        DeleteEntry entryType ->
            deleteEntry model entryType

        UserInput data ->
            handleInput model data

        ValidateEntry ->
            validateEntry model

        StartTalk ->
            { model | action = Speaking } ! []

        StopTalk ->
            { model | action = Reviewing, talkTime = 0 } ! []
