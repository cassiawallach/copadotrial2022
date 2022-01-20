/* lighting styles*/
.cb-lighting-popup{
    position:fixed;
    width:100%;
    top:0;
    margin:0;
    left:0;
}
.cb-lighting-popup>div{
    width:calc(100% + 10px);
}
.cb-lighting-popup .wrapper{
    max-height:100%;
    position:relative;
    display: flex;
    flex-direction: column;
    border-radius: .25rem;
}
.cb-lighting-popup .hide{
    display: none;
}
.cb-lighting-popup .body{
    padding:1rem 2rem;
    overflow:auto;
    background:white;
}
.cb-lighting-popup input[readonly]{
    outline: none !important;
    box-shadow: none !important;
}

/* classic compatibility styles*/
.cb-lighting-popup-classic{
    position: relative;
    top:0 !important;
    max-height:none !important;        	
}
.cb-lighting-popup-classic .cb-lighting-popup{
    max-width: 100%;
    width: auto !important;
    padding:0 !important;
    margin-left: -5px;
}
.cb-lighting-popup-classic .closeBtn{
    display:none !important;
}
.cb-lighting-popup-classic .wrapper{
    max-height:none !important;
    top:0px;
}
.cb-lighting-popup-classic .body{
    overflow:unset !important;
    width:700px !important;
}
.cb-lighting-popup-classic .slds-modal__footer{
    box-shadow:none !important;
}