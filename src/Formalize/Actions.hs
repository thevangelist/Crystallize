{-# LANGUAGE OverloadedStrings #-}
module Formalize.Actions
    ( home
    , submit
    , notFound
    ) where

import Control.Monad.IO.Class (liftIO)
import Data.Text.IO as IO
import Data.Text (Text)
import qualified Data.Text.Lazy as LT
import Formalize.Html
import Formalize.Types
import Formalize.Pdf
import Formalize.Util
import Formalize.Validate
import Network.HTTP.Types.Status (status404)
import Web.Spock

-- Handle successful submit.
submitSuccess :: FormData -> FormalizeAction ctx a
submitSuccess formData = do
    pdf <- liftIO $ createPDF formData
    path <- fmap sPath getState
    liftIO $ savePDF path pdf
    setHeader "Content-Type" "application/pdf"
    bytes pdf

-- Handle failed submit.
submitFailure :: FormalizeAction ctx a
submitFailure = redirect "/"

-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = fmap formFromParams params >>= maybe submitFailure submitSuccess

-- Render form.
home :: FormalizeAction ctx a
home = fmap LT.toStrict (liftIO formHtml) >>= html

-- Render custom 404 page.
notFound :: [Text] -> FormalizeAction ctx a
notFound _ = do
    setStatus status404
    liftIO (IO.readFile "web/static/404.html") >>= html
