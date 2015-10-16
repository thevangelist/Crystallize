{-# LANGUAGE OverloadedStrings #-}
module Web.Actions
    ( home
    , submit
    , notFound
    ) where

import           Control.Monad.IO.Class    (MonadIO, liftIO)
import           Data.Text                 (Text)
import           Data.Text.IO              as IO
import           Data.Text.Lazy            as LT (toStrict)
import           Formalize.Formalizer
import           Formalize.Html
import           Formalize.Types
import           Network.HTTP.Types.Status (status404)
import           Web.Spock
import           Web.Types

-- Render home page.
home :: FormalizeAction ctx a
home = html =<< renderHome =<< liftIO emptyFormData

-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = do
    ps     <- params
    path   <- fmap sPath getState
    result <- liftIO $ pdfFromParams ps path
    either submitFailure submitSuccess result

-- Render custom 404 page.
notFound :: [Text] -> FormalizeAction ctx a
notFound _ = do
    setStatus status404
    html =<< liftIO (IO.readFile "web/static/404.html")


-- Render form.
renderHome :: MonadIO m => FormData -> m Text
renderHome = fmap LT.toStrict . liftIO . formHtml

-- Handle successful submit.
submitSuccess :: PDF -> FormalizeAction ctx a
submitSuccess pdf = do
    setHeader "Content-Type" "application/pdf"
    bytes pdf

-- Handle failed submit.
submitFailure :: FormData -> FormalizeAction ctx a
submitFailure fd = html =<< renderHome fd
