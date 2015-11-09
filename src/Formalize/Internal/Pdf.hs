module Formalize.Internal.Pdf
    ( createPDF
    ) where

import qualified Data.ByteString   as BS
import qualified Data.Text.Lazy    as LT
import qualified Data.Text.Lazy.IO as IO
import           Formalize.Html
import           Formalize.Types
import           System.IO         (Handle, hClose)
import           System.IO.Temp
import           System.Process

-- Create PDF file from form data.
createPDF :: FormData -> IO PDF
createPDF fd = pdfHtml fd >>= html2PDF


-- Options for wkhtmltopdf tool.
pdfOptions :: [String]
pdfOptions = [ "--quiet"
             , "--user-style-sheet", "web/static/pdf.css"
             , "-T", "0mm"
             , "-R", "0mm"
             , "-B", "0mm"
             , "-L", "0mm"
             ]

-- Use wkhtmltopdf tool for converting HTML to PDF.
html2PDF :: LT.Text -> IO PDF
html2PDF html = withSystemTempFile "output.pdf" (html2PDF' html)
  where
    html2PDF' :: LT.Text -> FilePath -> Handle -> IO PDF
    html2PDF' html' tempPDFFile tempPDFHandle = do
      hClose tempPDFHandle
      withSystemTempFile "input.html" $ \tempHtmlFile tempHtmlHandle -> do
        IO.hPutStrLn tempHtmlHandle html'
        hClose tempHtmlHandle
        (_,_,_, pHandle) <- createProcess (proc "wkhtmltopdf" $
            pdfOptions ++ [tempHtmlFile, tempPDFFile])
        _ <- waitForProcess pHandle
        BS.readFile tempPDFFile
