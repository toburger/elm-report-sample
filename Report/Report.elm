module Report.Report exposing (..)

import Report.Section as Section exposing (Section)


type alias Report a =
    { name : String
    , sections : List (Section a)
    }


create : String -> List (Section a) -> Report a
create name sections =
    Report name sections


map : (a -> b) -> Report a -> Report b
map f report =
    { name = report.name
    , sections = List.map (Section.map f) report.sections
    }


apply : Report (a -> b) -> Report a -> Report b
apply f report =
    { name = report.name
    , sections = List.map2 Section.apply f.sections report.sections
    }


map2 : (a -> b -> c) -> Report a -> Report b -> Report c
map2 f report1 report2 =
    apply (map f report1) report2
