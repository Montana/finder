module Main where

import System.IO
import Data.List
import Control.Exception

data Task = Task {
  description :: String,
  completed :: Bool
} deriving (Read, Show)

addTask :: [Task] -> String -> [Task]
addTask tasks desc = tasks ++ [Task desc False]

completeTask :: [Task] -> Int -> [Task]
completeTask tasks index =
  let (left, (t: right)) = splitAt index tasks
  in left ++ (t { completed = True } : right)

saveTasks :: FilePath -> [Task] -> IO ()
saveTasks filepath tasks = bracketOnError (openFile filepath WriteMode) hClose (\h -> do
    hPutStr h (show tasks)
    hClose h)

loadTasks :: FilePath -> IO [Task]
loadTasks filepath = do
  content <- readFile filepath
  return $ read content

printTasks :: [Task] -> IO ()
printTasks tasks = do
  let tasksStr = unlines $ zipWith (\i task -> show i ++ ". " ++ description task ++ if completed task then " (completed)" else "") [0..] tasks
  putStr tasksStr

main :: IO ()
main = do
  let filepath = "tasks.txt"
  tasks <- loadTasks filepath `catch` \e -> do
    let err = show (e :: IOException)
    putStrLn ("Warning: Could not load tasks - " ++ err)
    return []
  loop filepath tasks
  where
    loop :: FilePath -> [Task] -> IO ()
    loop filepath tasks = do
      putStrLn "\nAvailable commands:"
      putStrLn "a - Add a task"
      putStrLn "v - View tasks"
      putStrLn "c - Complete a task"
      putStrLn "q - Quit"
      putStr "Enter command: "
      hFlush stdout
      command <- getLine
      case command of
        "a" -> do
          putStr "Enter task description: "
          desc <- getLine
          let newTasks = addTask tasks desc
          saveTasks filepath newTasks
          loop filepath newTasks
        "v" -> do
          printTasks tasks
          loop filepath tasks
        "c" -> do
          putStr "Enter task index to complete: "
          indexStr <- getLine
          let index = read indexStr
          let newTasks = completeTask tasks index
          saveTasks filepath newTasks
          loop filepath newTasks
        "q" -> putStrLn "Exiting..."
        _   -> do
          putStrLn "Command not recognized."
          loop filepath tasks
