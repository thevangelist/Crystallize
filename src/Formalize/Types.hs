{-# LANGUAGE DeriveDataTypeable #-}
module Formalize.Types where

import Data.Data
import Data.Text (Text)
import Data.ByteString (ByteString)
import Web.Spock.Safe

type PDF = ByteString
type SessionVal = Maybe SessionId
type FormalizeApp ctx = SpockCtxM ctx () SessionVal AppState ()
type FormalizeAction ctx a = SpockActionCtx ctx () SessionVal AppState a

data AppConfig = AppConfig
    { cPort :: Int
    , cPath :: FilePath
    }

data AppState = AppState
    { sPath :: FilePath
    }

data FormData = FormData
    { _company              :: Text
    , _email                :: Text
    , _category_cards_green :: Text
    , _category_cards_red   :: Text
    , _topaasia_green       :: Text
    , _topaasia_red         :: Text
    , _improvement_green    :: Text
    , _improvement_red      :: Text
    , _lead_green           :: Text
    , _lead_red             :: Text
    , _last_used            :: Text
    , _rating               :: Text
    } deriving (Data, Typeable)
