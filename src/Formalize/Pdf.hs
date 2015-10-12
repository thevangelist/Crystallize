module Formalize.Pdf
    ( createPDF
    ) where

import Data.String.Conversions as C
import Formalize.Html
import Formalize.Types
import System.Process
import System.IO.Temp
import System.IO as IO
import qualified Data.ByteString as BS

-- Create PDF file from form data.
createPDF :: FormData -> IO PDF
createPDF fd = do
    htmlText <- pdfHtml fd
    html2PDF $ C.cs htmlText

-- Options for wkhtmltopdf tool.
pdfOptions :: [String]
pdfOptions = ["--quiet", "--user-style-sheet", "web/static/pdf.css"]

-- TODO: dont use string?
-- Use wkhtmltopdf tool for converting HTML to PDF.
html2PDF :: String -> IO PDF
html2PDF html = withSystemTempFile "output.pdf" (html2PDF' html)
  where
    html2PDF' :: String -> FilePath -> Handle -> IO PDF
    html2PDF' html' tempPDFFile tempPDFHandle = do
      hClose tempPDFHandle
      withSystemTempFile "input.html" $ \tempHtmlFile tempHtmlHandle -> do
        IO.hPutStrLn tempHtmlHandle html'
        hClose tempHtmlHandle
        (_,_,_, pHandle) <- createProcess (proc "wkhtmltopdf" $
            pdfOptions ++ [tempHtmlFile, tempPDFFile])
        _ <- waitForProcess pHandle
        BS.readFile tempPDFFile
