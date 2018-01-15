module Main.Updates exposing (update)

import Main.Models as Models exposing (..)
import Main.Ports exposing (..)
import Main.Time exposing (..)
import Main.Views.Helpers exposing (stringToInt)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Tick _ ->
            if model.action == Speaking then
                { model | talkTime = model.talkTime + 1 } ! []
            else
                model ! [ updateTextFields "" ]

        ClearEntry ->
            { model
                | newEntry = blankEntry
                , action = Reviewing
            }
                ! [ closeModal "editing-modal" ]

        EditEntry entryType ->
            let
                oldEntry =
                    model.newEntry

                newEntry =
                    case entryType of
                        TalkType ->
                            { oldEntry
                                | title = model.talk.title
                                , minutes = (secondsToMinutes model.talk.duration)
                                , seconds = (remainingSeconds model.talk.duration)
                            }

                        _ ->
                            { oldEntry | entryType = entryType }
            in
                ( { model
                    | action = Editing
                    , newEntry = newEntry
                  }
                , Cmd.batch
                    [ openModal "editing-modal"
                    , updateTextFields ""
                    ]
                )

        UserInput data ->
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

        SaveEntry ->
            case model.newEntry.entryType of
                TalkType ->
                    let
                        oldTalk =
                            model.talk

                        newDuration =
                            (minutesToSeconds model.newEntry.minutes) + model.newEntry.seconds

                        newTalk =
                            { oldTalk | title = model.newEntry.title, duration = newDuration }
                    in
                        { model | talk = newTalk, newEntry = blankEntry } ! [ closeModal "editing-modal" ]

                _ ->
                    model ! [ closeModal "editing-modal" ]

        StartTalk ->
            { model | action = Speaking } ! []

        StopTalk ->
            { model | action = Reviewing, talkTime = 0 } ! []
