# Sudoku Solver Application using Flutter
 
## Introduction
Sudoku is a logic-based puzzle where the user is given a 9 x 9 grid, which consists of nine 3 x 3 sub-grids, and the objective of the puzzle is to fill these sub-grids with numbers from 1 to 9 such that no two numbers appear in the same row, same column and the same sub-grid of the 9 x 9 grid. Initially, the grid is partially filled with digits in specific locations to make sure the puzzle is well-posed and has a single solution.
This is a very popular puzzle that has been featured in newspapers since the 19th century, the first being featured in a French newspaper. The puzzle can range in difficulty from easy to hard and is also quite addictive. There are many people who start off their typical day by reading the newspaper in the morning and solving puzzles like Sudoku. The Sudoku solver application aids the users to obtain a solution of a sudoku puzzle by providing an incomplete sudoku puzzle as the input.
The further sections will cover the functionality and the working of the Sudoku solver application.

## Functionality of the Application
The Sudoku solver application takes the incomplete Sudoku as the input and, if valid, solves the Sudoku and displays it; otherwise displays the error message indicating invalid input. \
The application enables the user to provide input in two ways:
- __Camera/Photo upload:__ User has the option to click or the upload the photo of the sudoku as the input
- __Manual input:__ User needs to manually enter the numbers in the corresponding boxes as the input.
If the given input is solvable or valid and the application solves and displays the complete sudoku. Otherwise it will give out a message indicating that the sudoku was invalid i.e there was no solution possible in such a way that it follows all the rules of a classic sudoku puzzle.


## Working of the Application
The basic user interface of the application was developed using Flutter, which is a software development kit created by Google and uses the Dart programming language to develop applications. 
This app consists of 2 tabs and the user between these tabs (by default the first tab remains activated) by clicking the respective button in the bottom navigation bar. The two tabs are: 
1. __Scan/Upload tab:__ \
This tab enables the user to provide an input via an image. They need to click the camera icon to take a photo and click the image icon to upload a photo. Once the required photo is clicked or uploaded, they are given an option to crop the image and they must crop out only the sudoku puzzle out of that image(Important). The cropped out sudoku puzzle is then displayed on the screen. This feature of providing an image as the input by taking a picture or uploading an image and then cropping out the image was made possible by using the __document_scanner_flutter 0.2.5__ dart package. 
The user must click the ‘OK’ button below the displayed image to start the text scanning process. For this functionality __google_ml_vision 0.0.7__ dart package was used which returned all the scanned text and its corresponding bounding box (coordinates of the box around the text in pixels) from the image. With this, their respective index is calculated and filled in the 9 x 9 matrix. After the scanning process the application directs the user to the second tab. 
2. __Fill tab:__ \
This tab initially displays an empty sudoku i.e 9 x 9 boxes or cells with no values. The user has the option to enter a value in the cell by clicking the particular cell (which highlights the cell) and then clicking the button with their required number. There are also options to clear a selected cell or reset the whole sudoku.
Note: Changes in the sudoku cause the corresponding changes in the 9 x 9 matrix that was initially declared as a zero 9 x 9 matrix (where 0 indicates no value at that particular position). 
If the user has given the input through 1st Tab, they are directed to the second tab and the corresponding changes in the 9 x 9 matrix is reflected in the displayed sudoku. The user can make some changes to make sure it matches the input sudoku in case of some errors.
Note: The result from scanning isn’t always accurate and might miss some numbers or display wrong numbers in the wrong position.
Finally the user must click the submit button which sends the 9 x 9 matrix to a function to implement the sudoku solving algorithm. \
__Sudoku solving algorithm:__ \ 
First, it checks whether in a cell there is a value or not. If there is no value, then one by one, by putting all values from 1 to 9, it checks which value is correct.
It assumes that there is 1 in that cell and checks the condition of sudoku. If it satisfies, then it calls the main function again with an updated matrix, and if the function returns true, then we return true otherwise, backtrack and put value 2 in the cell, and so on, and if all the values are false, then we return false.
The final output will depend on the return statement where true will display the matrix in the form of sudoku and false will display a message indicating invalid input.

## Dart packages used in the application:
- [google_ml_vision(v0.0.7)](https://pub.dev/packages/google_ml_vision)
- [document_scanner_flutter(v0.2.5)](https://pub.dev/packages/document_scanner)


