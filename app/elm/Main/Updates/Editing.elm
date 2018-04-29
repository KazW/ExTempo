module Main.Updates.Editing exposing (editEntry)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Main.Ports exposing (..)
import Array exposing (..)


editEntry : Model -> EntryType -> ( Model, Cmd Msg )
editEntry model entryType =
    let
        entry =
            { blankEntry | entryType = entryType }

        newEntry =
            case entryType of
                TalkType ->
                    fillEntry (talkToPoint model.talk) entry

                SectionType maybeIndex ->
                    case maybeIndex of
                        Nothing ->
                            entry

                        Just index ->
                            let
                                maybeSection =
                                    Array.get index model.talk.sections
                            in
                                case maybeSection of
                                    Nothing ->
                                        entry

                                    Just section ->
                                        fillEntry (sectionToPoint section) entry

                PointType sectionIndex maybeIndex ->
                    let
                        pointIndex =
                            case maybeIndex of
                                Nothing ->
                                    0

                                Just index ->
                                    index

                        section =
                            case Array.get sectionIndex model.talk.sections of
                                Nothing ->
                                    blankSection

                                Just section ->
                                    section

                        point =
                            case Array.get pointIndex section.points of
                                Nothing ->
                                    blankPoint

                                Just point ->
                                    point
                    in
                        fillEntry point entry
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
