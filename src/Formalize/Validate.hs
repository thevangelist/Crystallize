{-# LANGUAGE OverloadedStrings #-}
module Formalize.Validate
    ( formFromParams
    ) where

import Data.Text (Text)
import Data.Map  (Map)
import Data.Maybe
import Formalize.Types
import qualified Data.Text as T
import qualified Data.Map  as M

type Params = Map Text Text

-- Filter only wanted form params.
filterForm :: Text -> [(Text,Text)] -> Params
filterForm prefix =
    let f     = T.isPrefixOf (T.append prefix "[") . fst
        parse = T.takeWhile (/= ']') . T.drop 1 . T.dropWhile (/= '[')
        g     = \ (k,v) -> (parse k, v)
    in M.fromList . map g . filter f

-- Return list of maybe values from params.
mValues :: Params -> [Maybe Text]
mValues params =
    [ M.lookup "company" params
    , M.lookup "email" params
    , M.lookup "category_cards_green" params
    , M.lookup "category_cards_red" params
    , M.lookup "topaasia_green" params
    , M.lookup "topaasia_red" params
    , M.lookup "improvement_green" params
    , M.lookup "improvement_red" params
    , M.lookup "lead_green" params
    , M.lookup "lead_red" params
    , M.lookup "last_used" params
    , M.lookup "rating" params
    ]

-- Create form from valid params map.
createForm :: Params -> FormData
createForm ps =
    FormData (ps M.! "company")
             (ps M.! "email")
             (ps M.! "category_cards_green")
             (ps M.! "category_cards_red")
             (ps M.! "topaasia_green")
             (ps M.! "topaasia_red")
             (ps M.! "improvement_green")
             (ps M.! "improvement_red")
             (ps M.! "lead_green")
             (ps M.! "lead_red")
             (ps M.! "last_used")
             (ps M.! "rating")

-- Try to create form from params list.
formFromParams :: [(Text,Text)] -> Maybe FormData
formFromParams ps =
    let params     = filterForm "crystal" ps
        mValueList = mValues $ params
        valid      = (==) 12 . length $ catMaybes mValueList
    in if valid then Just (createForm params) else Nothing
