module ExTempo.Updates exposing (update)

import ExTempo.Models as Models exposing (..)
import ExTempo.Ports exposing (closeModal, updateTextFields)
import ExTempo.Updates.Events exposing (handleTick, handleInput)
import ExTempo.Updates.EditEntry exposing (editEntry)
import ExTempo.Updates.DeleteEntry exposing (deleteEntry)
import ExTempo.Updates.ValidateEntry exposing (validateEntry)
import ExTempo.Updates.Frames exposing (createFrames)


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
            let
                frames =
                    createFrames model.talk
            in
                { model
                    | action = Talking
                    , talkFrames = frames
                    , currentFrame = frames |> List.head
                }
                    ! []

        StopTalking ->
            { model
                | action = Reviewing
                , talkTime = 0
                , talkFrames = []
                , currentFrame = Nothing
            }
                ! []
