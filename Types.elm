module Types exposing (..)

import Report.Report as Report
import Http
import Material


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


type Level
    = First
    | Second
    | Third
    | Fourth
    | Fifth


incrementLevel : Level -> Level
incrementLevel level =
    case level of
        First ->
            Second

        Second ->
            Third

        Third ->
            Fourth

        Fourth ->
            Fifth

        Fifth ->
            First


toInt : Level -> Int
toInt level =
    case level of
        First ->
            1

        Second ->
            2

        Third ->
            3

        Fourth ->
            4

        Fifth ->
            5


type alias CompanyId =
    { seacNumber : String, ombisId : Int }


type alias DateRange =
    { fromYear : Int, fromMonth : Int, untilYear : Int, untilMonth : Int }


type alias Companies =
    { ownCompanyId : CompanyId
    , typeFilteredCompanyIds : List CompanyId
    , geoFilteredCompanyIds : List CompanyId
    }


type alias Filter =
    { companyType : Int
    , bookkeeping : Int
    , dateRange : DateRange
    , companies : Companies
    }
