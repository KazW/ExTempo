module ExTempo.Views.Reviewing exposing (reviewingView)

import ExTempo.Models exposing (..)
import ExTempo.Views.Helpers exposing (..)
import ExTempo.Views.Landing exposing (landingView)
import ExTempo.Updates.ValidateEntry exposing (entriesDuration)
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


reviewingView : Model -> Html Msg
reviewingView model =
    div [ class "container" ] (List.append (talkView model) (sectionsView model))


buttonSpacer : Html Msg
buttonSpacer =
    text "    "


talkView : Model -> List (Html Msg)
talkView model =
    if model.talk.duration > 0 then
        [ div [ class "row" ]
            [ h4 [ class "header light" ]
                [ text "Talk"
                , buttonSpacer
                , a
                    [ class "btn-floating waves-effect waves-light"
                    , onClick (EditEntry TalkType)
                    ]
                    [ i [ class "medium material-icons" ] [ text "edit" ] ]
                ]
            ]
        , talkInfo model
        ]
    else
        [ landingView model ]


talkInfo : Model -> Html Msg
talkInfo model =
    div [ class "row" ]
        [ div [ class "row" ]
            [ div [ class "col s12 m4 right-align" ] [ h6 [ class "header light" ] [ text "Topic" ] ]
            , div [ class "col s12 m8" ] [ h5 [ class "header light" ] [ text model.talk.title ] ]
            ]
        , div [ class "row" ]
            [ div [ class "col s12 m4 right-align" ] [ h6 [ class "header light" ] [ text "Duration" ] ]
            , div [ class "col s12 m8" ] [ h5 [ class "header light" ] [ text (secondsToDuration model.talk.duration) ] ]
            ]
        ]


sectionsView : Model -> List (Html Msg)
sectionsView model =
    if model.talk.duration > 0 then
        [ div [ class "row" ]
            [ h4 [ class "header light" ]
                [ text "Sections"
                , buttonSpacer
                , a
                    [ class "btn-floating waves-effect waves-light"
                    , onClick (EditEntry (SectionType Nothing))
                    ]
                    [ i [ class "medium material-icons" ] [ text "add" ] ]
                ]
            ]
        , p
            [ class "caption" ]
            [ text
                ("Extra time:   "
                    ++ (secondsToDuration
                            (model.talk.duration - (entriesDuration model.talk.sections))
                       )
                )
            ]
        , eachSectionView model
        ]
    else
        [ div [ class "row" ] [] ]


eachSectionView : Model -> Html Msg
eachSectionView model =
    model.talk.sections
        |> Array.toIndexedList
        |> List.map renderSection
        |> div [ class "row" ]


renderSection : ( Int, Section ) -> Html Msg
renderSection ( index, section ) =
    let
        pointsDuration =
            entriesDuration section.points
    in
        div [ class "col s12" ]
            [ div [ class "col s12" ]
                [ h5 [ class "header light" ]
                    [ text section.title
                    , buttonSpacer
                    , a
                        [ class "btn-floating waves-effect waves-light"
                        , onClick (DeleteEntry (SectionType (Just index)))
                        ]
                        [ i [ class "medium material-icons" ] [ text "delete" ] ]
                    , buttonSpacer
                    , a
                        [ class "btn-floating waves-effect waves-light"
                        , onClick (EditEntry (SectionType (Just index)))
                        ]
                        [ i [ class "medium material-icons" ] [ text "edit" ] ]
                    , buttonSpacer
                    , a
                        [ class "btn-floating waves-effect waves-light"
                        , onClick (EditEntry (PointType index Nothing))
                        ]
                        [ i [ class "medium material-icons" ] [ text "add" ] ]
                    ]
                , p [ class "caption" ]
                    [ ul []
                        [ li [] [ text ("Section duration:   " ++ secondsToDuration section.duration) ]
                        , li [] [ text ("Points duration:   " ++ secondsToDuration pointsDuration) ]
                        , li [] [ text ("Extra time:   " ++ secondsToDuration (section.duration - pointsDuration)) ]
                        ]
                    ]
                , pointsView index section
                , hr [] []
                ]
            ]


pointsView : Int -> Section -> Html Msg
pointsView sectionIndex section =
    div [ class "col s12" ]
        [ h6 [ class "header light" ] [ text "Points" ]
        , div [ class "col s12" ] [ eachPointView sectionIndex section ]
        ]


eachPointView : Int -> Section -> Html Msg
eachPointView sectionIndex section =
    section.points
        |> Array.toIndexedList
        |> List.map (\point -> (renderPoint point sectionIndex section))
        |> div [ class "ul" ]


renderPoint : ( Int, Point ) -> Int -> Section -> Html Msg
renderPoint ( pointIndex, point ) sectionIndex section =
    li []
        [ text point.title
        , text " - "
        , text (secondsToDuration point.duration)
        , buttonSpacer
        , a
            [ class "waves-effect waves-light"
            , onClick (DeleteEntry (PointType sectionIndex (Just pointIndex)))
            ]
            [ i [ class "tiny material-icons" ] [ text "delete" ] ]
        , a
            [ class "waves-effect waves-light"
            , onClick (EditEntry (PointType sectionIndex (Just pointIndex)))
            ]
            [ i [ class "tiny material-icons" ] [ text "edit" ] ]
        ]
