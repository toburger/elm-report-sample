module Utils exposing (..)

import Report.Report as Report
import Report.Section as Section
import Report.Account as Account
import Report.Decoders as Decoders
import Decoders
import Types exposing (Row, Calculation)
import Http


report =
    Report.create


section =
    Section.create


account name numbers subAccounts =
    Account.create name subAccounts Nothing numbers



{-
      reportTemplate =
          report "report#1"
              [ section "section#1"
                  [ account "account#1"
                      [ "acc-1" ]
                      []
                  , account
                      "account#2"
                      [ "acc-2" ]
                      [ account "sub-account#1" [ "sub-acc-1", "sub-acc-10" ] []
                      , account "sub-account#2" [ "sub-acc-2" ] []
                      ]
                  , account "account#3" [] []
                  ]
                  (account "sum" [] [])
              , section
                  "section#2"
                  [ account "account#1"
                      [ "acc-3" ]
                      []
                  , account
                      "account#2"
                      [ "acc-4" ]
                      [ account "sub-account#1" [ "sub-acc-111", "sub-acc-10" ] []
                      , account "sub-account#2" [ "sub-acc-200" ] []
                      ]
                  ]
                  (account "sum" [] [])
              ]


   (<$>) =
       Report.map


   (<*>) =
       Report.apply


   createReport : Report.Report Row
   createReport =
       let
           x =
               reportTemplate
                   |> Report.map (always ( 0, 0 ))

           y =
               reportTemplate
                   |> Report.map (\av -> Calculation 0 ( 0, 0 ) ( 0, 0 ) ( 0, 0 ))

           z =
               reportTemplate |> Report.map identity

           combine val1 val2 val3 val4 =
               { numbers = val4
               , own = val1
               , other = val2
               , geo = val3
               }
       in
           combine <$> x <*> y <*> y <*> z
-}


fetchReport : (Result Http.Error (Report.Report Row) -> msg) -> Cmd msg
fetchReport handler =
    let
        url =
            "./api/data.json"

        request =
            Http.get url (Decoders.report Decoders.row)
    in
        Http.send handler request
