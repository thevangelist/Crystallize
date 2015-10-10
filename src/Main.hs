{-# LANGUAGE OverloadedStrings #-}
module Main where
import Formalize.Server
import Formalize.Config

main :: IO ()
main = readConfig "app.conf" >>= runServer
