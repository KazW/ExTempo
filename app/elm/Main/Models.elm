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
        , frames = Array.empty
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
    , points = Array.empty
    }


blankPoint : Point
blankPoint =
    { title = ""
    , duration = 0
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
    , sections : Array Section
    , frames : Array Frame
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
    | ValidateEntry
    | ClearEntry
    | StartTalk
    | StopTalk
    | UserInput NewInput
