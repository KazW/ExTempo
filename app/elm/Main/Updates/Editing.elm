module Main.Updates.Editing exposing (..)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Main.Ports exposing (..)


editEntry : Model -> EntryType -> ( Model, Cmd Msg )
editEntry model entryType =
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


isValidEntry : Model -> Bool
isValidEntry model =
    True


addErrors : Model -> Model
addErrors model =
    model
