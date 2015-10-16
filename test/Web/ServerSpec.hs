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
    it "responds 400 with incorrect params" $
      postHtmlForm "/submit" [("test","")] `shouldRespondWith` 400
    it "responds 200 with correct params" $
      postHtmlForm "/submit" validParams `shouldRespondWith` 200


app = spockAsApp $ spock spockCfg formalizerApp
  where
    state    = AppState "test-files"
    spockCfg = defaultSpockCfg Nothing PCNoDatabase state

validParams =
    [ ("crystal[company]","")
    , ("crystal[email]","")
    , ("crystal[topaasia_green]","")
    , ("crystal[topaasia_red]","")
    , ("crystal[improvement_green]","")
    , ("crystal[improvement_red]","")
    , ("crystal[lead_green]","")
    , ("crystal[lead_red]","")
    , ("crystal[last_used]","")
    , ("crystal[rating]","")
    , ("crystal[category_cards_red_1]","")
    , ("crystal[category_cards_red_2]","")
    , ("crystal[category_cards_red_3]","")
    , ("crystal[category_cards_red_4]","")
    , ("crystal[category_cards_red_5]","")
    , ("crystal[category_cards_red_6]","")
    , ("crystal[category_cards_green_1]","")
    , ("crystal[category_cards_green_2]","")
    , ("crystal[category_cards_green_3]","")
    , ("crystal[category_cards_green_4]","")
    , ("crystal[category_cards_green_5]","")
    , ("crystal[category_cards_green_6]","")
    ]
