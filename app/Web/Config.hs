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
    host <- C.require cfg "SMTPHost"
    from <- C.require cfg "SMTPFrom"
    user <- C.require cfg "SMTPUser"
    pass <- C.require cfg "SMTPPasswd"
    smtpPort <- C.require cfg "SMTPPort"
    return (AppConfig port path host smtpPort from user pass)
