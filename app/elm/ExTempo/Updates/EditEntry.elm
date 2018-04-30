module ExTempo.Updates.EditEntry exposing (editEntry)

import ExTempo.Models as Models exposing (..)
import ExTempo.Time exposing (secondsToMinutes, remainingSeconds)
import ExTempo.Ports exposing (openModal, updateTextFields)


editEntry : Model -> EntryType -> ( Model, Cmd Msg )
editEntry model entryType =
    ( { model
        | action = Editing
        , newEntry = fillEntry model entryType
      }
    , Cmd.batch
        [ openModal "editing-modal"
        , updateTextFields ""
        ]
    )


fillEntry : Model -> EntryType -> NewEntry
fillEntry model entryType =
    let
        record =
            case entryType of
                TalkType ->
                    talkToPoint model.talk

                SectionType maybeIndex ->
                    sectionToPoint (getSection maybeIndex model.talk)

                PointType sectionIndex maybeIndex ->
                    getPoint sectionIndex maybeIndex model.talk
    in
        { blankEntry
            | title = record.title
            , minutes = (secondsToMinutes record.duration)
            , seconds = (remainingSeconds record.duration)
            , entryType = entryType
        }


talkToPoint : Talk -> Point
talkToPoint talk =
    { title = talk.title
    , duration = talk.duration
    }


sectionToPoint : Section -> Point
sectionToPoint section =
    { title = section.title
    , duration = section.duration
    }
