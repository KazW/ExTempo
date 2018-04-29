module Main.Updates.SaveInput exposing (saveEntry)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Array exposing (..)


saveEntry : Model -> Model
saveEntry model =
    let
        talk =
            model.talk

        newTalk =
            case model.newEntry.entryType of
                TalkType ->
                    { talk | title = model.newEntry.title, duration = (entryDuration model.newEntry) }

                SectionType sectionIndex ->
                    saveSection model.newEntry talk sectionIndex

                PointType sectionIndex pointIndex ->
                    savePoint model.newEntry talk sectionIndex pointIndex
    in
        { model | talk = newTalk, newEntry = blankEntry }


entryDuration : NewEntry -> Int
entryDuration entry =
    (minutesToSeconds entry.minutes) + entry.seconds


saveSection : NewEntry -> Talk -> Maybe Int -> Talk
saveSection newEntry talk sectionIndex =
    let
        oldSection =
            getSection sectionIndex talk

        newSection =
            { oldSection
                | title = newEntry.title
                , duration = entryDuration newEntry
            }

        newSections =
            case sectionIndex of
                Nothing ->
                    Array.push newSection talk.sections

                Just sectionIndex ->
                    Array.set sectionIndex newSection talk.sections
    in
        { talk | sections = newSections }


savePoint : NewEntry -> Talk -> Int -> Maybe Int -> Talk
savePoint newEntry talk sectionIndex pointIndex =
    let
        section =
            getSection (Just sectionIndex) talk

        newPoint =
            { title = newEntry.title
            , duration = entryDuration newEntry
            }

        newPoints =
            case pointIndex of
                Nothing ->
                    Array.push newPoint section.points

                Just pointIndex ->
                    Array.set pointIndex newPoint section.points

        newSections =
            Array.set sectionIndex { section | points = newPoints } talk.sections
    in
        { talk | sections = newSections }
