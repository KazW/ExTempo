module ExTempo.Views.Talking exposing (talkingView)

import ExTempo.Models exposing (..)
import ExTempo.Views.Helpers exposing (..)
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


talkingView : Model -> Html Msg
talkingView model =
    let
        statsView =
            if model.talkTime <= model.talk.duration then
                talkStatsView model
            else
                overtimeView model
    in
        div [ class "row" ]
            [ statsView
            , div [ class "col s12 m3 pull-m9" ] [ talkListView model ]
            ]


overtimeView : Model -> Html Msg
overtimeView model =
    div [ class "col s12 m9 push-m3 center" ]
        [ h4 [ class "header light" ] [ text "Overtime" ]
        , h4 [ class "header light" ] [ text (secondsToTime (model.talkTime - model.talk.duration)) ]
        ]


talkStatsView : Model -> Html Msg
talkStatsView model =
    let
        section =
            currentSection model

        sectionTitle =
            currentSectionTitle model

        pointTitle =
            currentPointTitle model
    in
        div [ class "col s12 m9 push-m3 center" ]
            [ h4 [ class "header light" ] [ text sectionTitle ]
            , h3 [ class "header light" ] [ text pointTitle ]
            , h5 [ class "header light" ]
                [ text
                    ((secondsToTime (currentFrameTime model))
                        ++ " / "
                        ++ (secondsToTime (currentFrameLength model))
                    )
                ]
            , div [ class "progress" ]
                [ div
                    [ class "determinate"
                    , style [ ( "width", currentFramePercentage model ) ]
                    ]
                    []
                ]
            , h6 [ class "header light" ]
                [ text
                    ((secondsToTime model.talkTime)
                        ++ " / "
                        ++ (secondsToTime model.talk.duration)
                    )
                ]
            , h6 [ class "header light" ] [ text (currentTalkPercentage model) ]
            ]


talkListView : Model -> Html Msg
talkListView model =
    ul [ class "talk-list" ]
        (model.talk.sections
            |> Array.toIndexedList
            |> List.map (\pair -> sectionListView model pair)
        )


sectionListView : Model -> ( Int, Section ) -> Html Msg
sectionListView model ( sectionIndex, section ) =
    let
        classes =
            if currentSectionIndex model == sectionIndex then
                "bold active"
            else
                "bold"
    in
        if length section.points == 0 then
            li [ class classes ] [ span [] [ text section.title ] ]
        else
            li [ class classes ]
                [ span [ class "collapsible-header" ] [ text section.title ]
                , div [ class "collapsible-body" ]
                    [ ul []
                        (section.points
                            |> Array.toIndexedList
                            |> List.map (\pair -> pointListView model sectionIndex pair)
                        )
                    ]
                ]


pointListView : Model -> Int -> ( Int, Point ) -> Html Msg
pointListView model sectionIndex ( pointIndex, point ) =
    let
        classes =
            if currentSectionIndex model == sectionIndex && currentPointIndex model == pointIndex then
                "active"
            else
                ""
    in
        li [ class classes ] [ text point.title ]


currentFrameTime : Model -> Int
currentFrameTime model =
    case model.currentFrame of
        Nothing ->
            0

        Just frame ->
            model.talkTime - frame.start


currentFrameLength : Model -> Int
currentFrameLength model =
    case model.currentFrame of
        Nothing ->
            0

        Just frame ->
            frame.end - frame.start


currentFramePercentage : Model -> String
currentFramePercentage model =
    (toString
        (round
            ((toFloat (currentFrameTime model)
                / toFloat (currentFrameLength model)
             )
                * 100
            )
        )
    )
        ++ "%"


currentTalkPercentage : Model -> String
currentTalkPercentage model =
    (toString
        (round
            ((toFloat model.talkTime
                / toFloat model.talk.duration
             )
                * 100
            )
        )
    )
        ++ "%"


currentSection : Model -> Maybe Section
currentSection model =
    model.talk.sections
        |> Array.get (currentSectionIndex model)


currentPoint : Model -> Maybe Point
currentPoint model =
    let
        section =
            currentSection model
    in
        case section of
            Nothing ->
                Nothing

            Just section ->
                Array.get (currentPointIndex model) section.points


currentSectionTitle : Model -> String
currentSectionTitle model =
    let
        section =
            currentSection model
    in
        case section of
            Nothing ->
                "Extra Time"

            Just section ->
                section.title


currentPointTitle : Model -> String
currentPointTitle model =
    let
        point =
            currentPoint model
    in
        case point of
            Nothing ->
                "Extra Time"

            Just point ->
                point.title


currentSectionIndex : Model -> Int
currentSectionIndex model =
    case model.currentFrame of
        Nothing ->
            -1

        Just frame ->
            case frame.section of
                Nothing ->
                    -1

                Just index ->
                    index


currentPointIndex : Model -> Int
currentPointIndex model =
    case model.currentFrame of
        Nothing ->
            -1

        Just frame ->
            case frame.point of
                Nothing ->
                    -1

                Just index ->
                    index
