module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (colspan, rowspan, style, title)
import Html.Events exposing (onClick)
import Report.Section as Section
import Report.Account as Account
import Types exposing (..)
import Styles
import Numeral exposing (formatWithLanguage)
import Languages.German as German


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


viewAccount : Account.Account Row -> List (Html msg)
viewAccount (Account.Account { name, value, subAccounts }) =
    tr [ title (viewNumbers value.numbers) ]
        (th [] [ text name ]
            :: viewOwn value.own
            ++ viewOther name value.other
            ++ viewOther name value.geo
        )
        :: List.concatMap viewAccount subAccounts


viewCaption : String -> Html msg
viewCaption caption =
    th
        [ colspan 11, Styles.headerStyle ]
        [ text caption ]


viewSection : Section.Section Row -> Html msg
viewSection section =
    tbody []
        (tr []
            [ viewCaption section.name ]
            :: List.concatMap viewAccount section.accounts
            ++ viewAccount section.sum
        )


view : Model -> Html Msg
view model =
    case model.report of
        Just report ->
            div []
                [ node "style" [] [ text "td { padding: 4px }" ]
                , table [ Styles.tableStyle ]
                    (thead []
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
                        :: (report.sections |> List.map viewSection)
                    )
                , button [ onClick Increment ] [ text "+" ]
                , button [ onClick Decrement ] [ text "-" ]
                ]

        Nothing ->
            -- div [] [ text "Loading..." ]
            text ""
