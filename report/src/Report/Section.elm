module Report.Section exposing (..)

import Report.Account as Account exposing (Account)


type alias Section a =
    { name : String
    , accounts : List (Account a)
    , sum : Account a
    }


create : String -> List (Account a) -> Account a -> Section a
create name accounts sum =
    Section name accounts sum


map : (a -> b) -> Section a -> Section b
map f section =
    { name = section.name
    , accounts = List.map (Account.map f) section.accounts
    , sum = Account.map f section.sum
    }


apply : Section (a -> b) -> Section a -> Section b
apply fs section =
    { name = section.name
    , accounts = List.map2 Account.apply fs.accounts section.accounts
    , sum = Account.apply fs.sum section.sum
    }


map2 : (a -> b -> c) -> Section a -> Section b -> Section c
map2 f section1 section2 =
    apply (map f section1) section2
