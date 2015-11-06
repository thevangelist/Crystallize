{-# LANGUAGE OverloadedStrings #-}
module Formalize.Internal.Mailer
    ( emailPDF
    ) where

import           Control.Monad        (when)
import qualified Data.ByteString.Lazy as LB
import           Data.Text            (Text)
import qualified Data.Text            as T
import qualified Data.Text.Lazy       as LT
import           Network.Mail.Mime    hiding (simpleMail)
import           Network.Mail.SMTP

import           Formalize.Types

-- Email PDF file to user using SMTP configurations. Return the given PDF.
emailPDF :: SMTPInfo -> Text -> PDF -> IO PDF
emailPDF smtp toEmail pdf = do
    let subject = "Kiteyttäjä"
        text    = plainTextPart emailMessage
        from    = Address Nothing (iSMTPFrom smtp)
        to      = [Address Nothing toEmail]
        file    = pdfPart pdf
        mail    = simpleMail from to [] [] subject [file, text]
    when (hostExists smtp) $ sendEmail smtp mail
    return pdf

-- Create PDF file attachment.
pdfPart :: PDF -> Part
pdfPart pdf =
    Part
        "application/pdf"
        Base64
        (Just "Kiteyttaja.pdf")
        []
        (LB.fromStrict pdf)

-- Content of the email.
emailMessage :: LT.Text
emailMessage = "Tässä luomasi PDF.\n\nt: kiteyttäjä"

-- Send email using given STMP configuration.
sendEmail :: SMTPInfo -> Mail -> IO ()
sendEmail smtp =
    sendMailWithLogin'
        (T.unpack     $ iSMTPHost smtp)
        (fromIntegral $ iSMTPPort smtp)
        (T.unpack     $ iSMTPUser smtp)
        (T.unpack     $ iSMTPPAsswd smtp)

-- Check that host exists in STMP configuration. (Testing uses host = "")
hostExists :: SMTPInfo -> Bool
hostExists smtp = T.length (iSMTPHost smtp) > 0
