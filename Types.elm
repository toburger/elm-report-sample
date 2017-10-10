module Types exposing (..)

import Report.Report as Report
import Http


type alias Number =
    String


type alias Currency =
    Float


type alias CurrencyWithPercentage =
    ( Currency, Float )


type alias Calculation =
    { count : Int
    , sum : CurrencyWithPercentage
    , median : CurrencyWithPercentage
    , average : CurrencyWithPercentage
    }


type alias Row =
    { numbers : List Number
    , own : CurrencyWithPercentage
    , other : Calculation
    , geo : Calculation
    }


type alias Report =
    Report.Report Row


type alias Model =
    { report : Maybe Report }


type Msg
    = Increment
    | Decrement
    | Fetched (Result Http.Error Report)
