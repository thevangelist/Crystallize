{-# LANGUAGE OverloadedStrings #-}
module Formalize.Actions
    ( home
    , submit
    ) where

import Control.Monad.IO.Class (liftIO)
import Data.String.Conversions as C
import Formalize.Html
import Formalize.Types
import Formalize.Pdf
import Formalize.Util
import Formalize.Validate
import Web.Spock

-- TODO: Extract logic out of Action.
-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = do
    ps <- params
    case formFromParams ps of
     -- TODO: Show error message to user on redirect.
      Nothing         -> redirect "/"
      Just (formData) -> do
          pdf <- liftIO (createPDF formData)
          state <- getState
          liftIO (savePDF (sPath state) pdf)
          setHeader "Content-Type" "application/pdf"
          bytes pdf

-- Render form.
home :: FormalizeAction ctx a
home = do
    x <- liftIO formHtml
    html $ C.cs x
