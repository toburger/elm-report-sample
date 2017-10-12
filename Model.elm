module Model exposing (..)

import Report.Report exposing (Report)
import Filter
import Types exposing (Row, Level)
import Material
import Http


type alias Model =
    { report : Maybe (Report Row)
    , filter : Filter.Model
    , level : Level
    , mdl : Material.Model
    }


type Msg
    = Fetch
    | Fetched (Result Http.Error (Report Row))
    | SetFilter Filter.Msg
    | SetLevel Level
    | Mdl (Material.Msg Msg)
