module Rest exposing (..)

import Json.Decoders as Decoders
import Report.Json.Decoders as Decoders
import Types exposing (Row, Calculation)
import Http
import Json.Encoders as Encoders
import RemoteData


-- fetchReport : Types.Filter -> Cmd Types.Msg
-- fetchReport _ =
--     let
--         url =
--             "./api/data.json"
--     in
--         Http.get url (Decoders.report Decoders.row)
--             |> RemoteData.sendRequest
--             |> Cmd.map Types.Fetched


fetchReport : Types.Filter -> Cmd Types.Msg
fetchReport filter =
    let
        url =
            "http://localhost:8083/api/reports/benchmark/investmentSuccessBalance"

        body =
            Http.jsonBody (Encoders.filter filter)
    in
        Http.post url body (Decoders.report Decoders.row)
            |> RemoteData.sendRequest
            |> Cmd.map Types.Fetched
