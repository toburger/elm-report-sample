module Rest exposing (..)

import Report.Decoders as Decoders
import Decoders
import Types exposing (Row, Calculation)
import Report.Report exposing (Report)
import Http
import Encoders


-- fetchReport : Cmd Msg
-- fetchReport =
--     let
--         url =
--             "./api/data.json"
--         request =
--             Http.get url (Decoders.report Decoders.row)
--     in
--         Http.send Fetched request


fetchReport : (Result Http.Error (Report Row) -> msg) -> Types.Filter -> Cmd msg
fetchReport msg filter =
    let
        url =
            "http://localhost:8083/api/reports/benchmark/investmentSuccessBalance"

        body =
            Http.jsonBody (Encoders.filter filter)

        request =
            Http.post url body (Decoders.report Decoders.row)
    in
        Http.send msg request
