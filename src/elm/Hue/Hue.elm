module Hue.Hue exposing (..)

import Hue.Model as M
import Hue.Update as U
import Hue.View as V


type alias Model =
    M.Model


init =
    U.init


initModel =
    U.initModel


update =
    U.update


view =
    V.view

type alias Msg = U.Msg
