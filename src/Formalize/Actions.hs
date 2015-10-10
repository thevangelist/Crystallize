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
import Web.Spock

-- TODO: Find better way for parsing params.
--       Also handle validation failures.
-- Parse params and return PDF.
submit :: FormalizeAction ctx a
submit = do
    p0  <- param' "crystal[company]"
    p1  <- param' "crystal[email]"
    p2  <- param' "crystal[category_cards_green]"
    p3  <- param' "crystal[category_cards_red]"
    p4  <- param' "crystal[topaasia_green]"
    p5  <- param' "crystal[topaasia_red]"
    p6  <- param' "crystal[improvement_green]"
    p7  <- param' "crystal[improvement_red]"
    p8  <- param' "crystal[lead_green]"
    p9  <- param' "crystal[lead_red]"
    p10 <- param' "crystal[last_used]"
    p11 <- param' "crystal[rating]"
    let formData = FormData p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
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
