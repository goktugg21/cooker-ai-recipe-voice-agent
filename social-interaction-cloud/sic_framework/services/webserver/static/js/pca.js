/** 
 * Javascript code for the Project Conversational Agents course.
 * 
 * This code makes some basic assumptions about the interaction protocol:
 * - User always is the first to say something (by turning on the microphone)
 * - The microphone automatically is closed again when a transcript has been received (the user has said something)
 * - After receiving a transcript, the turn is given to the agent and the user cannot turn on the microphone.
 * - When the agent has said something, the turn is handed back to the user.
 * 
 * This code also makes assumptions about the names of two buttons: the 'start' and 'mic'(rophone) button.
 * Button clicks are passed on to the webserver, which passes them on to the MARBEL agent using an EIS connector.
 * 
 * Finally, on pages where there is a microphone, a footer should be present with a <p> element with id="transcript".
 * This element will be used to display the transcript received from the ASR component.
 * 
 * SocketIO is used to communicate with the server.
*/

"use strict";

// Establish a WebSocket connection with the Flask server
var socket = io();

// Flag to keep track of whose turn it is (true --> user, false --> agent)
// Initially, it is the agent's turn; DO NOT CHANGE here, this flag is set by EISComponent in SIC framework
var user_turn = false;

// Variable to keep track of number of recipes that fullfill criteria
var recipecounter = -1;

// Code for handling button elements on page
var elements = document.getElementsByClassName("btn");

// Send button clicks to server
var sendButtonClick = function() {
    var name = this.getAttribute("id");
    socket.emit('buttonClick', name); // send button name to web server
};

for (var i = 0; i < elements.length; i++) {
    elements[i].addEventListener('click', sendButtonClick, false);
}

// Dedicated event listeners for two SPECIAL BUTTONS: the 'mic' button.
// Event listener for the mic button to toggle from off to on
// - We need to check if button is available on the webpage, as this may not be the case, e.g. not on start webpage.
// - The socket handler for 'transcript' event turns it off again, see below.
var micButton = document.getElementById('mic');

if (micButton) {
    micButton.addEventListener('click', function() {
        if (user_turn) {
            document.getElementById('micimg').src  = 'static/images/mic_on.png';
        } else {
            alert("It is not your turn.")
        }
    });
}

// Event handler for successful connection
socket.on('connect', function() {
    console.log('Connected to the server.');
});

// Event handler for connection errors
socket.on('connect_error', function(error) {
    console.log('Connection error:', error);
});

// Event handler for disconnection
socket.on('disconnect', function() {
    console.log('Disconnected from the server.');
});

// Event handler for transcript event
socket.on("transcript", (text) => {
    document.getElementById("transcript").innerHTML = text;
});

// Event handler for page navigation based on pattern
socket.on("pattern", (pattern) => {
    switch(pattern) {
        case "start":
            window.location.href = "start.html";
            break;
        case "c10":
            window.location.href = "welcome.html";
            break;
        case "a50recipeSelect":
            window.location.href = "recipe_overview.html";
            break;
        case "a50recipeConfirm":
            window.location.href = "recipe_confirmation.html";
            break;
        case "c43":
            window.location.href = "closing.html";
            break;
        default:
            // Don't navigate for unknown patterns
            console.log("Unknown pattern: " + pattern);
      }
})

// Event handler for switching turns
socket.on("set_turn", (whoseturn) => {
    if (whoseturn=="true") {
        user_turn = true;
    } else {
        user_turn = false;
    }
    // If it's not the user's turn (any more), then make sure the microphone icon is mic_out
    if (!user_turn) {
        var micImg = document.getElementById('micimg');
        if (micImg) {
            micImg.src = 'static/images/mic_out.png';
        }
    }
})

// Event handler for recipe counter
socket.on("recipecounter", (number) => {
    recipecounter = number;
    var counterElement = document.getElementById("recipecounter");
    if (counterElement) {
        counterElement.innerHTML = recipecounter;
    }
})

// Event handler for filters display
socket.on("filters", (filterString) => {
    const filtersString = filterString.substring(1, filterString.length-1);
    var filtersContainer = document.getElementById("addFiltersHere");
    if (filtersContainer && filterString.length != 0) {
        const filters = filtersString.split(',');
        filtersContainer.innerHTML = "";
        filters.forEach((element) => {
            filterCard(element);
        });
    }
})

// Event handler for displaying a single recipe (for confirmation page)
socket.on("recipe", (recipeData) => {
    // recipeData should be an object with: name, image, cuisine, time, servings, ingredients
    var nameElement = document.getElementById("recipeName");
    var imageElement = document.getElementById("recipeImage");
    var cuisineElement = document.getElementById("recipeCuisine");
    var timeElement = document.getElementById("recipeTime");
    var servingsElement = document.getElementById("recipeServings");
    var ingredientsElement = document.getElementById("recipeIngredients");
    
    if (nameElement) nameElement.innerHTML = recipeData.name || "Unknown Recipe";
    if (imageElement && recipeData.image) imageElement.src = recipeData.image;
    if (cuisineElement) cuisineElement.innerHTML = recipeData.cuisine || "-";
    if (timeElement) timeElement.innerHTML = recipeData.time || "-";
    if (servingsElement) servingsElement.innerHTML = recipeData.servings || "-";
    
    if (ingredientsElement && recipeData.ingredients) {
        ingredientsElement.innerHTML = "";
        recipeData.ingredients.forEach((ing) => {
            var badge = document.createElement("span");
            badge.className = "badge bg-success m-1";
            badge.innerHTML = ing;
            ingredientsElement.appendChild(badge);
        });
    }
})

// Event handler for displaying recipe list
socket.on("recipeList", (recipes) => {
    var listContainer = document.getElementById("recipeList");
    var template = document.getElementById("recipeCardTemplate");
    
    if (listContainer && template && recipes) {
        listContainer.innerHTML = "";
        recipes.forEach((recipe) => {
            const card = template.content.cloneNode(true);
            var nameEl = card.querySelector('#cardRecipeName');
            var infoEl = card.querySelector('#cardRecipeInfo');
            var imgEl = card.querySelector('img');
            
            if (nameEl) nameEl.innerHTML = recipe.name;
            if (infoEl) infoEl.innerHTML = (recipe.time || "?") + " min • " + (recipe.servings || "?") + " servings";
            if (imgEl && recipe.image) imgEl.src = recipe.image;
            
            listContainer.appendChild(card);
        });
    }
})

// Create and add a single card for a filter based on the template in the HTML file
// See also https://www.w3schools.com/tags/tag_template.asp
function filterCard(filter) {
    let filterTemplate = document.querySelector('#filterCardTemplate');
    if (filterTemplate) {
        const card = filterTemplate.content.cloneNode(true);
        card.querySelector('#filterText').innerHTML = filter;
        document.getElementById("addFiltersHere").appendChild(card);
    }
}

// event handler for displaying selected recipe name
socket.on("recipename", (name) => {
    var nameElement = document.getElementById("recipeName");
    if (nameElement) {
        nameElement.innerHTML = name;
    }
    console.log("Selected recipe: " + name);
})

// event handler for recipe image
socket.on("recipeimage", (image) => {
    var imageElement = document.getElementById("recipeImage");
    if (imageElement && image) {
        imageElement.src = image;
    }
});

// event handler for recipe time
socket.on("recipetime", (time) => {
    var timeElement = document.getElementById("recipeTime");
    if (timeElement) {
        timeElement.innerHTML = time;
    }
});

// event handler for recipe servings
socket.on("recipeservings", (servings) => {
    var servingsElement = document.getElementById("recipeServings");
    if (servingsElement) {
        servingsElement.innerHTML = servings;
    }
});

// event handler for recipe cuisine
socket.on("recipecuisine", (cuisine) => {
    var cuisineElement = document.getElementById("recipeCuisine");
    if (cuisineElement) {
        cuisineElement.innerHTML = cuisine;
    }
});