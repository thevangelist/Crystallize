{-# LANGUAGE OverloadedStrings #-}
module Web.Config
    ( readConfig
    ) where

import qualified Data.Configurator as C
import           Web.Types

-- Read config file.
readConfig :: FilePath -> IO AppConfig
readConfig cfgFile = do
    cfg  <- C.load [C.Required cfgFile]
    port <- C.require cfg "port"
    path <- C.require cfg "path"
    return (AppConfig port path)
