module Encoders exposing (..)

import Types
import Json.Encode exposing (..)


(=>) =
    (,)


companyId : Types.CompanyId -> Value
companyId companyId =
    object
        [ "seacNumber" => string companyId.seacNumber
        , "ombisId" => int companyId.ombisId
        ]


dateRange : Types.DateRange -> Value
dateRange dateRange =
    object
        [ "fromYear" => int dateRange.fromYear
        , "fromMonth" => int dateRange.fromMonth
        , "untilYear" => int dateRange.untilYear
        , "untilMonth" => int dateRange.untilMonth
        ]


companies : Types.Companies -> Value
companies companies =
    object
        [ "ownCompanyId" => companyId companies.ownCompanyId
        , "typeFilteredCompanyIds"
            => list (List.map companyId companies.typeFilteredCompanyIds)
        , "geoFilteredCompanyIds"
            => list (List.map companyId companies.geoFilteredCompanyIds)
        ]


filter : Types.Filter -> Value
filter filter =
    object
        [ "companyType" => int filter.companyType
        , "bookkeeping" => int filter.bookkeeping
        , "dateRange" => dateRange filter.dateRange
        , "companies" => companies filter.companies
        ]
