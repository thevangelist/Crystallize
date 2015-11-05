module Web.Types where

import           Data.Text               (Text)
import           Web.Spock.Safe

import           Formalize.Types

type SessionVal = Maybe SessionId
type FormalizeApp ctx = SpockCtxM ctx () SessionVal AppState ()
type FormalizeAction ctx a = SpockActionCtx ctx () SessionVal AppState a

data AppConfig = AppConfig
    { cPort       :: Int
    , cPath       :: FilePath
    , cSMTPHost   :: Text
    , cSMTPPort   :: Int
    , cSMTPFrom   :: Text
    , cSMTPUser   :: Text
    , cSMTPPAsswd :: Text
    }

data AppState = AppState
    { sPath :: FilePath
    , sSMTP :: SMTPInfo
    }
