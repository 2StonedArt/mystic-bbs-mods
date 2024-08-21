# RCS_TriviaPost

TriviaPost will pick a random trivia question from the trivia.txt file, and generate a 'report' text file that can be posted anywhere you'd like. 

Each question in the trivia.txt file also contains the answer and a follow-up explanation. These lines start with an '*', and are not displayed in the report file. I do have another program that uses this information.

This program also keeps two separate log files of questions that have been asked. One is used to check if the random question has already been posted, and the other is used by a secondary program to generate the results at the end of the month.

The format of the trivia.txt file is pretty straight-forward. Each entry looks like:

1.
This is the question that will be asked.
It can be as many lines as needed (at least in this program)

a. Answer 1
b. Answer 2
c. Answer 3
d. Answer 4

* And the final answer is... R! Just kidding. 
* Any line that starts with the * will not be displayed
* There can be as many of these lines as needed

2.
The program will read the file until the next question number is encountered.
