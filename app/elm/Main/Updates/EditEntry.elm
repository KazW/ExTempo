module Main.Updates.EditEntry exposing (editEntry)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Main.Ports exposing (..)


editEntry : Model -> EntryType -> ( Model, Cmd Msg )
editEntry model entryType =
    let
        talk =
            model.talk

        entry =
            { blankEntry | entryType = entryType }

        newEntry =
            case entryType of
                TalkType ->
                    fillEntry (talkToPoint talk) entry

                SectionType maybeIndex ->
                    fillEntry (sectionToPoint (getSection maybeIndex talk)) entry

                PointType sectionIndex maybeIndex ->
                    fillEntry (getPoint sectionIndex maybeIndex talk) entry
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


fillEntry : Point -> NewEntry -> NewEntry
fillEntry record entry =
    { entry
        | title = record.title
        , minutes = (secondsToMinutes record.duration)
        , seconds = (remainingSeconds record.duration)
    }
