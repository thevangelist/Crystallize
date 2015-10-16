{-# LANGUAGE OverloadedStrings #-}
module Web.ServerSpec
    ( main
    , spec
    ) where

import           Data.ByteString.Lazy as BS
import           Test.Hspec
import           Test.Hspec.Wai
import           Web.Server
import           Web.Spock.Safe       hiding (get, post)
import           Web.Spock.Shared
import           Web.Types

main :: IO ()
main = hspec spec

spec :: Spec
spec = with app $ do
  describe "GET /" $ do
    it "responds with 200" $ do
      get "/" `shouldRespondWith` 200

  describe "GET invalid route" $ do
    it "renders custom 404 page with code 404" $ do
      content <- liftIO $ BS.readFile "web/static/404.html"
      let matcher = ResponseMatcher 404 [] $ Just content
      get "/nonexistingroute" `shouldRespondWith` matcher

  describe "POST /submit" $ do
    it "responds 200" $
      post "/submit" "test" `shouldRespondWith` 200


app = spockAsApp $ spock spockCfg formalizerApp
  where
    state    = AppState "test-files"
    spockCfg = defaultSpockCfg Nothing PCNoDatabase state
