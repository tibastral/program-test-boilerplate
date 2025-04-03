# Lamdera Program-Test Boilerplate

This repository provides a minimal boilerplate to get started with the `program-test` package in your Lamdera application. It allows you to write and run end-to-end tests with ease.

## Understanding Program-Test

`program-test` is a powerful testing framework for Lamdera applications that allows you to write end-to-end tests. These tests simulate user interactions and verify that your application behaves as expected.

## The Key Insight: Program-Tests Are Just Regular Tests

One of the most important things to understand about program-tests is that they are not fundamentally different from regular Elm tests. This means:

1. They can be run using the exact same command as your regular tests:

```
elm-test-rs --compiler lamdera
```

2. They integrate seamlessly with your existing test suite.

## Visualizing Your Tests in Action

What makes program-tests special is the ability to actually *see* them running:

1. Start your Lamdera development server:

```
lamdera live
```

2. Navigate to:

```
http://localhost:8000/tests/TestsRunner.elm
```

This provides a visual playground where you can:
- Watch your tests execute step by step
- See the actual UI state at each point in the test
- Debug visual issues that might be difficult to catch in headless tests

## Getting Started

1. Write your tests in the `tests` folder (you can copy HelloWorldTest.elm and change it to suite your needs)
2. Import it in the `tests/Tests.elm` file
3. Run them with `elm-test-rs --compiler lamdera` for quick feedback
4. Visualize them through the browser for deeper inspection (visit http://localhost:8000/tests/TestsRunner.elm)

## Example Test

Your tests will typically follow this pattern:

```elm
helloWorldTest : TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel
helloWorldTest =
    TF.start "Test Hello World"
        (Time.millisToPosix 0)
        config
        [ TF.connectFrontend
            100
            (sessionIdFromString "session1")
            "/"
            { width = 900, height = 800 }
            (\client ->
                [ client.input 100 (Dom.id "best-framework") "react"
                , client.click 100 (Dom.id "save-the-world")
                , client.checkView
                    100
                    (Test.Html.Query.has
                        [ Test.Html.Selector.text "Thank you, Mario, but the slowness is in another framework"
                        , Test.Html.Selector.text "Take that, react"
                        ]
                    )
                ]
            )
        ]
```

## Benefits of This Approach

- **Complete testing**: Test your entire application from UI to backend
- **Visual verification**: See exactly what your users will see
- **Confidence**: Know that your features work end-to-end before deploying
- **Fastness**: As end to end in lamdera is just pure functions calls, it's faster than any other E2E testing solution 

## Next Steps

Explore the example tests included in this boilerplate and start writing your own. The combination of automated testing with visual inspection provides a powerful workflow for building robust Lamdera applications. 