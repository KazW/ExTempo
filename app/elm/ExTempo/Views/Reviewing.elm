module ExTempo.Views.Reviewing exposing (reviewingView)

import ExTempo.Models exposing (..)
import ExTempo.Views.Helpers exposing (..)
import ExTempo.Views.Landing exposing (landingView)
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


reviewingView : Model -> Html Msg
reviewingView model =
    div [ class "container" ]
        (if model.talk.duration > 0 then
            List.append [ talkView model ] [ sectionsView model ]
         else
            [ landingView model ]
        )


buttonSpacer : Html Msg
buttonSpacer =
    text "    "


talkView : Model -> Html Msg
talkView model =
    div [ class "row" ]
        [ h4 [ class "header light" ] [ text "Main Topic" ]
        , talkInfo model
        ]


talkInfo : Model -> Html Msg
talkInfo model =
    div [ class "col s12 m6 l3" ]
        [ h5 [ class "header light" ]
            [ a
                [ class "btn-floating waves-effect waves-light"
                , onClick (EditEntry TalkType)
                ]
                [ i [ class "medium material-icons" ] [ text "edit" ] ]
            , buttonSpacer
            , text model.talk.title
            ]
        , p [ class "caption" ] [ talkTable model ]
        ]


talkTable : Model -> Html Msg
talkTable model =
    [ ( "Total duration:", secondsToDuration model.talk.duration )
    , ( "Sections duration:", secondsToDuration (entriesDuration model.talk.sections) )
    , ( "Extra time:", secondsToDuration (extraTalkTime model) )
    ]
        |> listToTable


extraTalkTime : Model -> Int
extraTalkTime model =
    model.talk.duration - (entriesDuration model.talk.sections)


sectionsView : Model -> Html Msg
sectionsView model =
    if model.talk.duration > 0 then
        div [ class "row" ]
            [ h4 [ class "header light" ]
                [ if extraTalkTime model > 0 then
                    a
                        [ class "btn-floating waves-effect waves-light"
                        , onClick (EditEntry (SectionType Nothing))
                        ]
                        [ i [ class "medium material-icons" ] [ text "add" ] ]
                  else
                    span [] []
                , buttonSpacer
                , text "Sections"
                ]
            , eachSectionView model
            ]
    else
        span [] []


eachSectionView : Model -> Html Msg
eachSectionView model =
    model.talk.sections
        |> Array.toIndexedList
        |> List.concatMap (\pair -> (renderSection pair ((length model.talk.sections) - 1)))
        |> div []


renderSection : ( Int, Section ) -> Int -> List (Html Msg)
renderSection ( index, section ) lastIndex =
    let
        pointsDuration =
            entriesDuration section.points

        extraTime =
            section.duration - pointsDuration
    in
        [ div [ class "row section" ]
            [ div [ class "col s12" ]
                [ h5 [ class "header light" ]
                    [ a
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
                    , text section.title
                    ]
                , p [ class "caption" ]
                    [ div [ class "col s12 m6 l3" ]
                        [ [ ( "Section duration:", secondsToDuration section.duration )
                          , ( "Points duration:", secondsToDuration pointsDuration )
                          , ( "Extra time:", secondsToDuration extraTime )
                          ]
                            |> listToTable
                        ]
                    ]
                , pointsView index section
                ]
            ]
        , if index == lastIndex then
            span [] []
          else
            div [ class "divider" ] []
        ]


pointsView : Int -> Section -> Html Msg
pointsView sectionIndex section =
    div [ class "col s12" ]
        [ h5 [ class "header light" ]
            [ if entriesDuration section.points == section.duration then
                span [] []
              else
                a
                    [ class "btn-floating waves-effect waves-light"
                    , onClick (EditEntry (PointType sectionIndex Nothing))
                    ]
                    [ i [ class "medium material-icons" ] [ text "add" ] ]
            , buttonSpacer
            , text "Points"
            ]
        , if length section.points > 0 then
            ul [ class "collection" ] (eachPointView sectionIndex section)
          else
            span [] []
        ]


eachPointView : Int -> Section -> List (Html Msg)
eachPointView sectionIndex section =
    section.points
        |> Array.toIndexedList
        |> List.map (\point -> (renderPoint point sectionIndex section))


renderPoint : ( Int, Point ) -> Int -> Section -> Html Msg
renderPoint ( pointIndex, point ) sectionIndex section =
    li [ class "collection-item" ]
        [ h5 [ class "header light" ]
            [ a
                [ class "btn-floating waves-effect waves-light"
                , onClick (DeleteEntry (PointType sectionIndex (Just pointIndex)))
                ]
                [ i [ class "medium material-icons" ] [ text "delete" ] ]
            , buttonSpacer
            , a
                [ class "btn-floating waves-effect waves-light"
                , onClick (EditEntry (PointType sectionIndex (Just pointIndex)))
                ]
                [ i [ class "medium material-icons" ] [ text "edit" ] ]
            , buttonSpacer
            , text point.title
            , buttonSpacer
            , span [ class "duration" ] [ text (secondsToDuration point.duration) ]
            , buttonSpacer
            ]
        ]
