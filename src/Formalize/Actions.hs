{-# LANGUAGE OverloadedStrings #-}
module Formalize.Actions
    ( home
    , submit
    ) where

import Control.Monad.IO.Class (liftIO)
import Data.Text.Lazy as LT
import Formalize.Html
import Formalize.Types
import Formalize.Pdf
import Formalize.Util
import Formalize.Validate
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
submitFailure = home $ Just $ FlashMessage txt
    where txt = "Syötit virheellistä tietoa, ole hyvä ja korjaa lomake."

-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = fmap formFromParams params >>= maybe submitFailure submitSuccess

-- Render form.
home :: Maybe FlashMessage -> FormalizeAction ctx a
home msg = fmap LT.toStrict (liftIO $ formHtml msg) >>= html
