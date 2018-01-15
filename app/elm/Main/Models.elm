module Main.Models exposing (..)

import Time exposing (Time)
import Dict exposing (..)


initModel : Flags -> Model
initModel flags_ =
    { talkTime = 0
    , apiUrl = flags_.apiUrl
    , talk =
        { title = ""
        , duration = 0
        , sections = Dict.empty
        }
    , action = Reviewing
    , newEntry =
        blankEntry
    }


blankEntry : NewEntry
blankEntry =
    { title = ""
    , seconds = 0
    , minutes = 0
    , position = 0
    , entryType = TalkType
    }



--MODELS


type alias Flags =
    { apiUrl : String }


type alias Model =
    { apiUrl : String
    , talkTime : Int
    , talk : Talk
    , action : Action
    , newEntry : NewEntry
    }


type alias Talk =
    { title : String
    , duration : Int
    , sections : Dict String Section
    }


type alias Section =
    { title : String
    , duration : Int
    , start : Int
    , end : Int
    , subtopics : Dict String Subtopic
    }


type alias Subtopic =
    { title : String
    , duration : Int
    , start : Int
    , end : Int
    }


type alias NewEntry =
    { title : String
    , minutes : Int
    , seconds : Int
    , position : Int
    , entryType : EntryType
    }


type Action
    = Editing
    | Reviewing
    | Speaking


type EntryType
    = TalkType
    | SectionType Maybe String
    | SubtopicType String Maybe String


type NewInput
    = Title String
    | Minutes String
    | Seconds String


type Msg
    = NoOp
    | Tick Time
    | EditEntry EntryType
    | SaveEntry
    | ClearEntry
    | StartTalk
    | StopTalk
    | UserInput NewInput
