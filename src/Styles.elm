module Styles exposing (..)

import Html.Attributes exposing (style)


(=>) =
    (,)


tableStyle =
    style
        [ "width" => "100%"
        , "border-collapse" => "collapse"
        , "white-space" => "nowrap"
        ]


headerStyle =
    style
        [ "background-color" => "black"
        , "color" => "white"
        ]


currencyStyle =
    style
        [ "text-align" => "right"
        , "width" => "100%"
        , "display" => "block"
        ]


percentageStyle =
    style
        [ "text-align" => "right"
        , "width" => "100%"
        , "display" => "block"
        ]


leftBorder =
    style
        [ "border-left" => "1px solid black" ]


rightBorder =
    style
        [ "border-right" => "1px solid black" ]
