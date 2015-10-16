{-# LANGUAGE OverloadedStrings #-}
module Formalize.Formalizer
        ( pdfFromParams
        , emptyFormData
        ) where

import           Data.Text          (Text)
import           Formalize.Types
import           Formalize.Internal.Util
import           Formalize.Internal.Validate

-- TODO: Simplify Left Right handling.
-- Try to create PDF file from params.
pdfFromParams :: [(Text,Text)] -> FilePath -> IO (Either FormData PDF)
pdfFromParams ps path =
    case formFromParams ps of
         Left x  -> do fd <- invalidInput x
                       return $ Left fd
         Right x -> do pdf <- validInput path x
                       return $ Right pdf

-- Empty data is used when rendering the form first time.
emptyFormData :: IO FormData
emptyFormData = createEmptyFormData


-- Create form data containing error message.
invalidInput :: (FormInput,Text) -> IO FormData
invalidInput (fi,msg) = createFormData fi $ FlashMessage msg

-- Create and save pdf.
validInput :: FilePath -> FormInput -> IO PDF
validInput path fi = do
    formData <- createFormData fi emptyFlash
    saveAsPdf formData path
