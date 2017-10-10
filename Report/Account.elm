module Report.Account exposing (Account(Account), create, map, apply, map2, bind)


type Account a
    = Account
        { name : String
        , subAccounts : List (Account a)
        , sum : Maybe (Account a)
        , value : a
        }


create : String -> List (Account a) -> Maybe (Account a) -> a -> Account a
create name subAccounts sum value =
    Account
        { name = name
        , subAccounts = subAccounts
        , sum = sum
        , value = value
        }


map : (a -> b) -> Account a -> Account b
map f (Account account) =
    Account
        { name = account.name
        , subAccounts = List.map (map f) account.subAccounts
        , sum = Maybe.map (map f) account.sum
        , value = f account.value
        }


apply : Account (a -> b) -> Account a -> Account b
apply (Account accountf) (Account account) =
    Account
        { name = account.name
        , subAccounts = List.map2 apply accountf.subAccounts account.subAccounts
        , sum = Maybe.map2 apply accountf.sum account.sum
        , value = accountf.value account.value
        }


map2 : (a -> b -> c) -> Account a -> Account b -> Account c
map2 f acc1 acc2 =
    apply (map f acc1) acc2


bind : (a -> Account b) -> Account a -> Account b
bind f (Account account) =
    let
        (Account account_) =
            f account.value
    in
        Account
            { account_
                | subAccounts = List.map (bind f) account.subAccounts
            }
