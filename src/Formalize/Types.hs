{-# LANGUAGE DeriveDataTypeable #-}
module Formalize.Types where

import           Data.ByteString (ByteString)
import           Data.Data
import           Data.Text       (Text)

type PDF = ByteString

data FormInput = FormInput
    { fiIdentifier   :: Text
    , fiEmail        :: Text
    , fiStrongest    :: Text
    , fiStrongestNum :: Int
    , fiWeakest      :: Text
    , fiWeakestNum   :: Int
    , fiImportant    :: Text
    , fiImportantNum :: Int
    , fiHardest      :: Text
    , fiHardestNum   :: Int
    , fiTedious      :: Text
    , fiTediousNum   :: Int
    , fiInspiring    :: Text
    , fiInspiringNum :: Int
    , fiTopaasia     :: Text
    , fiOpenQuestion :: Text
    , fiRating       :: Int
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
