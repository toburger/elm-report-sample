module List.Extras exposing (average, median)

import Median


average : List Float -> Maybe Float
average xs =
    let
        length =
            List.length xs
    in
        if length == 0 then
            Nothing
        else
            Just (List.sum xs / toFloat length)


median : List Float -> Maybe Float
median xs =
    Median.median xs
