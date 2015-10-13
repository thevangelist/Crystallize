{-# LANGUAGE DeriveDataTypeable #-}
module Formalize.Types where

import           Data.ByteString (ByteString)
import           Data.Data
import           Data.Text       (Text)
import           Web.Spock.Safe

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

data FormInput = FormInput
    { fiCompany            :: Text
    , fiEmail              :: Text
    , fiCategoryCardsGreen :: Text
    , fiCategoryCardsRed   :: Text
    , fiTopaasiaGreen      :: Text
    , fiTopaasiaRed        :: Text
    , fiImprovementGreen   :: Text
    , fiImprovementRed     :: Text
    , fiLeadGreen          :: Text
    , fiLeadRed            :: Text
    , fiLastUsed           :: Text
    , fiRating             :: Text
    } deriving (Data, Typeable)

data FlashMessage = FlashMessage
    { fmContent :: Text
    } deriving (Data, Typeable)

data FormData = FormData
    { fdFormInput :: FormInput
    , fdMessage   :: FlashMessage
    } deriving (Data, Typeable)

