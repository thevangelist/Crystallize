{-# LANGUAGE OverloadedStrings #-}
module Formalize.Actions
    ( home
    , submit
    ) where

import Control.Monad.IO.Class (liftIO, MonadIO)
import Data.Text (Text)
import Data.Text.Lazy as LT (toStrict)
import Formalize.Html
import Formalize.Types
import Formalize.Pdf
import Formalize.Util
import Formalize.Validate
import Web.Spock

emptyForm :: FormInput
emptyForm = FormInput "" "" "" "" "" "" "" "" "" "" "" ""

emptyFlash :: FlashMessage
emptyFlash = FlashMessage ""

-- Handle successful submit.
submitSuccess :: FormInput -> FormalizeAction ctx a
submitSuccess formInput = do
    let formData = FormData formInput emptyFlash
    pdf <- liftIO $ createPDF formData
    path <- fmap sPath getState
    liftIO $ savePDF path pdf
    setHeader "Content-Type" "application/pdf"
    bytes pdf

-- Handle failed submit.
submitFailure :: FormalizeAction ctx a
submitFailure = renderHome emptyForm msg >>= html
    where msg = FlashMessage "Syötit virheellistä tietoa, ole hyvä ja korjaa lomake."

-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = fmap formFromParams params >>= maybe submitFailure submitSuccess

-- Render form.
renderHome :: MonadIO m => FormInput -> FlashMessage -> m Text
renderHome formInput msg = fmap LT.toStrict (liftIO $ formHtml formData)
    where formData = FormData formInput msg

home :: FormalizeAction ctx a
home = renderHome emptyForm emptyFlash >>= html
