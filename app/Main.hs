{-# LANGUAGE OverloadedStrings #-}
module Main where
import           Web.Config
import           Web.Server

main :: IO ()
main = readConfig "app.cfg" >>= runServer
