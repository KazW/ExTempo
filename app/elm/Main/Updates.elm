module Main.Updates exposing (update)

import Main.Models as Models exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Tick _ ->
            if model.action == Speaking then
                { model | talkTime = model.talkTime + 1 } ! []
            else
                model ! []

        ClearEntry ->
            let
                clearedEntry =
                    { name = ""
                    , previousName = ""
                    , seconds = 0
                    , minutes = 0
                    , position = 0
                    , entryType = TalkType
                    }
            in
                { model
                    | newEntry = clearedEntry
                    , action = Reviewing
                }
                    ! []

        StartTalk ->
            { model | action = Speaking } ! []

        StopTalk ->
            { model | action = Reviewing, talkTime = 0 } ! []

        -- TODO: Fix this
        _ ->
            model ! []
