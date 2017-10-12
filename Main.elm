module Main exposing (..)

import Types exposing (..)
import Html
import Rest
import Views exposing (view)
import Filter
import Material
import Model exposing (..)
import Material.Select as Select


initialFilter : Filter
initialFilter =
    { companyType = 1
    , bookkeeping = 1
    , dateRange =
        { fromYear = 2016
        , fromMonth = 1
        , untilYear = 2016
        , untilMonth = 12
        }
    , companies =
        { ownCompanyId =
            CompanyId "3921V35154" 8609
        , typeFilteredCompanyIds =
            [ CompanyId "3921V22004" 23617
            , CompanyId "3921V35154" 8609
            , CompanyId "3922V23408" 8690
            ]
        , geoFilteredCompanyIds =
            [ CompanyId "3921V22004" 23617
            , CompanyId "3921V35154" 8609
            , CompanyId "3922V23408" 8690
            ]
        }
    }


fetchReport : Filter -> Cmd Msg
fetchReport =
    Rest.fetchReport Fetched


initialModel : ( Model, Cmd Msg )
initialModel =
    ( Model Nothing
        (Filter.Model initialFilter Material.model)
        Third
        Material.model
    , fetchReport initialFilter
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            { model | report = Nothing } ! [ fetchReport model.filter.filter ]

        SetFilter filterMsg ->
            case filterMsg of
                Filter.Fetch ->
                    update Fetch model

                _ ->
                    let
                        ( filter_, cmd_ ) =
                            Filter.update filterMsg model.filter
                    in
                        { model | filter = filter_ } ! [ Cmd.map SetFilter cmd_ ]

        Fetched (Ok report) ->
            { model | report = Just report } ! []

        Fetched (Err msg) ->
            let
                _ =
                    Debug.log "error" msg
            in
                { model | report = Nothing }
                    ! []

        SetLevel level ->
            { model | level = level } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Select.subs Mdl model.mdl
        , Sub.map SetFilter (Select.subs Filter.Mdl model.filter.mdl)
        , Material.subscriptions Mdl model
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = initialModel
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
