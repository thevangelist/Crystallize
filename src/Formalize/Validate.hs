{-# LANGUAGE OverloadedStrings #-}
-- TODO: clean up the validation.
module Formalize.Validate
    ( formFromParams
    ) where

import           Data.Map        (Map)
import qualified Data.Map        as M
import           Data.Maybe
import           Data.Text       (Text)
import qualified Data.Text       as T
import           Formalize.Types

type Params = Map Text Text

-- Try to create form from params list.
formFromParams :: [(Text,Text)] -> Either (FormInput,Text) FormInput
formFromParams ps =
    let params     = filterForm "crystal" ps
        mValueList = mValues params
    in if (==) 22 . length $ catMaybes mValueList
        then Right (goodForm params)
        else Left (errorForm params)


-- Filter only wanted form params.
filterForm :: Text -> [(Text,Text)] -> Params
filterForm prefix =
    let f       = T.isPrefixOf (T.append prefix "[") . fst
        parse   = T.takeWhile (/= ']') . T.drop 1 . T.dropWhile (/= '[')
        g (k,v) = (parse k, v)
    in M.fromList . map g . filter f

-- Create form with error message.
errorForm :: Params -> (FormInput,Text)
errorForm ps =
    let errorMsg     = "Syötit virheellistä tietoa, ole hyvä ja korjaa lomake."
        filledParams = M.union ps defaultParams
    in (goodForm filledParams, errorMsg)

-- Create form from valid params map.
goodForm :: Params -> FormInput
goodForm ps =
    FormInput (ps M.! "company")
              (ps M.! "email")
              (greenCards ps)
              (redCards ps)
              (ps M.! "topaasia_green")
              (ps M.! "topaasia_red")
              (ps M.! "improvement_green")
              (ps M.! "improvement_red")
              (ps M.! "lead_green")
              (ps M.! "lead_red")
              (ps M.! "last_used")
              (ps M.! "rating")

-- Return list of maybe values from params.
mValues :: Params -> [Maybe Text]
mValues ps = map (`M.lookup` ps) defaults

defaultParams :: Params
defaultParams = M.fromList $ zip defaults (repeat "")

greenCards :: Params -> Text
greenCards ps =
    let cards = map (\ k -> ps M.! k) greens
    in T.intercalate ", " $ filter (/= "") cards

redCards :: Params -> Text
redCards ps =
    let cards = map (\ k -> ps M.! k) reds
    in T.intercalate ", " $ filter (/= "") cards

defaults :: [Text]
defaults =
    [ "company"
    , "email"
    , "topaasia_green"
    , "topaasia_red"
    , "improvement_green"
    , "improvement_red"
    , "lead_green"
    , "lead_red"
    , "last_used"
    , "rating"
    ]
    ++ reds
    ++ greens

reds :: [Text]
reds =
    [ "category_cards_red_1"
    , "category_cards_red_2"
    , "category_cards_red_3"
    , "category_cards_red_4"
    , "category_cards_red_5"
    , "category_cards_red_6"
    ]

greens :: [Text]
greens =
    [ "category_cards_green_1"
    , "category_cards_green_2"
    , "category_cards_green_3"
    , "category_cards_green_4"
    , "category_cards_green_5"
    , "category_cards_green_6"
    ]
