:- ensure_loaded(library(clpfd)).
% this program is to solve the puzzle problem by listing to all the requirements
% of this puzzle,and then to get the answer. To aciheve this it needs all the
% functions are backtrackable，for example,instead of using 'is' we should use
% #= ,and so on.So we divided the requirements of the puzzles in to 6 parts as
% follow.
puzzle_solution(Puzzle):-
  check_diagonal(Puzzle),
  check_number(Puzzle),
  check_row(Puzzle),
  check_col(Puzzle),
  distinct_row(Puzzle),
  distinct_col(Puzzle),
  maplist(label,Puzzle).
% To get the puzzle without first row and column form the origin one.
get_subpuzzle([_|A],Subpuzzle):-
  transpose(A,[_|B]),
  transpose(B,Subpuzzle).
% To supply the function "get_diagonal" for the recursion to get the element.
extract_element(L, L1, [H|L1]):-
                length(L1, N1),
                length(L2, N1),
                append(L2, [H|_], L).
% To get the element on the diagonal.
get_diagonal(In, Out):-
                foldl(extract_element, In, [], Res),
                reverse(Res,Out).
% To check if all the element of the list is the same,,if it is return true.
allsame([]).
allsame([_]).
allsame([X,X|T]) :- allsame([X|T]).
% To check the diagonal elements of puzzle that without first row and column,
% if they are same.
check_diagonal(Puzzle):-
  get_subpuzzle(Puzzle,Subpuzzle),
  get_diagonal(Subpuzzle,Diagonal),
  allsame(Diagonal).
% To check if all the elements in the puzzle that without first row and column
% satisfy the requirement of being from 1 to 9.
check_number(Puzzle):-
  get_subpuzzle(Puzzle,Subpuzzle),
  flatten(Subpuzzle,List_of_SubPuz),
  List_of_SubPuz ins 1..9.
% Function to get the multiply product of a list,input is the list as first
% parameter and the output is the number as the second parameter.
multiply([], 1).
multiply([X|Y],Z) :-
  multiply(Y, Q),
  Z#=X*Q.
  % Function to get the sum of a list,input is the list as first
  % parameter and the output is the number as the second parameter.
sum([], 0).
sum([X|Y],Z) :-
  sum(Y, Q),
    Z#=X+Q.
% To get the first element of the list.
head([Head|_],Head).
% To get the rest of elements o.
tail([_|Tail],Tail).
% Input is one row of list，to check one row if the first number
% equal to all the sum or multiply product of the rest of the
% list, if it is return true.
add_or_mult(Row):-
  head(Row,Head),
  tail(Row,Tail),
  sum(Tail,SumofRow),
  multiply(Tail,ProductofRow),
  ((Head#=SumofRow);(Head#=ProductofRow)).
% Check all row except the first row to see if they are satisfy
% the requirement of first element equals to the sum or product
% of all of the rest elements.
check_row(Puzzle):-
  tail(Puzzle,Tail),
  maplist(add_or_mult(),Tail).
% Same as check_row, except transpose the Puzzle,that all the
% rows become columns.
check_col(Puzzle):-
  transpose(Puzzle,Tra_Puzzle),
  tail(Tra_Puzzle,Tail_Tra_Puzzle),
  maplist(add_or_mult(),Tail_Tra_Puzzle).
% Function to see if all the rows except the first hold the
% elements all different from each others.
distinct_row(Puzzle):-
  get_subpuzzle(Puzzle,Subpuzzle),
  maplist(all_distinct(),Subpuzzle).
% Same as 'distinct_row' except that using transpose to
% translate all the rows to columns
distinct_col(Puzzle):-
  transpose(Puzzle,Tra_Puzzle),
  get_subpuzzle(Tra_Puzzle,Sub_Tra_Puzzle),
  maplist(all_distinct(),Sub_Tra_Puzzle).
