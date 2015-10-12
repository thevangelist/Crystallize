{-# LANGUAGE OverloadedStrings #-}
module Formalize.Html
    ( formHtml
    , pdfHtml
    ) where

import Control.Monad.IO.Class (MonadIO)
import Data.Text.Lazy (Text)
import Formalize.Types
import System.FilePath
import Text.Hastache
import Text.Hastache.Context
import qualified Data.Text as T

-- Location of view files.
viewFolder :: FilePath
viewFolder = "web/view"

-- Render mustache template.
mustache :: MonadIO m => FilePath -> MuContext m -> m Text
mustache file context = hastacheFile defaultConfig path context
    where path = viewFolder </> file

-- Empty context for 'static' views.
nullContext :: MonadIO m => MuContext m
nullContext = mkStrContext $ const $ MuVariable ("" :: T.Text)

-- HTML for view containing the main form.
formHtml :: IO Text
formHtml = mustache "form.mustache" nullContext

-- HTML for the PDF to render.
pdfHtml :: FormData -> IO Text
pdfHtml = mustache "pdf.mustache" . mkGenericContext
