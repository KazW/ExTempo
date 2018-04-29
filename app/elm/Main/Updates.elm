module Main.Updates exposing (update)

import Main.Models as Models exposing (..)
import Main.Ports exposing (closeModal, updateTextFields)
import Main.Updates.Events exposing (handleTick, handleInput)
import Main.Updates.EditEntry exposing (editEntry)
import Main.Updates.DeleteEntry exposing (deleteEntry)
import Main.Updates.ValidateEntry exposing (validateEntry)
import Main.Updates.Frames exposing (createFrames)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        StartTalking ->
            { model | action = Talking, talkFrames = createFrames model.talk } ! []

        StopTalking ->
            { model | action = Reviewing, talkTime = 0, talkFrames = [] } ! []
