{-# LANGUAGE OverloadedStrings #-}
module Formalize.Html
    ( formHtml
    , pdfHtml
    ) where

import Control.Monad.IO.Class (MonadIO)
import Data.Text.Lazy (Text)
import Formalize.Types
import Text.Hastache
import Text.Hastache.Context
import qualified Data.Text as T

-- Render mustache template.
mustache :: MonadIO m => FilePath -> MuContext m -> m Text
mustache path context = hastacheFile defaultConfig path context

-- Empty context for 'static' views.
nullContext :: MonadIO m => MuContext m
nullContext = mkStrContext $ const $ MuVariable ("" :: T.Text)

-- HTML for view containing the main form.
formHtml :: IO Text
formHtml = mustache "web/view/form.mustache" nullContext

-- HTML for the PDF to render.
pdfHtml :: FormData -> IO Text
pdfHtml = mustache "web/view/pdf.mustache" . mkGenericContext
