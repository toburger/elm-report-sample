module Json.Decoders exposing (..)

import Json.Decode as Json
import Json.Decode.Pipeline exposing (..)
import Types exposing (Number, Currency, CurrencyWithPercentage, Row, Calculation)


number : Json.Decoder Number
number =
    Json.string


currency : Json.Decoder Currency
currency =
    Json.float


arrayAsTuple2 : Json.Decoder a -> Json.Decoder b -> Json.Decoder ( a, b )
arrayAsTuple2 a b =
    Json.index 0 a
        |> Json.andThen
            (\aVal ->
                Json.index 1 b
                    |> Json.andThen
                        (\bVal ->
                            Json.succeed ( aVal, bVal )
                        )
            )


currencyWithPercentage : Json.Decoder CurrencyWithPercentage
currencyWithPercentage =
    arrayAsTuple2 currency Json.float


calculation : Json.Decoder Calculation
calculation =
    decode Calculation
        |> required "count" Json.int
        |> required "sum" currencyWithPercentage
        |> required "median" currencyWithPercentage
        |> required "average" currencyWithPercentage


row : Json.Decoder Row
row =
    decode Row
        |> required "numbers" (Json.list number)
        |> required "own" currencyWithPercentage
        |> required "other" calculation
        |> required "geo" calculation
