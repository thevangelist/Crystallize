module Formalize.ValidateSpec
    ( main
    , spec
    ) where

import Test.Hspec

main = hspec spec

spec =
    context "Exanmple" $
        it "true is allways true" $
            True `shouldBe` True
