module Filter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Filter, DateRange)


type alias Model =
    Filter


type Msg
    = UpdateFilter Filter


update msg model =
    case msg of
        UpdateFilter filter ->
            filter


viewYears : Int -> List (Html msg)
viewYears selectedYear =
    List.range 2010 2020
        |> List.map (\year -> option [ id (toString year), selected (year == selectedYear) ] [ text (toString year) ])


viewMonths : Int -> List (Html msg)
viewMonths selectedMonth =
    List.range 1 12
        |> List.map (\month -> option [ id (toString month), selected (month == selectedMonth) ] [ text (toString month) ])


updateDateRange : Filter -> DateRange -> Filter
updateDateRange filter dateRange =
    { filter | dateRange = dateRange }


updateFromYear : DateRange -> Int -> DateRange
updateFromYear dateRange fromYear =
    { dateRange | fromYear = fromYear }


updateFromMonth : DateRange -> Int -> DateRange
updateFromMonth dateRange fromMonth =
    { dateRange | fromMonth = fromMonth }


updateUntilYear : DateRange -> Int -> DateRange
updateUntilYear dateRange untilYear =
    { dateRange | untilYear = untilYear }


updateUntilMonth : DateRange -> Int -> DateRange
updateUntilMonth dateRange untilMonth =
    { dateRange | untilMonth = untilMonth }


dateRangeMsg : (DateRange -> Int -> DateRange) -> Filter -> String -> Msg
dateRangeMsg f filter =
    (String.toInt
        >> Result.withDefault filter.dateRange.fromYear
        >> (UpdateFilter << updateDateRange filter << f filter.dateRange)
    )


view : Filter -> Html Msg
view filter =
    div []
        [ div []
            [ label
                [ for "fromYear" ]
                [ text "From Year" ]
            , select
                [ id "fromYear"
                , onInput (dateRangeMsg updateFromYear filter)
                , value (toString filter.dateRange.fromYear)
                ]
                (viewYears filter.dateRange.fromYear)
            , label
                [ for "fromMonth" ]
                [ text "From Month" ]
            , select
                [ id "fromMonth"
                , onInput (dateRangeMsg updateFromMonth filter)
                , value (toString filter.dateRange.fromMonth)
                ]
                (viewMonths filter.dateRange.fromMonth)
            ]
        , div
            []
            [ label
                [ for "untilYear" ]
                [ text "Until Year" ]
            , select
                [ id "untilYear"
                , onInput (dateRangeMsg updateUntilYear filter)
                , value (toString filter.dateRange.untilYear)
                ]
                (viewYears filter.dateRange.untilYear)
            , label
                [ for "untilMonth" ]
                [ text "Until Month" ]
            , select
                [ id "untilMonth"
                , onInput (dateRangeMsg updateUntilMonth filter)
                , value (toString filter.dateRange.untilMonth)
                ]
                (viewMonths filter.dateRange.untilMonth)
            ]
        ]
