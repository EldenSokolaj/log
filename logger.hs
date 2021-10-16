import System.IO
import System.Environment
import Data.List
import Text.Printf
import System.Directory
import Control.Exception
import System.IO.Error
import Data.Time

help :: IO ()
help = do
        putStrLn "Logger - write / read / clear user logs\nCommands:\n\tread - optional number of entries to read\n\twrite [followed by text to write]\n\tclear - removes all entries\n\thelp - displays this menu\nBug fix: Ensure that the environment variable USER is set, else an 'ugly' error will be thrown"

writeLog :: [Char] -> [Char] -> IO ()
writeLog logfile text = do
                now <- getCurrentTime
                let timestamp = formatTime defaultTimeLocale "[%a %B %d %Y]" now
                appendFile logfile $ timestamp ++ " " ++ text ++ "\n"

removeIfExists :: FilePath -> IO ()
removeIfExists fileName = removeFile fileName `catch` handleExists
    where handleExists e
            | isDoesNotExistError e = return ()
            | otherwise = throwIO e

getFileContentOrElse :: String -> FilePath -> IO String
getFileContentOrElse def filePath = readFile filePath `catch` \e -> const (return def) (e :: IOException)

main = do
    name <- getEnv "USER"
    let logfile = "/home/" ++ name ++ "/.log_command_entries.log"
    args <- getArgs
    if length args == 0 || args !! 0 == "help" then
        help
    else if args !! 0 == "read" then do
        contents <- getFileContentOrElse "You have no logs to read\n" logfile
        putStr (if length args == 1 then contents else unlines (reverse (take (read (args !! 1)) ((reverse . lines) contents))) )
    else if args !! 0 == "write" then do
        writeLog logfile $ intercalate " " $ tail args
    else if args !! 0 == "clear" then do
        removeIfExists logfile
        putStrLn "Cleared log"
    else
        printf "[%s] is an invalid command, use 'help' for more information\n" $ args !! 0
