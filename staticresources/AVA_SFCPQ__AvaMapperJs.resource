class AvaFieldMapper {
  /**
   * 
   * @param {*} mapperId 
   * @param {*} inputJSON 
   */
  constructor(mapperId, inputJSON, tabName) {
      this.mapperId = mapperId;
      this.inputJSON = inputJSON;
	  this.tabName = tabName;
      this.maxFieldWidth = 0;
      this.sourceGroupHeight = 0;
      this.targetGroupHeight = 0;
      this.currentSourceNode;
      this.currentTargetNode;
  }

  getSourceNode() {
    return this.currentSourceNode;
  }

  setSourceNode(node) {
    this.currentSourceNode = node;
  }

  getTargetNode() {
    return this.currentTargetNode;
  }

  setTargetNode(node) {
    this.currentTargetNode = node;
  }

  /**
   * 
   */
  initSvg() {
    let _this = this;
    let draw = new SVG(_this.mapperId);
    let nested = draw.nested().addClass('key');
    _this.maxFieldWidth = 250;
    let sourceData = _this.inputJSON.nodeDataArray[0];
    let targetData = _this.inputJSON.nodeDataArray[1];
    let targetGroup = _this.createFieldsGroup(nested, targetData.key, targetData.fields, 'target');
    let sourceGroup = _this.createFieldsGroup(nested, sourceData.key, sourceData.fields, 'source');
    //let drawHeight = (_this.targetGroupHeight > _this.sourceGroupHeight? _this.targetGroupHeight : _this.sourceGroupHeight) + 100;
    //alert(drawHeight);
    let drawTargetHeight;
    let drawSourceHeight;
       
    if(this.tabName == 'canceltaxcalculation'){
        drawTargetHeight = _this.targetGroupHeight * 4;  
        drawSourceHeight =  _this.sourceGroupHeight * 4;    
    }
    else if(this.tabName != 'addressvalidation'){
        drawTargetHeight = _this.targetGroupHeight * 1.5;  
        drawSourceHeight =  _this.sourceGroupHeight * 1.5;
    } else {
        drawTargetHeight = _this.targetGroupHeight + 200; 
        drawSourceHeight =  _this.sourceGroupHeight + 200;
    }    
      
    let drawMaxHeight = (drawTargetHeight > drawSourceHeight? drawTargetHeight : drawSourceHeight);
        
    targetGroup.rect(_this.maxFieldWidth + 30, drawMaxHeight).attr({
      x: 2,
      y: 2,
      fill: '#fff',
      stroke: '#059bd2',
      'stroke-width': 2,
    }).back();

    sourceGroup.rect(_this.maxFieldWidth + 30, drawMaxHeight).attr({
      x: 2,
      y: 2,
      fill: '#fff',
      stroke: '#059bd2',
      'stroke-width': 2,
    }).back();

    targetGroup.x(_this.maxFieldWidth + 150);
    draw.height(drawMaxHeight + 5); 
     
    setTimeout(_this.drawConnectors(sourceGroup, targetGroup, _this.inputJSON.linkDataArray), 4000);

    let text = sourceGroup.text('Click to remove');
    text.attr({
      'font-weight': 'bold',
      cursor: 'pointer',
      'font-size': 12,
      class: 'removeTooltip',
      fill: '#ff6600',
      family: 'sans-serif',
      x: 210,
      y: 30,
      'fill-opacity': 0
    });
  }

  /**
   * 
   * @param {*} nodeDataArray 
   */
  /*findFieldsMaxWidth(nodeDataArray = []) {
    let maxWidth = nodeDataArray[0].fields && nodeDataArray[0].fields[0].name.length;
    nodeDataArray.forEach((nodes) => {
      nodes.fields.forEach((field) => {
        if (maxWidth < field.name.length) {
          maxWidth = field.name.length;
        }
      });
    });
  console.log(maxWidth * 7);
    return maxWidth * 7;
  }*/

  /**
   * 
   * @param {*} nested 
   * @param {*} key 
   * @param {*} fieldSet 
   * @param {*} type 
   */
  createFieldsGroup(nested, key, fieldSet, type) {
    var group = nested.group().attr({class: key});
    var x = 2, y = -5;
	//y = 45;
    this.drawFieldNode(group, key, key, x, y, 'header');
    if ((this.tabName == 'taxcalculation') && (key === 'AvaTax' && type === 'source')) {
      y = 45;
      this.drawFieldNode(group, key, '+ ADD NEW', x, y, 'button');
    }

    var lastFieldNode;
    fieldSet.forEach((field) => {
      	y = lastFieldNode? lastFieldNode.rectObj.y() + (lastFieldNode.lineCount > 1? (lastFieldNode.lineCount*30) :47) : 90;
        if(type == "target"){
            this.targetGroupHeight +=35;
        } else if(type == "source"){
            this.sourceGroupHeight +=35;	
        }
      	lastFieldNode = this.drawFieldNode(group, key, field.name, x, y, type)
    });
  
    return group;
  }

  /**
   * 
   * @param {*} parent 
   * @param {*} key 
   * @param {*} fieldName 
   * @param {*} x 
   * @param {*} y 
   * @param {*} type 
   */
  drawFieldNode(parent, key, fieldName, x, y, type) {
    let newFieldName = fieldName;    
	let modFieldName = '';
	let lineCount = 1;
    if(newFieldName.length > 30) {
    	do {
            if(newFieldName.length > 30){
                modFieldName += newFieldName.substring(0, 30) + '\n';
        		lineCount++;
            } else {
                modFieldName += newFieldName;
            }
            newFieldName = newFieldName.substring(30);	
        } while (newFieldName.length > 0);
    } else {
        modFieldName = newFieldName; 
    }        
	let filteredFieldName = fieldName;
    let nodeId = filteredFieldName.replace(/\s/g,"").replace(/\./g,"").replace(/_/g,"").toLowerCase() + '_' + type;
    let fieldGroup = parent.group().attr({class: nodeId}).style('cursor:pointer;fill:#f03;');
    let rectWidth = type === 'header'? this.maxFieldWidth + 30 : this.maxFieldWidth;
    let rectX = type === 'header'? 2 : 20;
    let rect;  
      if(lineCount == 1) {
      	 rect = fieldGroup.rect(rectWidth, lineCount*30);   
      } else {
         rect = fieldGroup.rect(rectWidth, lineCount*25);    
      }
      
      if(lineCount > 1 ) {
      }
      rect.attr({
          class: 'source-node',
          fill: (key === 'AvaTax' && type === 'source') ? '#ff6600' : (key === 'AvaTax' && type === 'target') ? '#ff6600' : (key !== 'AvaTax' && type === 'source')? '#e4eff6' : (key !== 'AvaTax' && type === 'target')? '#e4eff6' : '#059bd2' ,
          x: rectX,
          y: y 
      });
  
    fieldGroup.id();
    fieldGroup.data({
      name: fieldName,
      key: key,
      class: nodeId
    });
    let text = fieldGroup.text(modFieldName);
    text.attr({
      fill: (key === 'AvaTax' && type === 'source') ? '#fff': (key === 'AvaTax' && type === 'target') ? '#fff' : (key !== 'AvaTax' && type === 'source') ? '#5f6062' : (key !== 'AvaTax' && type === 'target') ? '#5f6062' : '#fff',
      family: 'sans-serif',
      x: rect.x()+5,
      y: rect.y()
    });
    
    let _this = this;
    
	if(fieldName === '+ ADD NEW'){
		 fieldGroup.on('click', function (e) {
			openMapperDialog(_this.mapperId);
		 })
	 }
    if (type === 'source') {
      fieldGroup.on('click', function (e) {
        _this.setSourceNode(e.currentTarget.instance);
        _this.setTargetNode(undefined);
        _this.toggleNodeSelection(fieldGroup);
      });
    }
  
    if (type === 'target') {
      fieldGroup.on('click', function(e) {
        _this.setTargetNode(e.currentTarget.instance);
        if (!_this.getSourceNode()) {
          return;
        }
        _this.toggleNodeSelection(_this.getSourceNode());
        _this.createConnector(fieldGroup, _this.getSourceNode(), _this.getTargetNode());
        _this.setSourceNode(undefined);
      });
    }
      return {rectObj: rect, lineCount: lineCount};
  }

  /**
   * 
   * @param {*} parent 
   */
  toggleNodeSelection(parent) {
    this.resetAllNodeSelection(parent)
    var selectedNode = parent.select('rect');
    selectedNode.toggleClass('select-node');
  }

  /**
   * 
   * @param {*} parent 
   */
  resetAllNodeSelection(parent) {
    var nodes = parent.parent().select('rect.source-node');
    nodes.each(function() {
      if (this.parent().id() !== parent.id()) {
        this.removeClass('select-node');
      }
    });
  }

  /**
   * 
   * @param {*} parent 
   * @param {*} source 
   * @param {*} target 
   */
  createConnector(parent, source, target) {
    var _this = this;
    var grandParent = parent.parent().parent();
    var sourceId = source.data('class');
    var targetId = target.data('class');
    var sourceRectNode = source.select('rect').members[0];
    var targetRectNode = target.select('rect').members[0];
    var x1 = source.cx() + sourceRectNode.width()/2;
    var y1 = source.cy();
    var x2 = target.parent().x() + target.cx() - targetRectNode.width()/2;
    var y2 = target.parent().y() + target.cy();
    var previousConnector = grandParent.select('line.'+source.data('name').replace(/\./g,"").toLowerCase() + '_line');
    var connector;
    var linkedJsonData;
      if(source.data('key') != 'AvaTax'){
          var sourceId = 'av-'+source.data('key')+'-mapper-output';
          linkedJsonData = JSON.parse(document.getElementById(sourceId).value);
      } else {
          var sourceId = 'av-'+target.data('key')+'-updatemapper-output';
          linkedJsonData =JSON.parse(document.getElementById(sourceId).value);
      }
      for(var i=0; i<linkedJsonData.linkDataArray.length; i++){
          if(linkedJsonData.linkDataArray[i].toPort == target.data('name') ) {
              alert('Please select another node as its already mapped or remove previous mapping');
              return;
          }
      }  
    if (previousConnector.length()) {
      connector = grandParent.line(x1, y1, x2, y2).stroke({ 'stroke-width': 5, color: '#72767e' }).attr({class: source.data('name').replace(/\./g,"").toLowerCase() + '_line'});
      previousConnector.replace(connector);
    } else {
      	connector = grandParent.line(x1, y1, x2, y2).stroke({ 'stroke-width': 5, color: '#72767e' }).attr({class: source.data('name').replace(/\./g,"").toLowerCase() + '_line'});
    }
    connector.data({
      source: source.data('name'),
      target: target.data('name')
    });

    var marker = grandParent.marker();
        marker.attr({
            viewBox:'0 -5 10 10',
            markerWidth: 15,
            markerHeight: 15,
            refX: 2,
            refY: 2,
            orient: 'auto'
        });
      var arrowhead = grandParent.path(
        'M0,0 V4 L2,2 Z'
      ).fill('#059bd2');
      marker.add(arrowhead);
      connector.marker('end', marker);
    this.updateLinkData(source, target);

    connector.on('mouseover', function(e) {
      var tooltip = grandParent.select('text.removeTooltip');
      tooltip.attr({
        'fill-opacity': 1,
        x: e.layerX - 30, //(x1 + x2)/2 - 50,
        y: e.layerY + 10 //(y1 + y2)/2 - 40
      })
    });

    connector.on('mouseout', function(e) {
      var tooltip = grandParent.select('text.removeTooltip');
      setTimeout(function() {
        tooltip.attr({
        'fill-opacity': 0
      });
    }, 1000);
    });

    connector.on('click', function(e) {
      var connectorData = e.target.dataset;
      _this.removeLinkData(connectorData, _this);
      e.target.remove();
      var tooltip = grandParent.select('text.removeTooltip');
      tooltip.attr({
      'fill-opacity': 0
      });
    });
  }

  /**
   * 
   * @param {*} source 
   * @param {*} target 
   */
  updateLinkData(source, target) {
    var inputLinkDataArray = this.inputJSON.linkDataArray || [];
    var currentNodeLinkIndex = inputLinkDataArray.findIndex((node, index) => {
      var sourceDataCase = source.data('name'); 
      var nodeFromPort = node.fromPort;  
      if ( nodeFromPort.toLowerCase() === sourceDataCase.replace(/\./g,"").toLowerCase()) {
        return true;
      }
      return false;
    });
    //alert(currentNodeLinkIndex);   
  	
    var nodeLinkData = {
      from: source.data('key'), 
      fromPort: source.data('name').replace(/\./g,""),
      to: target.data('key'),
      toPort: target.data('name').replace(/\./g,"")  
    }
    if (currentNodeLinkIndex > -1) {
      inputLinkDataArray[currentNodeLinkIndex] = nodeLinkData;
    } else {
      inputLinkDataArray.push(nodeLinkData);
    }
	if(source.data('key') != 'AvaTax'){
		var sourceId = 'av-'+source.data('key')+'-mapper-output';
		document.getElementById(sourceId).value = JSON.stringify(this.inputJSON);
	} else {
		var sourceId = 'av-'+target.data('key')+'-updatemapper-output';
		document.getElementById(sourceId).value = JSON.stringify(this.inputJSON);
	}
   // document.getElementById('av-mapper-output').value = JSON.stringify(this.inputJSON);
  }

  removeLinkData(connector, _this) {
    var inputLinkDataArray = _this.inputJSON.linkDataArray || [];
	var sourceId;
	var targetId;
    var foundYes;
    var myCurrentIndex;  
    var currentNodeLinkIndex = inputLinkDataArray.findIndex((node, index) => {
        sourceId = node.from;
        targetId = node.to;
        var connSource = connector.source;
        var connTarget = connector.target;
        
        var fromPortReplace = node.fromPort;
        var toPortReplace = node.toPort;

        if (fromPortReplace.replace(/\./g,"") === connSource.replace(/\./g,"") && toPortReplace.replace(/\./g,"") === connTarget.replace(/\./g,"")) {
        	foundYes = true;
            myCurrentIndex =index;
        }
    });
    if(foundYes == true) {
      inputLinkDataArray.splice(myCurrentIndex, 1);
    }
	if(sourceId == 'AvaTax'){
		var sourceNode = 'av-'+targetId+'-updatemapper-output';
		document.getElementById(sourceNode).value = JSON.stringify(_this.inputJSON);
	} else {
		var sourceNode = 'av-'+sourceId+'-mapper-output';
		document.getElementById(sourceNode).value = JSON.stringify(_this.inputJSON);
	}   
  }
  /**
   * 
   * @param {*} sourceGroup 
   * @param {*} targetGroup 
   * @param {*} nodeLinkData 
   */
  drawConnectors(sourceGroup, targetGroup, nodeLinkData = []) {
    var _this = this;
    if (nodeLinkData.length) {
      nodeLinkData.forEach((link) => {
        var sourceId = link.fromPort.toLowerCase();
		var rawSource = sourceId.replace(/\s/g,"").replace(/\./g,"").replace(/_/g,"").toLowerCase(); 
        var targetId = link.toPort.toLowerCase();
		var rawDestination = targetId.replace(/\s/g,"").replace(/\./g,"").replace(/_/g,"").toLowerCase();
        var sourceField = sourceGroup.select('g.' + rawSource + '_source').members[0];
        var targetField = targetGroup.select('g.' + rawDestination + '_target').members[0];
		
        if (sourceField && targetField) {
          var sourceRectNode = sourceField.select('rect').members[0];
          var targetRectNode = targetField.select('rect').members[0];
          var x1 = sourceField.cx() + sourceRectNode.width()/2;
          var y1 = sourceField.cy();
          var x2 = targetField.parent().x() + targetField.cx() - targetRectNode.width()/2;
          var y2 = targetField.parent().y() + targetField.cy();
      
          var connector = sourceGroup.parent().line(x1, y1, x2, y2).stroke({ width: 3, color: '#72767e' }).attr({class: sourceId + '_line'});
		  //var connector = sourceGroup.parent().polyline([[x1,y1], [x1+66,y1],[x1+66,y2],[x2,y2]]).fill('none').stroke({ width: 2, color: '#72767e' }).attr({class: sourceId + '_line'});

          connector.data({
            source: link.fromPort,
            target: link.toPort
          });

          var marker = sourceGroup.parent().marker(); // or draw.defs().marker()
          marker.attr({
              viewBox:'0 -5 10 10',
              markerWidth: 15,
              markerHeight: 15,
              refX: 2,
              refY: 2,
              orient: 'auto'
          });
          var arrowhead = sourceGroup.parent().path(
            'M0,0 V4 L2,2 Z'
          ).fill('#059bd2');
          marker.add(arrowhead);
          connector.marker('end', marker);
  
          connector.on('mouseover', function(e) {
            var tooltip = sourceGroup.parent().select('text.removeTooltip');
            tooltip.attr({
              'fill-opacity': 1,
              x: e.layerX - 30, //(x1 + x2)/2 - 50,
              y: e.layerY + 10 //(y1 + y2)/2 - 40
            })
          });

          connector.on('mouseout', function(e) {
            var tooltip = sourceGroup.parent().select('text.removeTooltip');
            setTimeout(function() {
              tooltip.attr({
              'fill-opacity': 0
            });
          }, 1000);
          });

          connector.on('click', function(e) {
            var connectorData = e.target.dataset;
            _this.removeLinkData(connectorData, _this);
            e.target.remove();
            var tooltip = sourceGroup.parent().select('text.removeTooltip');
            tooltip.attr({
            'fill-opacity': 0
            });
          });
        }
      });
    }
  }
}