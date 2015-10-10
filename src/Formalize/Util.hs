module Formalize.Util
    ( savePDF
    ) where

import Data.ByteString (ByteString)
import Data.Time.Clock
import Data.Time.Format
import System.FilePath
import qualified Data.ByteString as BS

-- Create timestamp for filename.
timestamp :: IO FilePath
timestamp = do
    let format = "%Y%m%d-%H:%M:%S"
    now <- getCurrentTime
    return (formatTime defaultTimeLocale format now)

-- Generate filename.
filename :: FilePath -> FilePath -> FilePath
filename path ts = path </> ts <.> "pdf"

-- Save PDF file to path.
savePDF :: FilePath -> ByteString -> IO ()
savePDF path file = do
    ts <- timestamp
    BS.writeFile (filename path ts) file
