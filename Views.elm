module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (colspan, rowspan, style, title, disabled)
import Html.Events exposing (onClick)
import Html.Lazy exposing (lazy, lazy2, lazy3)
import Report.Section as Section
import Report.Account as Account
import Types exposing (..)
import Styles
import Numeral exposing (formatWithLanguage)
import Languages.German as German
import Filter


type alias Msg =
    Types.Msg Filter.Msg


asCurrency : Float -> String
asCurrency =
    formatWithLanguage German.lang "0,0.00 $"


asPercentage : Float -> String
asPercentage =
    formatWithLanguage German.lang "0.0 %"


viewCurrency : Currency -> Html msg
viewCurrency value =
    span [ Styles.currencyStyle ] [ text (asCurrency value) ]


viewPercentage : Float -> Html msg
viewPercentage value =
    span [ Styles.percentageStyle ] [ text (asPercentage (value / 100.0)) ]


viewOwn : CurrencyWithPercentage -> List (Html msg)
viewOwn ( own, percentage ) =
    [ td [ Styles.currencyStyle, Styles.leftBorder ] [ viewCurrency own ]
    , td [ Styles.rightBorder ] [ viewPercentage percentage ]
    ]


viewOther : String -> Calculation -> List (Html msg)
viewOther key { median, average } =
    let
        ( medianValue, medianPercentage ) =
            median

        ( averageValue, averagePercentage ) =
            average
    in
        [ td [ Styles.leftBorder ] [ viewCurrency medianValue ]
        , td [] [ viewPercentage medianPercentage ]
        , td [] [ viewCurrency averageValue ]
        , td [ Styles.rightBorder ] [ viewPercentage averagePercentage ]
        ]


viewNumbers : List Number -> String
viewNumbers numbers =
    String.join "," numbers


viewAccount : Level -> Level -> Account.Account Row -> List (Html msg)
viewAccount level index (Account.Account { name, value, subAccounts }) =
    if toInt index <= toInt level then
        tr [ title (viewNumbers value.numbers) ]
            (th [] [ text name ]
                :: viewOwn value.own
                ++ viewOther name value.other
                ++ viewOther name value.geo
            )
            :: List.concatMap
                (viewAccount level (incrementLevel index))
                subAccounts
    else
        []


viewCaption : String -> Html msg
viewCaption caption =
    th
        [ colspan 11, Styles.headerStyle ]
        [ text caption ]


viewSection : Level -> Level -> Section.Section Row -> List (Html msg)
viewSection level index section =
    tr []
        [ viewCaption section.name ]
        :: List.concatMap (viewAccount level (incrementLevel index)) section.accounts
        ++ viewAccount level index section.sum


viewLevel : Level -> Html Msg
viewLevel level =
    div []
        [ button
            [ onClick (SetLevel First)
            , disabled (level == First)
            ]
            [ text "Level 1" ]
        , button
            [ onClick (SetLevel Second)
            , disabled (level == Second)
            ]
            [ text "Level 2" ]
        , button
            [ onClick (SetLevel Third)
            , disabled (level == Third)
            ]
            [ text "Level 3" ]
        , button
            [ onClick (SetLevel Fourth)
            , disabled (level == Fourth)
            ]
            [ text "Level 4" ]
        ]


viewReport : Level -> Report -> Html Msg
viewReport level report =
    table [ Styles.tableStyle ]
        [ thead
            []
            [ Html.tr []
                [ th [] []
                , th
                    [ colspan 2
                    , rowspan 2
                    , Styles.leftBorder
                    , Styles.rightBorder
                    ]
                    [ text "Current" ]
                , th
                    [ colspan 4
                    , Styles.leftBorder
                    , Styles.rightBorder
                    ]
                    [ text "Other" ]
                , th
                    [ colspan 4
                    , Styles.leftBorder
                    , Styles.rightBorder
                    ]
                    [ text "Geo" ]
                ]
            , Html.tr []
                [ th [] []
                , th [ Styles.leftBorder ] [ text "median" ]
                , th [] [ text "% median" ]
                , th [] [ text "average" ]
                , th [ Styles.rightBorder ] [ text "% average" ]
                , th [ Styles.leftBorder ] [ text "median" ]
                , th [] [ text "% median" ]
                , th [] [ text "average" ]
                , th [ Styles.rightBorder ] [ text "% average" ]
                ]
            ]
        , tbody
            []
            (List.concatMap (viewSection level First) report.sections)
        ]


view : Model -> Html Msg
view model =
    div []
        [ node "style" [] [ text """td, th { padding: 4px }""" ]
        , lazy (Html.map SetFilter) (Filter.view model.filter)
        , button [ onClick Fetch ] [ text "Filter" ]
        , hr [] []
        , case model.report of
            Just report ->
                div []
                    [ lazy viewLevel model.level
                    , lazy2 viewReport model.level report
                    ]

            Nothing ->
                -- div [] [ text "Loading..." ]
                text ""
        ]
