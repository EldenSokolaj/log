# log
A simple POSIX logger written in haskell

Uses

    write ***
      - writes whatever message follows into the log file along with timestamp
    
    read (optional n)
      - read 'n' entries from the log file in reverse chronological order (if n is not given, reads all entries)
    
    clear
      - clears the log file
    
    help
      - provides some information

Notes
    
    The log file is located at /home/$USER/.log_command_entries.log
    
    If the $USER environment variable is not set, a rather poorly formated error message is given
