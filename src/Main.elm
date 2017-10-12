module Main exposing (..)

import Types exposing (Filter, Level(..), Row, CompanyId, Model, Msg(..))
import Html
import Rest
import Views exposing (view)
import Material
import Material.Select as Select
import RemoteData


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


initialModel : ( Model, Cmd Msg )
initialModel =
    ( Model RemoteData.Loading
        initialFilter
        Third
        Material.model
    , Rest.fetchReport initialFilter
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            { model | report = RemoteData.Loading }
                ! [ Rest.fetchReport model.filter ]

        SetFilter filter ->
            { model | filter = filter } ! []

        Fetched report ->
            { model | report = report } ! []

        SetLevel level ->
            { model | level = level } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Select.subs Mdl model.mdl
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
