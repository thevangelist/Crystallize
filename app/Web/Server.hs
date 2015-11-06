{-# LANGUAGE OverloadedStrings #-}
module Web.Server
    ( runServer
    , formalizerApp -- Exposed for testing.
    ) where

import           Network.Wai.Middleware.RequestLogger
import           Network.Wai.Middleware.Static

import           Web.Actions                          as Action
import           Web.Spock.Safe
import           Web.Types

-- Run the spock app.
runServer :: AppConfig -> IO ()
runServer conf =
    let port = cPort conf
        state = AppState (cPath conf) (cSMTP conf)
        spockCfg = defaultSpockCfg Nothing PCNoDatabase state
    in runSpock port $ spock spockCfg formalizerApp


-- Path for static files like .js and .css.
staticPath :: String
staticPath = "web/static"

-- Middlewares for application.
appMiddleware :: FormalizeApp ()
appMiddleware = do
    middleware logStdout
    middleware . staticPolicy $ noDots >-> addBase staticPath

-- Routes for application.
appRoutes :: FormalizeApp ()
appRoutes = do
    get  root      Action.home
    post "/submit" Action.submit
    hookAny GET    Action.notFound

-- Join middlewares and routes to spock app.
formalizerApp :: FormalizeApp ()
formalizerApp = appMiddleware >> appRoutes
