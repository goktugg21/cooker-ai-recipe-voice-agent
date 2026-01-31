%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Responses when a flag has been set for a button.					%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Responses when a flag has been set for a button.					%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% responses for NEW dialog agent 		   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flagResponse('mic', 'Please press Start first') :- flag('mic'), waitingForEvent('start').
flagResponse('mic', 'I am already listening') :-
	flag('mic'), listening.
% We might have just stopped listening but still waiting for results from intention
% detection; so case above does not apply but we still need user to be patient. Order of
% these rules therefore is also important.
%flagResponse('mic', 'Wait a second') :-
%	flag('mic'), waitingForEvent('IntentDetectionDone'). % WAIT A SECOND BUG
flagResponse('mic', "Please, I'm talking") :-
	flag('mic'), talking.
flagResponse('mic', 'Not available right now') :- flag('mic'), not(waitingForEvent(_)).
% In all other cases, flags generate an 'empty' response.
flagResponse(_, '').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Text generator that generates something to say from scripted text and phrases for 	%%%
%%% intents that the agent will generate (use).						%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * text(+Intent:atom, -Txt:string)
 *
 * Generates a string expression for an agent intent label.
 *
 * @Intent	Intent label.
 * @Txt		Textual response for agent to perform intent.
**/

/**
 * text(+PatternID:atom, +Intent:atom, -Txt:string)
 *
 * Generates a string expression for an agent intent in the context of an active pattern.
 *
 * @PatternID	A pattern identifier, must be at top level (see generator below).
 * @Intent	Intent label.
 * @Txt		Textual response for agent to perform intent.
**/
:- dynamic text/2, text/3.

% Text generator that takes dialog context into account.
% We use top level dialog context, e.g.:
% - greeting (c10)
% - recipe selection (a50recipeSelect)
% - recipe choice confirmation (a50recipeConfirm)
% - closing (c40)
text_generator(Intent, SelectedText) :-
	currentTopLevel(PatternId),
	findall(Text, text(PatternId, Intent, Text), Texts),
	random_select(SelectedText, Texts, _).

% Text generator that does not take dialog context into account.
text_generator(Intent, SelectedText) :-
	findall(Text, text(Intent, Text), Texts), random_select(SelectedText, Texts, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scripted text and phrases for ** GENERIC ** intents (sorted on intent name)		%%%
%%% Text is only provided for those intents that the agent will generate (use). 	%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intent: appreciationReceipt
text(appreciationReceipt, "You're welcome!").

% Intent: contextMismatch(Intent)
text(contextMismatch(_), "I'm not sure what that means in this context.").

% Intent: describeCapability
text(describeCapability, "I can help you find recipes based on ingredients, cuisine type, cooking time, and dietary preferences.").

% Intent: farewell
text(farewell, "Goodbye! Enjoy your meal!").

% Intent: greeting
text(greeting, "Hey there!").

% Intent: paraphraseRequest
text(paraphraseRequest, "I'm sorry, I didn't understand that. Could you please rephrase?").

% Intent: selfIdentification (for self-identification of the agent)
text(selfIdentification, Txt) :-
    agentName(Name),
    string_concat("My name is ", Name, Txt).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scripted text and phrases for ** DOMAIN SPECIFIC ** intents (sorted on intent name)	%%%
%%% Text is only provided for those intents that the agent will generate (use). 	%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intent: ackFilter (acknowledge filters added; there are recipes that satisfy all filters)
text(ackFilter, "Got it! I have added that to your preferences.").

% Intent: featureInquiry
text(featureInquiry, "What kind of recipe are you looking for?").

% Intent: featureRemovalRequest
text(featureRemovalRequest, "Okay, I have removed that from your preferences.").

% Intent: noRecipesLeft
text(noRecipesLeft, "Sorry, no recipes match your criteria. Try removing some filters.").

% Intent: pictureGranted
text(pictureGranted, "Here's a picture of the recipe.").

% Intent: pictureNotGranted
text(pictureNotGranted, "Sorry, I don't have a picture for this recipe.").

% Intent: recipeChoiceReceipt (acknowledge user's choice of recipe)
text(recipeChoiceReceipt, "Great choice! Enjoy cooking!").

% Intent: recommend (a recipe)
text(recommend, Txt) :-
    (   recipesFiltered(Recipes),
        Recipes = [RecipeID|_],
        recipeName(RecipeID, Name),
        format(atom(Txt), "How about trying ~w?", [Name])
    ->  true
    ;   Txt = "Sorry, I could not find any recipes matching your preferences."
    ).

% Intent: recipeCheck
text(recipeCheck, "Would you like to try this recipe?").

% Intent: showRecipes
text(showRecipes, "Here are some recipes you might like.").

% Intent: tooManyRecipes
text(tooManyRecipes, "There are still too many recipes. Please add more preferences.").

% Intent: specifyGoal (asking a user about recipe features they are looking for)
text(specifyGoal, "What would you like to cook today?").

% Intent: restartAck
text(restartAck, "Okay, let's start over. All filters have been cleared.").

% Intent: stopAck  
text(stopAck, "Okay, stopping the conversation.").

% Intent: clearMemory
text(clearMemory, "All filters have been cleared.").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Additional response variety                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Greeting variations
text(greeting, "Hello! Welcome!").
text(greeting, "Hi! Nice to see you!").
text(greeting, "Hey! Ready to cook something delicious?").

% Farewell variations
text(farewell, "Bye! Happy cooking!").
text(farewell, "See you next time! Bon appetit!").
text(farewell, "Take care! Enjoy your food!").

% ackFilter variations
text(ackFilter, "Perfect! I've noted that down.").
text(ackFilter, "Alright, added to your filters!").
text(ackFilter, "Sure thing! Filter applied.").

% featureInquiry variations
text(featureInquiry, "What would you like to cook today?").
text(featureInquiry, "Any preferences for your recipe?").
text(featureInquiry, "Tell me what you're in the mood for!").

% recipeCheck variations
text(recipeCheck, "How does this recipe sound?").
text(recipeCheck, "Is this recipe what you were looking for?").
text(recipeCheck, "Would you like to go with this one?").

% paraphraseRequest variations
text(paraphraseRequest, "Could you say that differently?").
text(paraphraseRequest, "I didn't quite catch that. Can you try again?").

% appreciationReceipt variations
text(appreciationReceipt, "My pleasure!").
text(appreciationReceipt, "Happy to help!").
text(appreciationReceipt, "Anytime!").

% noRecipesLeft variations
text(noRecipesLeft, "No recipes found with those filters. Maybe try fewer restrictions?").
text(noRecipesLeft, "I couldn't find any matching recipes. Want to remove a filter?").

% tooManyRecipes variations
text(tooManyRecipes, "We have lots of options! Can you narrow it down a bit?").
text(tooManyRecipes, "Too many choices! Tell me more about what you want.").

% recipeChoiceReceipt variations
text(recipeChoiceReceipt, "Excellent pick! Have fun in the kitchen!").
text(recipeChoiceReceipt, "Nice! That's a delicious recipe!").

% showRecipes variations
text(showRecipes, "Check out these recipe options!").
text(showRecipes, "I found these recipes for you!").

% clearMemory variations
text(clearMemory, "Starting fresh! All preferences removed.").
text(clearMemory, "Filters reset. Let's start over!").