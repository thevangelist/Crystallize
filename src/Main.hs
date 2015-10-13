{-# LANGUAGE OverloadedStrings #-}
module Main where
import           Formalize.Config
import           Formalize.Server

main :: IO ()
main = readConfig "app.conf" >>= runServer
