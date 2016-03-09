{-# LANGUAGE OverloadedStrings #-}
-- TODO: clean up the validation.
module Formalize.Internal.Validate
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
        len        = length defaults
    in if (==) len . length $ catMaybes mValueList
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
    FormInput (ps M.! "identifier")
              (ps M.! "email")
              (ps M.! "strongest")
              (ps M.! "strongest_num")
              (ps M.! "weakest")
              (ps M.! "weakest_num")
              (ps M.! "important")
              (ps M.! "important_num")
              (ps M.! "hardest")
              (ps M.! "hardest_num")
              (ps M.! "tedious")
              (ps M.! "tedious_num")
              (ps M.! "inspiring")
              (ps M.! "inspiring_num")
              (ps M.! "topaasia")
              (ps M.! "openQuestion")
              (ps M.! "benefitNum")
              (ps M.! "rating")

-- Return list of maybe values from params.
mValues :: Params -> [Maybe Text]
mValues ps = map (`M.lookup` ps) defaults

defaultParams :: Params
defaultParams = M.fromList $ zip defaults (repeat "")

defaults :: [Text]
defaults =
    [ "identifier"
    , "email"
    , "strongest"
    , "strongest_num"
    , "weakest"
    , "weakest_num"
    , "important"
    , "important_num"
    , "hardest"
    , "hardest_num"
    , "tedious"
    , "tedious_num"
    , "inspiring"
    , "inspiring_num"
    , "topaasia"
    , "openQuestion"
    , "rating"
    ]
