module Web.Types where

import           Web.Spock.Safe

import           Formalize.Types

type SessionVal = Maybe SessionId
type FormalizeApp ctx = SpockCtxM ctx () SessionVal AppState ()
type FormalizeAction ctx a = SpockActionCtx ctx () SessionVal AppState a

data AppConfig = AppConfig
    { cPort :: Int
    , cPath :: FilePath
    , cSMTP :: SMTPInfo
    }

data AppState = AppState
    { sPath :: FilePath
    , sSMTP :: SMTPInfo
    }
