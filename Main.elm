module Main exposing (..)

import Report.Report as Report
import Types exposing (..)
import Utils
import Html
import Views exposing (view)


initialModel : ( Model, Cmd Msg )
initialModel =
    ( Model Nothing, fetchReport )


updateOwn : (Currency -> Currency) -> Row -> Row
updateOwn f row =
    let
        ( value, percentage ) =
            row.own
    in
        { row | own = ( f value, percentage ) }


updateOtherMedian : (Currency -> Currency) -> Row -> Row
updateOtherMedian f row =
    let
        other =
            row.other

        ( median, percentage ) =
            row.other.median
    in
        { row | other = { other | median = ( f median, percentage ) } }


updateOtherAverage : (Currency -> Currency) -> Row -> Row
updateOtherAverage f row =
    let
        other =
            row.other

        ( average, percentage ) =
            row.other.average
    in
        { row | other = { other | average = ( f average, percentage ) } }


updateReportValue : (Currency -> Currency) -> Report -> Report
updateReportValue f report =
    report
        |> Report.map (updateOwn f)
        |> Report.map (updateOtherMedian f)
        |> Report.map (updateOtherAverage f)


fetchReport : Cmd Msg
fetchReport =
    Utils.fetchReport Fetched


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            { model
                | report = Maybe.map (updateReportValue ((+) 1)) model.report
            }
                ! []

        Decrement ->
            { model
                | report = Maybe.map (updateReportValue (flip (-) 1)) model.report
            }
                ! []

        Fetched (Ok report) ->
            { model | report = Just report } ! []

        Fetched (Err msg) ->
            let
                _ =
                    Debug.log "error" msg
            in
                { model | report = Nothing }
                    ! []


main : Program Never Model Msg
main =
    Html.program
        { init = initialModel
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
