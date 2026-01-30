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