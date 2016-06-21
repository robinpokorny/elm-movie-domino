module Models exposing (..)

import Http


type alias Actor =
    { name : String
    , id : Int
    }


type Status
    = Initial
    | InProgress
    | Loaded
    | Error


type alias Model =
    { actorSearchFieldText : String
    , actors : Maybe (List Actor)
    , errorMessage : Maybe String
    , status : Status
    }


type DominoAppMessage
    = SearchClicked
    | SearchSucceeded (List Actor)
    | SearchFailed Http.Error
    | TextChanged String
