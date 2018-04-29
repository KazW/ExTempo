module Main.Models exposing (..)

import Time exposing (Time)
import Array exposing (..)


initModel : Flags -> Model
initModel flags_ =
    { apiUrl = flags_.apiUrl
    , talk =
        { title = ""
        , duration = 0
        , sections = Array.empty
        }
    , talkFrames = []
    , talkTime = 0
    , action = Reviewing
    , newEntry = blankEntry
    , errorMessage = Nothing
    , currentFrame = Nothing
    }


blankEntry : NewEntry
blankEntry =
    { title = ""
    , seconds = 0
    , minutes = 0
    , entryType = TalkType
    }


blankSection : Section
blankSection =
    { title = ""
    , duration = 0
    , points = Array.empty
    }


blankPoint : Point
blankPoint =
    { title = ""
    , duration = 0
    }


getSection : Maybe Int -> Talk -> Section
getSection maybeIndex talk =
    case maybeIndex of
        Nothing ->
            blankSection

        Just sectionIndex ->
            case Array.get sectionIndex talk.sections of
                Nothing ->
                    blankSection

                Just section ->
                    section


getPoint : Int -> Maybe Int -> Talk -> Point
getPoint sectionIndex maybeIndex talk =
    let
        section =
            getSection (Just sectionIndex) talk
    in
        case maybeIndex of
            Nothing ->
                blankPoint

            Just pointIndex ->
                case Array.get pointIndex section.points of
                    Nothing ->
                        blankPoint

                    Just point ->
                        point



--MODELS


type alias Flags =
    { apiUrl : String }


type alias Model =
    { apiUrl : String
    , talk : Talk
    , talkFrames : List Frame
    , talkTime : Int
    , action : Action
    , newEntry : NewEntry
    , errorMessage : Maybe String
    , currentFrame : Maybe Frame
    }


type alias Talk =
    { title : String
    , duration : Int
    , sections : Array Section
    }


type alias Frame =
    { section : Section
    , point : Point
    , start : Int
    , end : Int
    }


type alias Section =
    { title : String
    , duration : Int
    , points : Array Point
    }


type alias Point =
    { title : String
    , duration : Int
    }


type alias NewEntry =
    { title : String
    , minutes : Int
    , seconds : Int
    , entryType : EntryType
    }


type Action
    = Editing
    | Reviewing
    | Speaking


type EntryType
    = TalkType
    | SectionType (Maybe Int)
    | PointType Int (Maybe Int)


type NewInput
    = Title String
    | Minutes String
    | Seconds String


type Msg
    = NoOp
    | Tick Time
    | EditEntry EntryType
    | DeleteEntry EntryType
    | ValidateEntry
    | ClearEntry
    | StartTalk
    | StopTalk
    | UserInput NewInput
