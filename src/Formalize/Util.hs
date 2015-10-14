module Formalize.Util
    ( saveAsPdf
    , createFormData
    ) where

import           Data.ByteString     (ByteString)
import qualified Data.ByteString     as BS
import qualified Data.Text           as T
import           Data.Time.Format
import           Data.Time.LocalTime
import           Formalize.Pdf
import           Formalize.Types
import           System.FilePath

-- Create timestamp for filename.
timestamp :: IO FilePath
timestamp = do
    let format = "%Y%m%d-%H:%M:%S"
    now <- getZonedTime
    return (formatTime defaultTimeLocale format now)

-- Generate filename.
filename :: FilePath -> FilePath -> FilePath
filename path ts = path </> ts <.> "pdf"

-- Save form data as PDF.
saveAsPdf :: FormData -> FilePath -> IO PDF
saveAsPdf fd path = do
    let ts = T.unpack $ fdTimestamp fd
    file <- createPDF fd
    BS.writeFile (filename path ts) file
    return file

-- Construct form data from input, flash message and timestamp.
createFormData :: FormInput -> FlashMessage -> IO FormData
createFormData fi fm = do
    time <- fmap T.pack timestamp
    return $ FormData fi fm time
