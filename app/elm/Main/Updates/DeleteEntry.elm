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
                            deleteSection sectionIndex talk

                PointType sectionIndex maybeIndex ->
                    case maybeIndex of
                        Nothing ->
                            talk

                        Just pointIndex ->
                            deletePoint sectionIndex pointIndex talk
    in
        { model | talk = newTalk } ! []


rejectTarget : Int -> ( Int, anything ) -> Bool
rejectTarget targetIndex ( sectionIndex, _ ) =
    targetIndex /= sectionIndex


deleteSection : Int -> Talk -> Talk
deleteSection sectionIndex talk =
    let
        newSections =
            talk.sections
                |> Array.toIndexedList
                |> List.filter (\pair -> (rejectTarget sectionIndex pair))
                |> List.map (\( _, section ) -> section)
                |> Array.fromList
    in
        { talk | sections = newSections }


deletePoint : Int -> Int -> Talk -> Talk
deletePoint sectionIndex pointIndex talk =
    let
        section =
            getSection (Just sectionIndex) talk

        newPoints =
            section.points
                |> Array.toIndexedList
                |> List.filter (\pair -> (rejectTarget pointIndex pair))
                |> List.map (\( _, point ) -> point)
                |> Array.fromList

        newSection =
            { section | points = newPoints }

        newSections =
            Array.set sectionIndex newSection talk.sections
    in
        { talk | sections = newSections }
