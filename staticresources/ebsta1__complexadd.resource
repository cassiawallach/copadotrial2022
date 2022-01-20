var global_ComplexAddObject = new ComplexAddObject();

function AttachListenerToAttachmentIcon(attachmentIcon, attachmentId, attachmentName){
	if(attachmentIcon != null){
		attachmentIcon.addEventListener("click", function(){
			global_ComplexAddObject.CreateOrShowComplexAddPopUp(attachmentId, attachmentName);
		});
	}
}

//Default method to create a DOM element
function CreateElement(elementType, className, text, id){
    var element = document.createElement(elementType);
    
    if (className) {
        element.setAttribute("class", className);
    }
    
    if (text) {
        element.innerText = text;
    }
    
    if (id) {
        element.setAttribute("id", id);
    }

    return element;
}

//Custom function to support Jquery Closest in pure JS
function ClosestElement(element, fn) {
    return element && (
        fn(element) ? element : ClosestElement(element.parentNode, fn)
    );
}

//Custom function to support JQuery Empty in pure JS
function EmptyElement(element){
	while(element.firstChild){
	    element.removeChild(element.firstChild);
	}
}

//Creates a bootstrap row to help conform with boostrap standards
function CreateBootstrapRow(){
	return CreateElement("div", "row", null, null);
}

//Adds a class to an element using javascript
function AddClass(classToAdd, elementToAddTo){
	if(elementToAddTo != null){
		if(elementToAddTo.classList != null){
			elementToAddTo.classList.add(classToAdd);
		}
	}
}	

//Removes a class to an element using javascript
function RemoveClass(classToRemove, elementToAddTo){
	if(elementToAddTo != null){
		if(elementToAddTo.classList != null){
			elementToAddTo.classList.remove(classToRemove);
		}
	}
}

//Closure object for the Complex Add Screen
function ComplexAddObject() {
	var mainPopUpElement = null; //Main complex add pop up screen
	var complexAddRowContainer = null; // Container div which contains all the complex add rows
	var recommendedSuggestionsContainer = null; //Bottom container which currently just holds the save button
	var whoSearchPlaceholder = "Search Name"; //Placeholder text for inputs on who side
	var whatSearchPlaceholder = "Search Related To"; //Placeholder text for inputs on what side
	var enterKeyCode = 13; //Key code for enter to detect enter presses on searches
	var globalContext = this; //Keep track of the object context as when delving into other contexts we lose this state
	var attachmentId = null; // Id for attachment this is screen is for
	var responseOverlay = null; // The response message we'll display when you try to add attachments
	var titleElement = null;
	
	return {
		SetContext : function(){
			globalContext = this;
		},
		CreateOrShowComplexAddPopUp : function(newAttachmentId, fileName){
			attachmentId = newAttachmentId;
			this.SetContext();
			if(mainPopUpElement != null){
				this.ShowComplexAddPopUp(fileName);
			} else {
				mainPopUpElement = CreateElement("div", null, null, "ebsta-complex-add");
				document.body.appendChild(mainPopUpElement);
				this.RenderDefaultLayout(fileName);
			}
		},
		HideComplexAddPopUp : function(){
			if(mainPopUpElement != null){
				mainPopUpElement.style.display = "none";
			}
		},
		ShowComplexAddPopUp: function(fileName){
			if(mainPopUpElement != null){
				mainPopUpElement.style.display = "block";
				titleElement.innerText = "Add Attachment - " + fileName;
			}
		},
		RenderDefaultLayout : function(fileName){
			var topRow = CreateBootstrapRow();
			titleElement = CreateElement("h3", "pull-left truncate", "Add Attachment - " + fileName, null);
			topRow.appendChild(titleElement);
			mainPopUpElement.appendChild(topRow);
			
			var closeIcon = CreateElement("span", "ebsta-complex-add-removeicon pull-right", null, null);
			$this = this;
			closeIcon.addEventListener("click", function () { $this.HideComplexAddPopUp(); } );
			topRow.appendChild(closeIcon);
			
			complexAddRowContainer = CreateBootstrapRow();
			AddClass("ebsta-complex-add-row-container", complexAddRowContainer);
			complexAddRowContainer.appendChild(this.CreateComplexAddRow(mainSalesforceId, currentObjectCompanyName));
			complexAddRowContainer.appendChild(this.CreateComplexAddRow(null, null));
			mainPopUpElement.appendChild(complexAddRowContainer);
			
			recommendedSuggestionsContainer = CreateBootstrapRow();
			recommendedSuggestionsContainer.appendChild(this.AddSaveButton());
			mainPopUpElement.appendChild(recommendedSuggestionsContainer);
		},
		//Creates a new Complex Add row
		CreateComplexAddRow : function(salesforceId, salesforceName){
			var mainRowDiv = CreateElement("div", "row ebsta-complex-add-row", null, null);
			
			var arrowColumn = CreateElement("div", null, null, null);
			var arrowDown = CreateElement("span", "ebsta-complex-add-chevron-right", null, null);
			arrowColumn.appendChild(arrowDown);
			mainRowDiv.appendChild(arrowColumn);
			
			var whoObjectSegment = CreateElement("div", "ebsta-complex-add-segment", null, null); 
			whoObjectSegment.setAttribute('objecttype', 'who');
			var whatObjectSegment = CreateElement("div", "ebsta-complex-add-segment", null, null); 
			whatObjectSegment.setAttribute('objecttype', 'what');
			
			var whoObjectContainer = CreateElement("div", "ebsta-complex-add-container", null, null); 
			var whatObjectContainer = CreateElement("div", "ebsta-complex-add-container", null, null); 
			
			var whoSearchContainer = this.CreateSearchContainer(whoSearchPlaceholder);
			var whatSearchContainer = this.CreateSearchContainer(whatSearchPlaceholder);
					
			if((salesforceId != null && salesforceName != null)){
				var removeIcon = this.GetAddOrRemoveIcon(false, true);
				
				var selectedRecordDiv = this.CreateSelectedRecordDiv(salesforceName, salesforceId);
				selectedRecordDiv.appendChild(removeIcon);
				
				whoObjectContainer.appendChild(whoSearchContainer);
				whatObjectContainer.appendChild(whatSearchContainer);
				
				if(this.IsRecordAWho(salesforceId)){
					whoSearchContainer.style.display = "none";
					whoObjectContainer.appendChild(selectedRecordDiv);
					this.RemoveIconListener(removeIcon, selectedRecordDiv, whoSearchContainer, salesforceName, salesforceId);
				} else {
					whatSearchContainer.style.display = "none";
					whatObjectContainer.appendChild(selectedRecordDiv);
					this.RemoveIconListener(removeIcon, selectedRecordDiv, whatSearchContainer,salesforceName, salesforceId);
				}
			} else {
				whoObjectContainer.appendChild(whoSearchContainer);
				whatObjectContainer.appendChild(whatSearchContainer);
			}			
			
			this.RegisterKeyUpEvent(whoSearchContainer,enterKeyCode,this.FireSearchRequest);		
			this.RegisterKeyUpEvent(whatSearchContainer,enterKeyCode,this.FireSearchRequest);	
			
			whoObjectSegment.appendChild(whoObjectContainer);
			whatObjectSegment.appendChild(whatObjectContainer);
			
			mainRowDiv.appendChild(whoObjectSegment);
			mainRowDiv.appendChild(whatObjectSegment);
						
			var deleteRowColumn = CreateElement("div", null, null, null);
			var trashIcon = CreateElement("span", "ebsta-complex-add-trashicon", null, null);
			trashIcon.addEventListener("click", function(){ 
				mainRowDiv.remove(); 
				globalContext.CheckEmptyRowExists();
			});
			deleteRowColumn.appendChild(trashIcon);
			mainRowDiv.appendChild(mainRowDiv.appendChild(deleteRowColumn));
			
			return mainRowDiv;
		},
		CreateSearchContainer : function(inputPlaceHolderAttr){
			var searchContainer = CreateElement("div", "ebsta-complex-add-search-container", null, null);
			
			var inputDiv = CreateElement("input", "ebsta-complex-add-search-input", null, null);
			inputDiv.placeholder = inputPlaceHolderAttr;
			searchContainer.appendChild(inputDiv);
			
			var magnifyIcon = CreateElement("span", "ebsta-complex-add-magnifyicon", null, null);
						
			searchContainer.appendChild(magnifyIcon);
			
			magnifyIcon.addEventListener("click", function(){ 
				globalContext.FireSearchRequest(searchContainer);
			});
			
			return searchContainer;
		},
		GetRecordType : function(recordId){
			if(recordId != null && recordId.length > 2){
				var prefix = recordId.substring(0,3);
				switch(prefix){
					case "001":
						return "Account";
					case "003":
						return "Contact";
					case "006":
						return "Opportunity";
					case "00Q":
						return "Lead";
					case "500":
						return "Case";
				}
			}
			return "Other";
		},
		IsRecordAWho : function (recordId){
			if(recordId != null && recordId.length > 2){
				var prefix = recordId.substring(0,3);
				switch(prefix){
					case "00Q":
					case "003":
						return true;
				}
			}
			
			return false;
		},
		//Creates a object for the selected result
		CreateSelectedRecordDiv : function(recordName, salesforceId){
			var recordType = this.GetRecordType(salesforceId);
		
			var recordContainer = CreateElement("div", "ebsta-complex-add-record-container ebCA" + recordType, null, null);
			
			recordContainer.setAttribute("sfId", salesforceId);
			recordContainer.setAttribute("sfType", recordType);
			
			var recordIcon = CreateElement("span", "ebsta-complex-add-record-icon ebCA" + recordType + "Icon", null, null);
			recordContainer.appendChild(recordIcon);
			
			var recordText = CreateElement("span", "ebsta-complex-add-record-text", recordName, null);
			recordContainer.appendChild(recordText);

			return recordContainer;
		},
		//Gets the add or remove icon which is appended on the end of the selected record
		GetAddOrRemoveIcon : function (addIcon, removeIcon){
			if(addIcon){
				return CreateElement("span", "ebsta-complex-add-record-add-remove-icon ebCAAdd", null, null);
			} else if(removeIcon){			
				return CreateElement("span", "ebsta-complex-add-record-add-remove-icon ebCARemove", null, null);
			}
		},
		RemoveIconListener : function (removeIcon, elementToRemove, inputElement, salesforceName, salesforceId){
			removeIcon.addEventListener("click", function() {
				elementToRemove.remove();
				
				var inputParentContainerElement = ClosestElement(inputElement, function (element){
						return element.className === "ebsta-complex-add-container";
				});
				
				//Check is there are any selected objects here, if not re-display the input box
				if(inputParentContainerElement != null){
					var	selectedRecords = inputParentContainerElement.getElementsByClassName("ebsta-complex-add-record-container");
					if(selectedRecords.length == 0){
						inputElement.style.display = "block";
					}
				}
			});
		},
		RegisterKeyUpEvent : function (elementToAttachKeyEventTo, keyCode, functionCallback){
			elementToAttachKeyEventTo.addEventListener("keyup", function (event) {
		        //Enter key event
		        if (event.keyCode == keyCode)
		        {
		            functionCallback(elementToAttachKeyEventTo);
		        }
		    });
		},
		GetLoadingGifAndText : function (){
			var loadingDivContainer = CreateElement("div", "ebsta-complex-add-record-loader", null, null);
			
			var loadingGif = CreateElement("span", "ebsta-complex-add-record-loader-gif ebsta-loader", null, null);
			loadingDivContainer.appendChild(loadingGif);
			
			var loadingText = CreateElement("span", "ebsta-complex-add-record-loadingtext", "Loading...", null);
			loadingDivContainer.appendChild(loadingText);
			
			return loadingDivContainer;
		},
		FireSearchRequest : function (searchContainerElement){
			if(searchContainerElement){
				var inputDivSearch = searchContainerElement.getElementsByClassName("ebsta-complex-add-search-input");
				if(inputDivSearch.length == 1){
					var inputElement = inputDivSearch[0];
					var closestContainer = ClosestElement(searchContainerElement, function (element){
						return element.className === "ebsta-complex-add-segment";
					});

					if(closestContainer != null){
						var resultsWindow = globalContext.CreateOrGetResultsWindow(closestContainer);
						EmptyElement(resultsWindow);
						
						var loadingGifsFound = closestContainer.getElementsByClassName("ebsta-complex-add-record-loader");
						if(loadingGifsFound.length == 0){
							closestContainer.appendChild(globalContext.GetLoadingGifAndText());
						}
						
						var searchType = globalContext.WhoOrWhatSearch(closestContainer);
						
						if(searchType != null){
							if(core.Namespace() == 2){
								ebsta2.ebstaRemoteDataServices.GetComplexAddSearchResults(
									inputElement.value, searchType,	function(result, event){
									globalContext.HandleResultResponseFromSearchQuery(result, resultsWindow, closestContainer, inputElement);
								});
							} else {
								ebsta1.ebstaRemoteDataServices.GetComplexAddSearchResults(
									inputElement.value, searchType,	function(result, event){
									globalContext.HandleResultResponseFromSearchQuery(result, resultsWindow, closestContainer, inputElement);
								});
							}
						}
					}
				}
			}
		},
		FireRelatedSearchRequest : function (id, closestEbstaComplexAddContainer){
			var closestRowDiv = ClosestElement(closestEbstaComplexAddContainer, function (element){
				return element.className === "row ebsta-complex-add-row";
			});

			if(closestRowDiv != null){
				var whatSegments = closestRowDiv.getElementsByClassName("ebsta-complex-add-segment");
				
				if(whatSegments.length > 1){
					var whatSegment = whatSegments[1];
					var resultsWindow = globalContext.CreateOrGetRelatedSuggestionsWindow(whatSegment);
					
					var loadingGifsFound = whatSegment.getElementsByClassName("ebsta-complex-add-record-loader");
					if(loadingGifsFound.length == 0){
						whatSegment.appendChild(globalContext.GetLoadingGifAndText());
					}
										
					var inputDivSearch = whatSegment.getElementsByClassName("ebsta-complex-add-search-input");
					if(inputDivSearch.length == 1){
						var inputElement = inputDivSearch[0];
						if(core.Namespace() == 2){
							ebsta2.ebstaRemoteDataServices.GetRelatedObjects(
								id, 0, function(result, event){
								globalContext.HandleResultResponseFromSearchQuery(result, resultsWindow, whatSegment, inputElement);
							});
						} else {
							ebsta1.ebstaRemoteDataServices.GetRelatedObjects(
								id, 0, function(result, event){
								globalContext.HandleResultResponseFromSearchQuery(result, resultsWindow, whatSegment, inputElement);
							});
						}
					}
				}
			}
		},
		WhoOrWhatSearch : function(complexAddSegment){
			var objectTypeAttr = complexAddSegment.getAttribute("objecttype");
			if(objectTypeAttr != null){
				switch(objectTypeAttr){
					case "who":
						return 0;
					case "what":
						return 1;
				}
			}
			return null;
		},
		HandleResultResponseFromSearchQuery : function (result, resultsContainer, segmentElement, inputElement){
			var loadingGifsToRemove = segmentElement.getElementsByClassName("ebsta-complex-add-record-loader");
			for(var i=0; i < loadingGifsToRemove.length; i++){
				loadingGifsToRemove[i].remove();
			}
			
			var records = result.Records;
			if(records != null){
				if(records.length > 0){
					for(var i=0; i < records.length; i++){
						var id = records[i].Id;
						var name = records[i].Name;
						if(id != null && name != null){
							var newContactRecordDiv = globalContext.CreateResultRecordDiv(id, name);
							resultsContainer.appendChild(newContactRecordDiv);
							globalContext.RegisterClickEventOnResult(newContactRecordDiv, inputElement, name, id, resultsContainer);
						}
					}
				} else {
					EmptyElement(resultsContainer);
					resultsContainer.appendChild(CreateElement("span",null,"No Results Found",null));
				}
			}
			
			segmentElement.appendChild(resultsContainer);
		},
		//Creates or gets the results container for results to be appeneded to
		CreateOrGetResultsWindow : function (segmentElement){
			var resultsContainerDivs = segmentElement.getElementsByClassName("ebsta-complex-add-results-container");
			
			if(resultsContainerDivs.length > 0){
				return resultsContainerDivs[0];
			}
			
			return CreateElement("div", "ebsta-complex-add-results-container", null, null);
		},
		CreateOrGetRelatedSuggestionsWindow : function (segmentElement){
			var resultsContainerDivs = segmentElement.getElementsByClassName("ebsta-complex-add-related-results-container");
			
			if(resultsContainerDivs.length > 0){
				return resultsContainerDivs[0];
			}
			
			var relatedResultsContainer = CreateElement("div", "ebsta-complex-add-related-results-container", null, null);
			relatedResultsContainer.appendChild(CreateElement("span", null, "Other suggestions", null));
			
			return relatedResultsContainer;
		},
		RegisterClickEventOnResult : function(element, inputElement, name, id, resultsContainer){
			var closestContainer = ClosestElement(inputElement, function (element){
				return element.className === "ebsta-complex-add-container";
			});
			
			if(closestContainer != null){
				element.addEventListener("click", function(){
					//remove input
					var inputDiv = closestContainer.getElementsByClassName("ebsta-complex-add-search-container");
					
					if(inputDiv.length > 0){
						inputDiv[0].style.display = "none";
						
						var removeIcon = globalContext.GetAddOrRemoveIcon(false, true);
						
						var selectedRecordDiv = globalContext.CreateSelectedRecordDiv(name,id);
						AddClass("selectedResult", selectedRecordDiv);
						selectedRecordDiv.appendChild(removeIcon);
						closestContainer.appendChild(selectedRecordDiv);
						globalContext.RemoveSelectedRecordDivs(closestContainer);
						
						var objectTypeOfSelectedRecord = element.getAttribute("sftype");
						if(objectTypeOfSelectedRecord != null){
							if(objectTypeOfSelectedRecord.toLowerCase() == "lead") {
								globalContext.DisabledOrEnableInputOnWhatContainer(closestContainer,true);
							} else {
								if(objectTypeOfSelectedRecord.toLowerCase() == "contact"){
									globalContext.FireRelatedSearchRequest(id, closestContainer);
								}
								globalContext.DisabledOrEnableInputOnWhatContainer(closestContainer, false);
							}
						}
						
						globalContext.RemoveIconListener(removeIcon, selectedRecordDiv, inputDiv[0], name, id);
						resultsContainer.remove();
						globalContext.CheckEmptyRowExists();
					}
				});
			}
		},
		DisabledOrEnableInputOnWhatContainer: function(complexAddContainer, disable){
			var complexRowElement = ClosestElement(complexAddContainer, function (element){
				return element.className === "row ebsta-complex-add-row";
			});
			
			if(complexRowElement != null){
				var segmentDivs = complexRowElement.getElementsByClassName("ebsta-complex-add-segment");
				if(segmentDivs.length == 2){
					var whatAddContainers = segmentDivs[1].getElementsByClassName("ebsta-complex-add-container");
					if(whatAddContainers.length > 0){
						var whatContainer = whatAddContainers[0];
						var whatSearchContainers = whatContainer.getElementsByClassName("ebsta-complex-add-search-container");
						var inputContainers = whatContainer.getElementsByClassName("ebsta-complex-add-search-input");
						if(inputContainers.length > 0 && whatSearchContainers.length > 0){
							var inputContainer = inputContainers[0];
							if(!disable){
								RemoveClass("disabled", whatContainer);
								inputContainer.value = "";
								inputContainer.removeAttribute("disabled");
							} else {
								AddClass("disabled", whatContainer);
								globalContext.RemoveSelectedRecordDivs(whatContainer);
								whatSearchContainers[0].removeAttribute("style");
								inputContainer.value = "Cannot add related objects to Leads";
								inputContainer.setAttribute("disabled", "disabled");
							}
						}
					}
				}
			}
		},
		RemoveSelectedRecordDivs : function(closestContainer){
			var selectedRecordDivs = closestContainer.getElementsByClassName("ebsta-complex-add-record-add-remove-icon");
			for(var i = 0; i < selectedRecordDivs.length; i++){
				selectedRecordDivs[i].click();
			}
		},
		CreateResultRecordDiv : function (salesforceId, recordName){
			var recordType = this.GetRecordType(salesforceId);
		
			var recordContainer = CreateElement("div", "ebsta-complex-add-record-container result", null, null);
			
			recordContainer.setAttribute("sfId", salesforceId);
			recordContainer.setAttribute("sfType", recordType);
			
			var recordIcon = CreateElement("span", "ebsta-complex-add-record-icon ebCA" + recordType + "ResultIcon", null, null);
			recordContainer.appendChild(recordIcon);
			
			var recordText = CreateElement("span", "ebsta-complex-add-record-text", recordName, null);
			recordContainer.appendChild(recordText);
			
			recordContainer.appendChild(this.GetAddOrRemoveIcon(true, false));

			return recordContainer;
		},
		CheckEmptyRowExists : function (){
			var complexAddRows = mainPopUpElement.getElementsByClassName("ebsta-complex-add-row");
			var doWeNeedToAddARow = false;
			if(complexAddRows.length > 0){
				var complexAddContainers = complexAddRows[complexAddRows.length - 1].getElementsByClassName("ebsta-complex-add-container");

				for(var i = 0; i < complexAddContainers.length; i++){
					var recordsSelectedElements = complexAddContainers[i].getElementsByClassName("ebsta-complex-add-record-container");
					if(recordsSelectedElements.length > 0){
						doWeNeedToAddARow = true;
						break;
					}
				}
			} else {
				doWeNeedToAddARow = true;
			}
		
			if(doWeNeedToAddARow){
				complexAddRowContainer.appendChild(globalContext.CreateComplexAddRow(null, null));
			}
		},
		AddSaveButton : function(){
			var saveButton = CreateElement("button", "btn btn-info ebsta-complex-add-save-button", "Save Attachments", null);
			
			saveButton.addEventListener("click", function(){
				var complexAddRows = mainPopUpElement.getElementsByClassName("ebsta-complex-add-row");
				if(complexAddRows.length > 0){
					var rowsArray = new Array();
					
					for(var i = 0; i <  complexAddRows.length; i++){
						var rowIds = globalContext.GetIdsFromRow(complexAddRows[i]);
						if(rowIds.length > 0){
							rowsArray.push(rowIds);
						}
					}
					
					if(rowsArray.length > 0){
						if(core.Namespace() == 2){
							ebsta2.ebstaRemoteDataServices.SaveAttachment(
								attachmentId, rowsArray, function(result, event){
								globalContext.HandleResultResponseFromAddingAttachmentQuery(result);
							});
						} else {
							ebsta1.ebstaRemoteDataServices.SaveAttachment(
								attachmentId, rowsArray, function(result, event){
								globalContext.HandleResultResponseFromAddingAttachmentQuery(result);
							});
						}
					}
				}
				globalContext.HideComplexAddPopUp();
			});
			
			return saveButton;
		},
		GetIdsFromRow : function(row){
			var idArray = new Array();
			if(row != null){
				var addContainers = row.getElementsByClassName("ebsta-complex-add-container");
				if(addContainers.length > 0){
					for(var i = 0 ; i < addContainers.length; i++){
						var selectedRecord = addContainers[i].getElementsByClassName("ebsta-complex-add-record-container");
						if(selectedRecord.length > 0){
							var getSfId = selectedRecord[0].getAttribute("sfid");
							if(getSfId != null){
								idArray.push(getSfId);
							}
						}
					}
				}
			}
			return idArray;
		},
		HandleResultResponseFromAddingAttachmentQuery : function (results){
			var errors = false;
			var attachmentsAdded = 0;
			if(results != null){
				for (var rowResultKey in results) {
  					if (results.hasOwnProperty(rowResultKey)) {
  						var rowResult = results[rowResultKey];
						for(var j = 0; j < rowResult.length; j++){
							if(rowResult[j]){
								attachmentsAdded++;
							} else {
								errors;
							}
						}
					}
				}
			}
			
			var responseMessage = "Succesfully added " + attachmentsAdded + " attachment(s).";
			
			if(errors){
				if(attachmentsAdded > 0) {
					responseMessage = "Added " + attachmentsAdded + " attachment(s) but some attachments failed.";
				} else {
					responseMessage = "Failed to add attachment(s).";
				}
			}
			
			globalContext.ShowResponseOverlay(responseMessage, errors);
		},
		ShowResponseOverlay : function (responseMessage, wasThereErrors){
			globalContext.CreateResponseOverlay();
			
			if(wasThereErrors){
				RemoveClass("alert-success", responseOverlay);
				AddClass("alert-danger", responseOverlay);
			} else {
				AddClass("alert-success", responseOverlay);
				RemoveClass("alert-danger", responseOverlay);
			}
			
			responseOverlay.innerText = responseMessage;
			
			responseOverlay.style.display = "block";
			
			setTimeout(function() {
            	responseOverlay.style.display = "none";
            }, 3500);
		},
		CreateResponseOverlay : function (){
			if(responseOverlay == null){
				responseOverlay = CreateElement("div", "ebsta-complex-add-response alert", null, null);
				responseOverlay.style.display = "none";
				document.body.appendChild(responseOverlay);
			}
		}
	}
}