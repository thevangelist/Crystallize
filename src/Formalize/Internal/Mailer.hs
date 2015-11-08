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

-- Content of the email.
emailMessage :: LT.Text
emailMessage =
    "Moi!\n\
    \ \n\
    \Toivottavasti pelihetki oli antoisa - tässä Kiteyttäjä. Huomaat Kiteyttäjän visuaalisen kauneusleikkauksen etenemisen tässä matkan varrella.\n\
    \ \n\
    \Me uskomme palautteen voimaan. Haasta meidät palautteella niin tulet huomaamaan kehityksen seuraavaan pelisessioon mennessä.\n\
    \ \n\
    \Risut, ruusut ja pajut voi ohjata esimerkiksi johonkin seuraavista:\n\
    \ \n\
    \galla@galliwashere.com\n\
    \0400246626\n\
    \@jussigalla\n\
    \ \n\
    \innolla,\n\
    \gällit\n\
    \ \n\
    \Play. Focus. Do. Repeat\n"
