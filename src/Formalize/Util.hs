module Formalize.Util
    ( savePDF
    , createFormData
    ) where

import           Data.ByteString     (ByteString)
import qualified Data.ByteString     as BS
import qualified Data.Text           as T
import           Data.Time.Format
import           Data.Time.LocalTime
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

-- Save PDF file to path.
savePDF :: FilePath -> ByteString -> FormData -> IO ()
savePDF path file fd = BS.writeFile (filename path ts) file
    where ts = T.unpack $ fdTimestamp fd

-- Construct form data from input, flash message and timestamp.
createFormData :: FormInput -> FlashMessage -> IO FormData
createFormData fi fm = do
    time <- fmap T.pack timestamp
    return $ FormData fi fm time
