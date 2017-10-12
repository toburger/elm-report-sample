module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (colspan, rowspan, style, title, disabled)
import Html.Lazy exposing (lazy, lazy2, lazy3)
import Report.Section as Section
import Report.Account as Account
import Model exposing (..)
import Types exposing (..)
import Styles
import Numeral exposing (formatWithLanguage)
import Languages.German as German
import Filter
import Material
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Scheme as Scheme
import Material.Color as Color
import Material.Grid exposing (..)
import Material.Button as Button
import Material.Tooltip as Tooltip
import Material.Table as Table
import Material.Typography as Typo


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
    [ Table.td [ Table.numeric ] [ viewCurrency own ]
    , Table.td [ Table.numeric ] [ viewPercentage percentage ]
    ]


viewOther : String -> Calculation -> List (Html msg)
viewOther key { median, average } =
    let
        ( medianValue, medianPercentage ) =
            median

        ( averageValue, averagePercentage ) =
            average
    in
        [ Table.td [ Table.numeric ] [ viewCurrency medianValue ]
        , Table.td [ Table.numeric ] [ viewPercentage medianPercentage ]
        , Table.td [ Table.numeric ] [ viewCurrency averageValue ]
        , Table.td [ Table.numeric ] [ viewPercentage averagePercentage ]
        ]


viewNumbers : List Number -> String
viewNumbers numbers =
    String.join "," numbers


viewAccount : Material.Model -> Level -> Level -> Account.Account Row -> List (Html Msg)
viewAccount mdl level index (Account.Account { name, value, subAccounts }) =
    if toInt index <= toInt level then
        Table.tr
            []
            (Table.td []
                [ Options.styled span
                    [ Tooltip.attach Mdl [ 0 ] ]
                    [ text name ]
                ]
                :: viewOwn value.own
                ++ viewOther name value.other
                ++ viewOther name value.geo
            )
            :: Tooltip.render Mdl
                [ 0 ]
                mdl
                [ Tooltip.bottom ]
                [ text (viewNumbers value.numbers) ]
            :: List.concatMap
                (viewAccount mdl level (incrementLevel index))
                subAccounts
    else
        []


viewCaption : String -> Html msg
viewCaption caption =
    Table.td
        [ Options.attribute (colspan 11)
        , Typo.center
        , Typo.body2
        , Typo.uppercase
        , Color.text (Color.color Color.Brown Color.S500)
        ]
        [ text caption ]


viewSection : Material.Model -> Level -> Level -> Section.Section Row -> Html Msg
viewSection mdl level index section =
    Table.tbody []
        (Table.tr []
            [ viewCaption section.name ]
            :: List.concatMap (viewAccount mdl level (incrementLevel index)) section.accounts
            ++ viewAccount mdl level index section.sum
        )


viewLevel : Material.Model -> Level -> Html Msg
viewLevel mdl level =
    grid []
        [ cell [ size All 3 ]
            [ Button.render Mdl
                [ 0 ]
                mdl
                [ Options.onClick (SetLevel First)
                , Options.disabled (level == First)
                , css "width" "100%"
                ]
                [ text "Level 1" ]
            ]
        , cell [ size All 3 ]
            [ Button.render Mdl
                [ 1 ]
                mdl
                [ Options.onClick (SetLevel Second)
                , Options.disabled (level == Second)
                , css "width" "100%"
                ]
                [ text "Level 2" ]
            ]
        , cell [ size All 3 ]
            [ Button.render Mdl
                [ 2 ]
                mdl
                [ Options.onClick (SetLevel Third)
                , Options.disabled (level == Third)
                , css "width" "100%"
                ]
                [ text "Level 3" ]
            ]
        , cell [ size All 3 ]
            [ Button.render Mdl
                [ 3 ]
                mdl
                [ Options.onClick (SetLevel Fourth)
                , Options.disabled (level == Fourth)
                , css "width" "100%"
                ]
                [ text "Level 4" ]
            ]
        ]


viewReport : Material.Model -> Level -> Report -> Html Msg
viewReport mdl level report =
    Table.table [ css "width" "100%" ]
        (Table.thead
            []
            [ Table.tr []
                [ Table.th [] []
                , Table.th
                    [ Options.attribute (colspan 2)
                    , Options.attribute (rowspan 2)
                    ]
                    [ text "Current" ]
                , Table.th
                    [ Options.attribute (colspan 4) ]
                    [ text "Other" ]
                , Table.th
                    [ Options.attribute (colspan 4) ]
                    [ text "Geo" ]
                ]
            , Table.tr []
                [ Table.th [] []
                , Table.th [] [ text "median" ]
                , Table.th [] []
                , Table.th [] []
                , Table.th [] [ text "% average" ]
                , Table.th [] [ text "median" ]
                , Table.th [] [ text "% median" ]
                , Table.th [] [ text "average" ]
                , Table.th [] [ text "% average" ]
                ]
            ]
            :: (List.map (viewSection mdl level First) report.sections)
        )


view : Model -> Html Msg
view model =
    Scheme.topWithScheme Color.Brown Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            []
            { header = []
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ div []
                    [ node "style" [] [ text """td, th { padding: 4px }""" ]
                    , div
                        [ style
                            [ ( "display", "flex" )
                            , ( "justify-content", "center" )
                            ]
                        ]
                        [ Html.map SetFilter
                            (Filter.view model.filter)
                        ]
                    , case model.report of
                        Just report ->
                            div []
                                [ lazy2 viewLevel model.mdl model.level
                                , lazy3 viewReport model.mdl model.level report
                                ]

                        Nothing ->
                            text ""
                    ]
                ]
            }
