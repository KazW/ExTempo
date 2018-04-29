module Main.Updates.SaveInput exposing (saveEntry)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Array exposing (..)


saveEntry : Model -> Model
saveEntry model =
    let
        talk =
            model.talk

        newModel =
            case model.newEntry.entryType of
                TalkType ->
                    let
                        newTalk =
                            { talk | title = model.newEntry.title, duration = (entryDuration model) }
                    in
                        { model | talk = newTalk, newEntry = blankEntry }

                SectionType sectionKey ->
                    saveSection model sectionKey

                PointType sectionKey pointKey ->
                    savePoint model sectionKey pointKey
    in
        newModel


entryDuration : Model -> Int
entryDuration model =
    (minutesToSeconds model.newEntry.minutes) + model.newEntry.seconds


saveSection : Model -> Maybe Int -> Model
saveSection model sectionKey =
    let
        talk =
            model.talk

        newEntry =
            model.newEntry

        oldSection =
            case newEntry.entryType of
                SectionType Nothing ->
                    blankSection

                SectionType (Just index) ->
                    case Array.get index model.talk.sections of
                        Nothing ->
                            blankSection

                        Just section ->
                            section

                _ ->
                    blankSection

        newSection =
            { oldSection
                | title = newEntry.title
                , duration = entryDuration model
            }

        newSections =
            case sectionKey of
                Nothing ->
                    Array.push newSection talk.sections

                Just sectionKey ->
                    Array.set sectionKey newSection talk.sections

        newTalk =
            { talk | sections = newSections }
    in
        { model | newEntry = blankEntry, talk = newTalk }


savePoint : Model -> Int -> Maybe Int -> Model
savePoint model sectionKey pointKey =
    let
        talk =
            model.talk

        section =
            case Array.get sectionKey model.talk.sections of
                Nothing ->
                    blankSection

                Just section ->
                    section

        newPoint =
            { title = model.newEntry.title
            , duration = entryDuration model
            }

        newPoints =
            case pointKey of
                Nothing ->
                    Array.push newPoint section.points

                Just pointKey ->
                    Array.set pointKey newPoint section.points

        newSections =
            Array.set sectionKey { section | points = newPoints } model.talk.sections

        newTalk =
            { talk | sections = newSections }
    in
        { model | newEntry = blankEntry, talk = newTalk }
