module Report.Json.Decoders exposing (..)

import Report.Account as Account
import Report.Section as Section
import Report.Report as Report
import Json.Decode as Json
import Json.Decode.Pipeline exposing (..)


account : Json.Decoder a -> Json.Decoder (Account.Account a)
account valueDecoder =
    decode Account.create
        |> required "name" Json.string
        |> required "subAccounts" (Json.lazy (\_ -> accountList valueDecoder))
        |> optional "sum" (Json.lazy (\_ -> Json.maybe (account valueDecoder))) Nothing
        |> required "value" valueDecoder


accountList : Json.Decoder a -> Json.Decoder (List (Account.Account a))
accountList valueDecoder =
    Json.list (account valueDecoder)


section : Json.Decoder a -> Json.Decoder (Section.Section a)
section valueDecoder =
    decode Section.create
        |> required "name" Json.string
        |> required "accounts" (accountList valueDecoder)
        |> required "sum" (account valueDecoder)


sectionList : Json.Decoder a -> Json.Decoder (List (Section.Section a))
sectionList valueDecoder =
    Json.list (section valueDecoder)


report : Json.Decoder a -> Json.Decoder (Report.Report a)
report valueDecoder =
    decode Report.create
        |> required "name" Json.string
        |> required "sections" (sectionList valueDecoder)
