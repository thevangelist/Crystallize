module Formalize.Formalizer
        ( pdfFromParams
        , emptyFormData
        ) where

import           Data.Text                   (Text)

import           Formalize.Internal.Util
import           Formalize.Internal.Validate
import           Formalize.Internal.Mailer
import           Formalize.Types

-- TODO: Simplify Left Right handling.
-- Try to create PDF file from params.
pdfFromParams
    :: [(Text,Text)]
    -> FilePath
    -> SMTPInfo
    -> IO (Either FormData PDF)
pdfFromParams ps path smtp =
    case formFromParams ps of
         Left x  -> do fd <- invalidInput x
                       return $ Left fd
         Right x -> do pdf <- validInput path x smtp
                       return $ Right pdf

-- Empty data is used when rendering the form first time.
emptyFormData :: IO FormData
emptyFormData = createEmptyFormData


-- Create form data containing error message.
invalidInput :: (FormInput,Text) -> IO FormData
invalidInput (fi,msg) = createFormData fi $ FlashMessage msg

-- Create, save and email pdf.
validInput :: FilePath -> FormInput -> SMTPInfo -> IO PDF
validInput path fi smtp = do
    let email = fiEmail fi
    formData <- createFormData fi emptyFlash
    saveAsPdf formData path >>= emailPDF smtp email
