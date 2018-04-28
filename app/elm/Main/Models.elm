module Main.Models exposing (..)

import Time exposing (Time)
import Dict exposing (..)


initModel : Flags -> Model
initModel flags_ =
    { apiUrl = flags_.apiUrl
    , talk =
        { title = ""
        , duration = 0
        , sections = Dict.empty
        , frames = []
        , time = 0
        }
    , action = Reviewing
    , newEntry = blankEntry
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
    , points = Dict.empty
    }



--MODELS


type alias Flags =
    { apiUrl : String }


type alias Model =
    { apiUrl : String
    , talk : Talk
    , action : Action
    , newEntry : NewEntry
    }


type alias Talk =
    { title : String
    , duration : Int
    , sections : Dict Int Section
    , frames : List Frame
    , time : Int
    }


type alias Frame =
    { section : String
    , point : String
    , dutation : Int
    , start : Int
    , end : Int
    }


type alias Section =
    { title : String
    , duration : Int
    , points : Dict Int Point
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
    | ValidateEntry
    | ClearEntry
    | StartTalk
    | StopTalk
    | UserInput NewInput
