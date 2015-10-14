{-# LANGUAGE OverloadedStrings #-}
module Formalize.Actions
    ( home
    , submit
    , notFound
    ) where

import           Control.Monad.IO.Class    (MonadIO, liftIO)
import           Data.Text                 (Text)
import           Data.Text.IO              as IO
import           Data.Text.Lazy            as LT (toStrict)
import           Formalize.Html
import           Formalize.Types
import           Formalize.Util
import           Formalize.Validate
import           Network.HTTP.Types.Status (status404)
import           Web.Spock

emptyForm :: FormInput
emptyForm = FormInput "" "" "" "" "" "" "" "" "" "" "" ""

emptyFlash :: FlashMessage
emptyFlash = FlashMessage ""

-- Handle successful submit.
submitSuccess :: FormInput -> FormalizeAction ctx a
submitSuccess formInput = do
    formData <- liftIO $ createFormData formInput emptyFlash
    path <- fmap sPath getState
    pdf <- liftIO $ saveAsPdf formData path
    setHeader "Content-Type" "application/pdf"
    bytes pdf

-- Handle failed submit.
submitFailure :: Text -> FormalizeAction ctx a
submitFailure errorTxt = renderHome emptyForm (FlashMessage errorTxt) >>= html

-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = fmap formFromParams params >>= either submitFailure submitSuccess

-- Render form.
renderHome :: MonadIO m => FormInput -> FlashMessage -> m Text
renderHome formInput msg = do
    formData <- liftIO $ createFormData formInput msg
    fmap LT.toStrict $ liftIO $ formHtml formData

home :: FormalizeAction ctx a
home = renderHome emptyForm emptyFlash >>= html

-- Render custom 404 page.
notFound :: [Text] -> FormalizeAction ctx a
notFound _ = do
    setStatus status404
    liftIO (IO.readFile "web/static/404.html") >>= html
