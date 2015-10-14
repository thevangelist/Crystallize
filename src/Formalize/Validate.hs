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

-- Filter only wanted form params.
filterForm :: Text -> [(Text,Text)] -> Params
filterForm prefix =
    let f       = T.isPrefixOf (T.append prefix "[") . fst
        parse   = T.takeWhile (/= ']') . T.drop 1 . T.dropWhile (/= '[')
        g (k,v) = (parse k, v)
    in M.fromList . map g . filter f

-- Return list of maybe values from params.
mValues :: Params -> [Maybe Text]
mValues params =
    [ M.lookup "company" params
    , M.lookup "email" params
    , M.lookup "category_cards_green_1" params
    , M.lookup "category_cards_green_2" params
    , M.lookup "category_cards_green_3" params
    , M.lookup "category_cards_green_4" params
    , M.lookup "category_cards_green_5" params
    , M.lookup "category_cards_green_6" params
    , M.lookup "category_cards_red_1" params
    , M.lookup "category_cards_red_2" params
    , M.lookup "category_cards_red_3" params
    , M.lookup "category_cards_red_4" params
    , M.lookup "category_cards_red_5" params
    , M.lookup "category_cards_red_6" params
    , M.lookup "topaasia_green" params
    , M.lookup "topaasia_red" params
    , M.lookup "improvement_green" params
    , M.lookup "improvement_red" params
    , M.lookup "lead_green" params
    , M.lookup "lead_red" params
    , M.lookup "last_used" params
    , M.lookup "rating" params
    ]

greenCards :: Params -> Text
greenCards ps =
    let cards = [ ps M.! "category_cards_green_1"
                , ps M.! "category_cards_green_2"
                , ps M.! "category_cards_green_3"
                , ps M.! "category_cards_green_4"
                , ps M.! "category_cards_green_5"
                , ps M.! "category_cards_green_6"
                ]
    in T.intercalate ", " $ filter (/= "") cards

redCards :: Params -> Text
redCards ps =
    let cards = [ ps M.! "category_cards_red_1"
                , ps M.! "category_cards_red_2"
                , ps M.! "category_cards_red_3"
                , ps M.! "category_cards_red_4"
                , ps M.! "category_cards_red_5"
                , ps M.! "category_cards_red_6"
                ]
    in T.intercalate ", " $ filter (/= "") cards

-- Create form from valid params map.
createForm :: Params -> FormInput
createForm ps =
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

-- Try to create form from params list.
formFromParams :: [(Text,Text)] -> Either Text FormInput
formFromParams ps =
    let params     = filterForm "crystal" ps
        mValueList = mValues params
        valid      = (==) 22 . length $ catMaybes mValueList
        errorMsg   = "Syötit virheellistä tietoa, ole hyvä ja korjaa lomake."
        in if valid then Right (createForm params) else Left errorMsg
