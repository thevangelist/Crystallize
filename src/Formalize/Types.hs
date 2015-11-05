{-# LANGUAGE DeriveDataTypeable #-}
module Formalize.Types where

import           Data.ByteString (ByteString)
import           Data.Data
import           Data.Text       (Text)

type PDF = ByteString

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
    , fiNextSession        :: Text
    } deriving (Data, Typeable)

data FlashMessage = FlashMessage
    { fmContent :: Text
    } deriving (Data, Typeable)

data FormData = FormData
    { fdFormInput      :: FormInput
    , fdMessage        :: FlashMessage
    , fdFileTimestamp  :: FilePath
    , fdHumanTimestamp :: Text
    } deriving (Data, Typeable)

data SMTPInfo = SMTPInfo
    { iSMTPHost   :: Text
    , iSMTPPort   :: Int
    , iSMTPFrom   :: Text
    , iSMTPUser   :: Text
    , iSMTPPAsswd :: Text
    }
