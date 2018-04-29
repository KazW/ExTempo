module Main.Updates.Frames exposing (getCurrentFrame, createFrames)

import Main.Models exposing (..)
import Array exposing (..)


getCurrentFrame : Model -> Maybe Frame
getCurrentFrame model =
    case model.action of
        Speaking ->
            model.talkFrames
                |> List.filter (\frame -> frame.start <= model.talkTime)
                |> List.filter (\frame -> frame.end >= model.talkTime)
                |> List.head

        _ ->
            Just paddingFrame


createFrames : Talk -> List Frame
createFrames talk =
    talk.sections
        |> Array.toIndexedList
        |> List.concatMap (\pair -> sectionFrames talk pair)
        |> talkPaddingFrame talk


talkPaddingFrame : Talk -> List Frame -> List Frame
talkPaddingFrame talk frames =
    let
        lastFrame =
            getLastFrame frames

        duration =
            talk.duration - lastFrame.end

        paddingSection =
            paddingFrame.section

        paddingPoint =
            paddingFrame.point
    in
        if lastFrame.end == talk.duration then
            frames
        else
            List.append frames
                [ { paddingFrame
                    | section = { paddingSection | duration = duration }
                    , point = { paddingPoint | duration = duration }
                    , start = lastFrame.end
                    , end = talk.duration
                  }
                ]


paddingFrame : Frame
paddingFrame =
    { section = { blankSection | title = "Extra Time" }
    , point = { blankPoint | title = "Extra Time" }
    , start = 0
    , end = 0
    }


sectionFrames : Talk -> ( Int, Section ) -> List Frame
sectionFrames talk pair =
    let
        ( index, section ) =
            pair

        ( start, end ) =
            entryFrameTimes talk.sections pair
    in
        if length section.points == 0 then
            [ { paddingFrame
                | section = section
                , start = start
                , end = end
              }
            ]
        else
            pointFrames start section
                |> sectionPaddingFrame end


sectionPaddingFrame : Int -> List Frame -> List Frame
sectionPaddingFrame sectionEnd frames =
    let
        lastFrame =
            getLastFrame frames
    in
        if lastFrame.end == sectionEnd then
            frames
        else
            List.append frames
                [ { lastFrame
                    | point = { title = paddingFrame.point.title, duration = sectionEnd - lastFrame.end }
                    , start = lastFrame.end
                    , end = sectionEnd
                  }
                ]


pointFrames : Int -> Section -> List Frame
pointFrames sectionStart section =
    section.points
        |> Array.toIndexedList
        |> List.map (\pair -> pointFrame sectionStart section pair)


pointFrame : Int -> Section -> ( Int, Point ) -> Frame
pointFrame sectionStart section ( index, point ) =
    let
        ( rawStart, rawEnd ) =
            entryFrameTimes section.points ( index, point )

        start =
            rawStart + sectionStart

        end =
            rawEnd + sectionStart
    in
        { section = section, point = point, start = start, end = end }


getLastFrame : List Frame -> Frame
getLastFrame frames =
    case frames |> List.reverse |> List.head of
        Nothing ->
            paddingFrame

        Just frame ->
            frame


entryFrameTimes : Array { e | duration : Int } -> ( Int, { e | duration : Int } ) -> ( Int, Int )
entryFrameTimes entries ( index, entry ) =
    let
        start =
            timeToEntry index entries
    in
        ( start, start + entry.duration )


timeToEntry : Int -> Array { e | duration : Int } -> Int
timeToEntry entryIndex entries =
    entries
        |> Array.toIndexedList
        |> List.filter (\( index, _ ) -> index < entryIndex)
        |> List.map (\( _, entry ) -> entry.duration)
        |> List.foldl (+) 0
