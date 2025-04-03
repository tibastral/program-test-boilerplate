module Tests exposing (..)

import Effect.Test as TF
import HelloWorldTest
import Test exposing (..)
import Types exposing (BackendModel, BackendMsg, FrontendModel, FrontendMsg, ToBackend, ToFrontend)

appTests : Test
appTests =
    describe "App tests" 
        [ describe "Hello World" (List.map TF.toTest HelloWorldTest.tests)
        ]


tests : List (TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel)
tests =
     HelloWorldTest.tests 
