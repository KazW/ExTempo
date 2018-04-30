module ExTempo.Updates.ValidateEntry exposing (validateEntry)

import ExTempo.Models exposing (..)
import Array exposing (..)
import ExTempo.Ports exposing (closeModal, updateTextFields)
import ExTempo.Updates.SaveEntry exposing (..)
import ExTempo.Views.Helpers exposing (secondsToDuration)


validateEntry : Model -> ( Model, Cmd Msg )
validateEntry model =
    let
        newModel =
            updateErrors model
    in
        if isValid newModel then
            saveEntry newModel ! [ closeModal "editing-modal", updateTextFields "" ]
        else
            newModel ! []


isValid : Model -> Bool
isValid model =
    case model.errorMessage of
        Nothing ->
            True

        Just _ ->
            False


updateErrors : Model -> Model
updateErrors model =
    let
        maybeError =
            entryError model
    in
        case maybeError of
            Nothing ->
                { model | errorMessage = Nothing }

            error ->
                { model | errorMessage = error }


entryError : Model -> Maybe String
entryError model =
    if entryDuration model.newEntry < 1 then
        Just "Must be at least 1 second long."
    else if String.length model.newEntry.title < 1 then
        Just "Title must be at least 1 character long."
    else
        case model.newEntry.entryType of
            TalkType ->
                if entryDuration model.newEntry < sectionsDuration model.talk.sections then
                    Just (minimumDurationError (sectionsDuration model.talk.sections))
                else
                    Nothing

            SectionType maybeIndex ->
                validateSectionEntry model maybeIndex

            PointType sectionIndex maybeIndex ->
                validatePointEntry model sectionIndex maybeIndex


validateSectionEntry : Model -> Maybe Int -> Maybe String
validateSectionEntry model maybeIndex =
    let
        duration =
            entryDuration model.newEntry
    in
        case maybeIndex of
            Nothing ->
                let
                    maxDuration =
                        model.talk.duration - sectionsDuration model.talk.sections
                in
                    validateDurationRange 1 maxDuration duration

            Just sectionIndex ->
                let
                    minDuration =
                        pointsDuration (getSection maybeIndex model.talk).points

                    maxDuration =
                        model.talk.duration - (filteredTalkDuration sectionIndex model.talk)
                in
                    validateDurationRange minDuration maxDuration duration


validatePointEntry : Model -> Int -> Maybe Int -> Maybe String
validatePointEntry model sectionIndex maybeIndex =
    let
        section =
            getSection (Just sectionIndex) model.talk

        duration =
            entryDuration model.newEntry

        minDuration =
            1
    in
        case maybeIndex of
            Nothing ->
                let
                    maxDuration =
                        section.duration - pointsDuration section.points
                in
                    validateDurationRange minDuration maxDuration duration

            Just pointIndex ->
                let
                    maxDuration =
                        section.duration - filteredPointsDuration pointIndex section.points
                in
                    validateDurationRange minDuration maxDuration duration


validateDurationRange : Int -> Int -> Int -> Maybe String
validateDurationRange minDuration maxDuration duration =
    if duration <= maxDuration && duration >= minDuration then
        Nothing
    else
        Just (durationRangeErrorMessage minDuration maxDuration)


durationRangeErrorMessage : Int -> Int -> String
durationRangeErrorMessage minDuration maxDuration =
    String.join ""
        [ "Duration must be between "
        , secondsToDuration minDuration
        , " and "
        , secondsToDuration maxDuration
        , "."
        ]


minimumDurationError : Int -> String
minimumDurationError duration =
    String.join ""
        [ "Duration is too short, must be at least "
        , secondsToDuration duration
        , "."
        ]


maximumDurationError : Int -> String
maximumDurationError duration =
    String.join ""
        [ "Duration is too long, must be less than "
        , secondsToDuration duration
        , "."
        ]


filteredTalkDuration : Int -> Talk -> Int
filteredTalkDuration sectionIndex talk =
    talk.sections
        |> Array.toIndexedList
        |> List.filter (\( index, _ ) -> index /= sectionIndex)
        |> List.map (\( _, section ) -> section)
        |> Array.fromList
        |> sectionsDuration


sectionsDuration : Array Section -> Int
sectionsDuration sections =
    sections
        |> Array.map sectionDuration
        |> Array.toList
        |> List.sum


sectionDuration : Section -> Int
sectionDuration section =
    case List.maximum [ section.duration, (pointsDuration section.points) ] of
        Nothing ->
            0

        Just duration ->
            duration


pointsDuration : Array Point -> Int
pointsDuration points =
    points
        |> Array.map (\point -> point.duration)
        |> Array.toList
        |> List.sum


filteredPointsDuration : Int -> Array Point -> Int
filteredPointsDuration pointIndex points =
    points
        |> Array.toIndexedList
        |> List.filter (\( index, _ ) -> index /= pointIndex)
        |> List.map (\( _, section ) -> section)
        |> Array.fromList
        |> pointsDuration
