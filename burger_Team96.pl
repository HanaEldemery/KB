:- include('KB1.pl').

% True if Ingredient has been stacked in Situation S
% stacked/2
% stacked(Ingredient, Situation)
% Ingredient: The ingredient we're checking (bottom_bun, patty, ...)
% Situation: The situation we're checking in (s0 or result(Action, S))
stacked(_, s0) :- fail.

stacked(X, result(A, S)) :-
    A = stack(X);
    stacked(X, S).

% Tracks the position(index) of each ingredient in the stack
% position/3
% position(Ingredient, Position, Situation)
% Ingredient: The ingredient whose position we're tracking
% Position: The number representing height (0 is the bottom)
% Situation: The situation we're checking in
position(_, _, s0) :- fail.

position(X, Pos, result(A, S)) :-
    A = stack(Y),
    X = Y,
    stack_height(S, Pos).

position(X, Pos, result(A, S)) :-
    A = stack(Y),
    X \= Y,
    position(X, Pos, S).

% Counts how many ingredients have been stacked (burger height)
% stack_height/2
% stack_height(Situation, Height)
% Situation: The situation to check
% Height: The number of stacked ingredients
stack_height(S, Height) :-
    findall(I, stacked(I, S), List),
    length(List, Height).

% Checks if we can legally stack an ingredient in the current situation
% can_stack/2
% can_stack(Ingredient, Situation)
% Ingredient: The ingredient we want to stack
% Situation: The current situation
can_stack(Ingredient, S) :-
    % Check if Ingredient is valid
    member(Ingredient, [bottom_bun, patty, lettuce, cheese, pickles, tomato, top_bun]),
    
    % Check if Ingredient is already stacked
    \+ stacked(Ingredient, S), %makes sure ingredient is not already stacked (\+ is a not)
    
    % bottom_bun must be first (height = 0)
    (Ingredient = bottom_bun -> stack_height(S, 0); true),
    
    % top_bun must be last (all other ingredients are stacked)
    (Ingredient = top_bun -> 
        (stacked(bottom_bun, S),
         stacked(patty, S),
         stacked(lettuce, S),
         stacked(cheese, S),
         stacked(pickles, S),
         stacked(tomato, S))
    ; true),
    
    % If Ingredient is not bottom_bun, then bottom_bun must already be stacked
    (Ingredient \= bottom_bun -> stacked(bottom_bun, S); true),
    
    % If X must be above Ingredient, then Ingredient can only be stacked if X is not stacked
    \+ (above(X, Ingredient), stacked(X, S)), %makes sure something that is above the ingredient im holding is not already stacked
     
    % If Ingredient must be above Y, then all Ys must already be stacked
    forall(above(Ingredient, Y), stacked(Y, S)). %makes sure that everything below the ingredient im holding is already stacked

% Generates or verifies a complete valid burger situation
% burgerReady/1
% burgerReady(Situation)
% Situation: The situation representing the burger
burgerReady(S) :-
    build_burger([bottom_bun, lettuce, patty, cheese, pickles, tomato, top_bun], s0, S). % s0 is the burger so far, starts off empty

% Recursively builds the burger by stacking ingredients
% build_burger/3
% build_burger(RemainingIngredients, CurrentSituation, TargetSituation)
% RemainingIngredients: List of ingredients still to be stacked
% CurrentSituation: The situation built so far
% TargetSituation: The final complete situation
build_burger([], S, S). % if the current situation (previously s0) is equal to the target situation (previously S) and there are no ingredients left -> return true (if it returns false, then this statement is incorrect (invalid burger))

build_burger(Remaining, CurrentS, TargetS) :-
    select(Ingredient, Remaining, Rest), % pick an Ingredient from Remaining (select takes the 1st ingredient from the array of ingredients (bottom_bun is ingredient and rest is remaining after removing bottom_bun from remaining)
    can_stack(Ingredient, CurrentS), % check if we can legally stack Ingredient
    NewS = result(stack(Ingredient), CurrentS), % stack Ingredient
    build_burger(Rest, NewS, TargetS). % continue with remaining ingredients

% Iterative Deepening Search - find a valid burger using IDS
% ids_burgerReady/1
% ids_burgerReady(Situation)
% Situation: The complete burger situation
ids_burgerReady(S) :-
    ids_helper(S, 20). % DepthLimit = 20

% ids_helper(Situation, DepthLimit)
ids_helper(S, Limit) :-
    call_with_depth_limit(burgerReady(S), Limit, Result),
    (   number(Result) ->  true ; % Found solution within limit
        Result = depth_limit_exceeded,  % Hit limit -> extend limit
        NewLimit is Limit + 10,
        ids_helper(S, NewLimit)
    ).