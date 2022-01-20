.ebsta-connect-mailbox-modal
{
	display:none;
} 

.ebsta-main-modal-button
{
	width: 185px!important;
}
 
.ebsta-selected-page
{
	background-color: #f4f6f9!important;
}
 
.ebsta-progress {
    margin-bottom: 0px!important;
}

.progress {
    overflow: hidden;
    height: 17px;
    margin-bottom: 17px;
    background-color: #f5f5f5;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
}

.progress-bar {
    float: left;
    width: 0%;
    height: 100%;
    font-size: 11px;
    line-height: 17px;
    color: #ffffff;
    text-align: center;
    background-color: #3cb1ba;
    -webkit-box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
    box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
    -webkit-transition: width 0.6s ease;
    -o-transition: width 0.6s ease;
    transition: width 0.6s ease;
}

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    margin: -1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    border: 0;
}
 
.ebsta-green-text{
	fill: #75C375!important;
}

.ebsta-received-pagination
{
	margin-top:15px;
	margin-bottom:15px;
}

.ebstaNav{
	    margin-bottom: 15px!important;
}

.preEmail{
    white-space: pre-line;    
}

.pointer{
	cursor:pointer;
}

.ebstaHidden
{
	display:none;
}

@include popover('.slds-popover', $shadow-drop-down);

.slds-popover {
  border: $border-width-thin solid $color-border;

}

.slds-nubbin--left .slds-popover__content:before {
    width: 1rem;
    height: 1rem;
    position: absolute;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
    content: "";
    background-color: #fff;
    top: 50%;
    left: -0.5rem;
    margin-top: -0.5rem;
    display:none;
}

.slds-nubbin--left .slds-popover__content:after {
    width: 1rem;
    height: 1rem;
    position: absolute;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
    content: "";
    background-color: #fff;
    top: 50%;
    left: -0.5rem;
    margin-top: -0.5rem;
    display:none;
}

.slds-popover {
    position: absolute;
    border-radius: 0.25rem;
    max-width: 20rem;
    z-index: 6000;
    background-color: #fff;
    box-shadow: 0px 2px 3px 0px rgba(0,0,0,0.16);
        margin-left: 21px;
    margin-top: -30px;
    display:none;
}

.slds-popover__content{
    white-space: pre-line;
    padding:10px;
}

.slds-popover__content--small{
    padding:5px!important;
}

.ebsta-block-icon{
	margin-right:5px;
}