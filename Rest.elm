module Rest exposing (..)

import Report.Decoders as Decoders
import Decoders
import Types exposing (Row, Calculation, Msg(Fetched))
import Http


fetchReport : Cmd Msg
fetchReport =
    let
        url =
            "./api/data.json"

        request =
            Http.get url (Decoders.report Decoders.row)
    in
        Http.send Fetched request
