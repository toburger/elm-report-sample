module Filter exposing (..)

import Html exposing (..)
import Types exposing (Filter, DateRange)
import Material
import Material.Select as Select
import Material.Dropdown.Item as Item
import Material.Card as Card
import Material.Button as Button
import Material.Options as Options exposing (cs, css)
import Material.Elevation as Elevation
import Material.Grid exposing (..)


type alias Model =
    { filter : Filter
    , mdl : Material.Model
    }


type Msg
    = Fetch
    | UpdateFilter Filter
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            model ! []

        UpdateFilter filter ->
            { model | filter = filter } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


updateDateRange : Filter -> DateRange -> Filter
updateDateRange filter dateRange =
    { filter | dateRange = dateRange }


updateFromYear : DateRange -> Int -> DateRange
updateFromYear dateRange fromYear =
    { dateRange | fromYear = fromYear }


updateFromMonth : DateRange -> Int -> DateRange
updateFromMonth dateRange fromMonth =
    { dateRange | fromMonth = fromMonth }


updateUntilYear : DateRange -> Int -> DateRange
updateUntilYear dateRange untilYear =
    { dateRange | untilYear = untilYear }


updateUntilMonth : DateRange -> Int -> DateRange
updateUntilMonth dateRange untilMonth =
    { dateRange | untilMonth = untilMonth }


dateRangeMsg : (DateRange -> Int -> DateRange) -> Filter -> Int -> Msg
dateRangeMsg f filter =
    UpdateFilter << updateDateRange filter << f filter.dateRange


viewYears : (Int -> msg) -> List (Select.Item msg)
viewYears msg =
    List.range 2010 2020
        |> List.map
            (\year ->
                Select.item [ Item.onSelect (msg year) ] [ text (toString year) ]
            )


viewMonths : (Int -> msg) -> List (Select.Item msg)
viewMonths msg =
    List.range 1 12
        |> List.map
            (\month ->
                Select.item [ Item.onSelect (msg month) ] [ text (toString month) ]
            )


viewSelect : Material.Model -> Int -> String -> Int -> List (Select.Item Msg) -> Html Msg
viewSelect mdl index label value items =
    Select.render Mdl
        [ index ]
        mdl
        [ Select.label label
        , Select.floatingLabel
          -- , Select.ripple
        , Select.value (toString value)
        , Select.below
        ]
        items


style : Int -> List (Options.Style a)
style h =
    [ css "box-sizing" "border-box"
    , css "background-color" "#BDBDBD"
    , css "height" (toString h ++ "px")
    , css "padding-left" "8px"
    , css "padding-top" "4px"
    , css "color" "white"
    ]


view : Model -> Html Msg
view { filter, mdl } =
    Card.view
        [ css "width" "600px"
        , css "margin" "15px"
        , Elevation.e4
        ]
        [ Card.title
            []
            [ Card.head [] [ text "Filter" ] ]
        , Card.text []
            [ showDateRanges mdl filter
            ]
        , Card.actions [ Card.border ]
            [ Button.render Mdl
                [ 0 ]
                mdl
                [ Button.ripple
                , Button.colored
                , Button.raised
                , Options.onClick Fetch
                ]
                [ text "Filter" ]
            ]
        ]


showDateRanges : Material.Model -> Filter -> Html Msg
showDateRanges mdl filter =
    grid []
        [ cell [ size All 6 ]
            [ grid []
                [ cell [ size All 6 ]
                    [ viewSelect mdl
                        0
                        "From Year"
                        filter.dateRange.fromYear
                        (viewYears (dateRangeMsg updateFromYear filter))
                    ]
                , cell [ size All 6 ]
                    [ viewSelect mdl
                        1
                        "From Month"
                        filter.dateRange.fromMonth
                        (viewMonths (dateRangeMsg updateFromMonth filter))
                    ]
                ]
            ]
        , cell [ size All 6 ]
            [ grid []
                [ cell [ size All 6 ]
                    [ viewSelect mdl
                        2
                        "Until Year"
                        filter.dateRange.untilYear
                        (viewYears (dateRangeMsg updateUntilYear filter))
                    ]
                , cell [ size All 6 ]
                    [ viewSelect mdl
                        3
                        "Until Month"
                        filter.dateRange.untilMonth
                        (viewMonths (dateRangeMsg updateUntilMonth filter))
                    ]
                ]
            ]
        ]
