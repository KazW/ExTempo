module Main.Updates.SaveInput exposing (saveEntry)

import Main.Models as Models exposing (..)
import Main.Time exposing (..)
import Dict exposing (..)


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

                SectionType (Just key) ->
                    case Dict.get key model.talk.sections of
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
                    Dict.insert (nextSectionKey model) newSection talk.sections

                Just sectionKey ->
                    Dict.insert sectionKey newSection talk.sections

        newTalk =
            { talk | sections = newSections }
    in
        { model | newEntry = blankEntry, talk = newTalk }


nextSectionKey : Model -> Int
nextSectionKey model =
    Dict.size model.talk.sections


savePoint : Model -> Int -> Maybe Int -> Model
savePoint model sectionKey pointKey =
    let
        talk =
            model.talk

        section =
            case Dict.get sectionKey model.talk.sections of
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
                    Dict.insert (nextPointKey section) newPoint section.points

                Just pointKey ->
                    Dict.insert pointKey newPoint section.points

        newSections =
            Dict.insert sectionKey { section | points = newPoints } model.talk.sections

        newTalk =
            { talk | sections = newSections }
    in
        { model | newEntry = blankEntry, talk = newTalk }


nextPointKey : Section -> Int
nextPointKey section =
    Dict.size section.points
