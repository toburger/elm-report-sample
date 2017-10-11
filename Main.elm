module Main exposing (..)

import Types exposing (..)
import Html
import Rest
import Views exposing (view)
import Filter


type alias Msg =
    Types.Msg Filter.Msg


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
            { seacNumber = "3921V35154", ombisId = 8609 }
        , typeFilteredCompanyIds =
            [ { seacNumber = "3921V22004", ombisId = 23617 }
            , { seacNumber = "3921V35154", ombisId = 8609 }
            , { seacNumber = "3922V23408", ombisId = 8690 }
            ]
        , geoFilteredCompanyIds =
            [ { seacNumber = "3921V22004", ombisId = 23617 }
            , { seacNumber = "3921V35154", ombisId = 8609 }
            , { seacNumber = "3922V23408", ombisId = 8690 }
            ]
        }
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( Model Nothing initialFilter Third, Rest.fetchReport initialFilter )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            { model | report = Nothing } ! [ Rest.fetchReport model.filter ]

        Fetched (Ok report) ->
            { model | report = Just report } ! []

        SetFilter filterMsg ->
            { model | filter = Filter.update filterMsg model.filter } ! []

        Fetched (Err msg) ->
            let
                _ =
                    Debug.log "error" msg
            in
                { model | report = Nothing }
                    ! []

        SetLevel level ->
            { model | level = level } ! []


main : Program Never Model Msg
main =
    Html.program
        { init = initialModel
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
