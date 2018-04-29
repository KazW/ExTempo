module Main.Updates.DeleteEntry exposing (deleteEntry)

import Main.Models exposing (..)
import Array exposing (..)


deleteEntry : Model -> EntryType -> ( Model, Cmd Msg )
deleteEntry model entryType =
    let
        talk =
            model.talk

        newTalk =
            case entryType of
                TalkType ->
                    talk

                SectionType maybeIndex ->
                    case maybeIndex of
                        Nothing ->
                            talk

                        Just sectionIndex ->
                            { talk | sections = deleteAtIndex sectionIndex talk.sections }

                PointType sectionIndex maybeIndex ->
                    case maybeIndex of
                        Nothing ->
                            talk

                        Just pointIndex ->
                            deletePoint sectionIndex pointIndex talk
    in
        { model | talk = newTalk } ! []


deletePoint : Int -> Int -> Talk -> Talk
deletePoint sectionIndex pointIndex talk =
    let
        section =
            getSection (Just sectionIndex) talk

        newSections =
            Array.set sectionIndex
                { section
                    | points = deleteAtIndex pointIndex section.points
                }
                talk.sections
    in
        { talk | sections = newSections }


deleteAtIndex : Int -> Array e -> Array e
deleteAtIndex targetIndex array =
    array
        |> Array.toIndexedList
        |> List.filter (\( index, _ ) -> index /= targetIndex)
        |> List.map (\( _, entry ) -> entry)
        |> Array.fromList
