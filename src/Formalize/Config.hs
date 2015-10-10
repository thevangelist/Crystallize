{-# LANGUAGE OverloadedStrings #-}
module Formalize.Config
    ( readConfig
    ) where

import Formalize.Types
import qualified Data.Configurator as C

-- Read config file.
readConfig :: FilePath -> IO AppConfig
readConfig cfgFile = do
    cfg  <- C.load [C.Required cfgFile]
    port <- C.require cfg "port"
    path <- C.require cfg "path"
    return (AppConfig port path)
