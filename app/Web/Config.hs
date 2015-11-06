{-# LANGUAGE OverloadedStrings #-}
module Web.Config
    ( readConfig
    ) where

import qualified Data.Configurator       as C
import           Data.Configurator.Types (Config)

import           Formalize.Types
import           Web.Types

-- Read config file.
readConfig :: FilePath -> IO AppConfig
readConfig cfgFile = do
    cfg  <- C.load [C.Required cfgFile]
    port <- C.require cfg "port"
    path <- C.require cfg "path"
    smtp <- readSMTP cfg
    return $ AppConfig port path smtp

readSMTP :: Config -> IO SMTPInfo
readSMTP cfg = do
    host <- C.require cfg "smtp.host"
    from <- C.require cfg "smtp.from"
    user <- C.require cfg "smtp.user"
    pass <- C.require cfg "smtp.passwd"
    port <- C.require cfg "smtp.port"
    return $ SMTPInfo host port from user pass
