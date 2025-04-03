module Tests exposing (..)

import Effect.Test as TF
import HelloWorldTest
import Test exposing (..)


appTests : Test
appTests =
    describe "App tests" 
        [ describe "Hello World" (List.map TF.toTest HelloWorldTest.tests)
        ]
