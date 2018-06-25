var Viola = this;
(function () {
 'use strict';
 
 function define(o, p, v, override) {
 if (!override && (p in o))
 { return; }
 if (typeof v === 'function') {
 Object.defineProperty(o, p, {
                       value: v,
                       configurable: true,
                       enumerable: false,
                       writable: true
                       });
 } else {
 Object.defineProperty(o, p, {
                       value: v,
                       configurable: false,
                       enumerable: false,
                       writable: false
                       });
 }
 }
 
 define(Object, 'assign', function assign(target, sources) {
        var arguments$1 = arguments;
        var to = Object(target);
        if (arguments.length < 2) { return to; }
        var sourcesIndex = 1;
        while (sourcesIndex < arguments.length) {
        var nextSource = arguments$1[sourcesIndex++];
        if (nextSource === undefined || nextSource === null) {
        var keys = [];
        } else {
        var from = Object(nextSource);
        keys = Object.getOwnPropertyNames(from);
        }
        for (var keysIndex = 0; keysIndex < keys.length; ++keysIndex) {
        var nextKey = keys[keysIndex];
        var desc = Object.getOwnPropertyDescriptor(from, nextKey);
        if (desc !== undefined && desc.enumerable) {
        var propValue = from[nextKey];
        to[nextKey] = propValue;
        }
        }
        }
        return to;
        });
 
 var isUndef = function (value) {
 return value === undefined || value === null
 };
 var isDef = function (value) {
 return value !== undefined && value !== null
 };
 
 function readonlyProp (instance, prop, value) {
 Object.defineProperty(instance, prop, {
                       enumerable: true,
                       value: value
                       });
 }
 function unenumerable(instance, prop, value) {
 var option = {
 enumerable: false
 };
 isDef(value) && (option.value = value);
 Object.defineProperty(instance, prop, option);
 }
 function isEmptyObj(object) {
 for (var key in object) {
 return false
 }
 return true
 }
 
 var nodeRef = 0;
 var customRef = {};
 var uniqueRef = function (ref) {
 if (ref && !customRef[ref]) {
 customRef[ref] = true;
 return ref
 }
 return (++nodeRef).toString()
 };
 var getValueType = function (v) {
 return Object.prototype.toString.call(v).replace(/^\[|\]$/g, '').slice(7)
 };
 var toString = function (v) {
 switch (getValueType(v)) {
 case 'Object':
 case 'Array':
 return JSON.stringify(v)
 case 'Function':
 return v.toString()
 default:
 return v
 }
 };
 
 if (typeof Viola.console === 'undefined' && Viola.nativeLog) {
 Viola.console = {
 log: function log (str) {
 return Viola.nativeLog(toString(str), 1)
 },
 error: function error (str) {
 return Viola.nativeLog(toString(str), 3)
 }
 };
 }
 
 function append(parent, node, list) {
 if ( list === void 0 ) list = parent.children;
 var lastChild = list[list.length - 1] || null;
 lastChild && (lastChild.nextSibling = node);
 node.previousSibling = lastChild;
 node.parentNode = parent;
 list.push(node);
 return node
 }
 function resetNode(node) {
 if (node.parentNode) {
 remove(node);
 }
 return node
 }
 function remove (node) {
 var nodeNext = node.nextSibling;
 var nodePrev = node.previousSibling;
 nodeNext && (nodeNext.previousSibling = nodePrev);
 nodePrev && (nodePrev.nextSibling = nodeNext);
 var children = node.parentNode.children;
 children.splice(children.indexOf(node), 1);
 node.parentNode = node.nextSibling = node.previousSibling = null;
 return node
 }
 function insertBefore(node, refNode, list) {
 if ( list === void 0 ) list = refNode.parentNode.children;
 var refNodePrev = refNode.previousSibling;
 if (node == refNodePrev) { return node }
 if (refNodePrev) {
 node.previousSibling = refNodePrev;
 refNodePrev.nextSibling = node;
 }
 node.nextSibling = refNode;
 refNode.previousSibling = node;
 node.parentNode = refNode.parentNode;
 list.splice(list.indexOf(refNode), 0, node);
 return node
 }
 function insertAfter(node, refNode, list) {
 if ( list === void 0 ) list = refNode.parentNode.children;
 var refNodeNext = refNode.nextSibling;
 if (node == refNodeNext) { return node }
 if (refNodeNext) {
 node.nextSibling = refNodeNext;
 refNodeNext.previousSibling = node;
 }
 node.previousSibling = refNode;
 refNode.nextSibling = node;
 node.parentNode = refNode.parentNode;
 list.splice(list.indexOf(refNode) + 1, 0, node);
 return node
 }
 function isChild(parent, node) {
 return parent === node.parentNode
 }
 
 var NodeType = {
 ELEMENT_NODE: 1,
 DOCUMENT_NODE: 9,
 TEXT_NODE: 3
 };
 var Node = function Node (ref) {
 this.ref = uniqueRef(ref);
 this.children = [];
 this.parentNode = null;
 this.nextSibling = null;
 this.previousSibling = null;
 this.nodeType = null;
 this.isNatived = false;
 };
 Node.prototype.destroy = function destroy () {
 resetNode(this);
 };
 Node.prototype.setInNative = function setInNative () {
 if (this.isNatived) { return }
 this.isNatived = true;
 if (this.children.length > 0) {
 var chs = this.children;
 for (var i = 0; i < chs.length; i++) {
 var node = chs[i];
 node.isNatived || node.setInNative();
 }
 }
 };
 Node.prototype.outNative = function outNative () {
 this.isNatived = false;
 };
 Node.prototype.toJSON = function toJSON () {
 var ref$1 = this;
 var ref = ref$1.ref;
 var parentNode = ref$1.parentNode;
 var nextSibling = ref$1.nextSibling;
 var previousSibling = ref$1.previousSibling;
 var children = ref$1.children;
 return {
 ref: ref,
 parentNode: parentNode ? parentNode.ref : null,
 nextSibling: nextSibling ? nextSibling.ref : null,
 previousSibling: previousSibling ? previousSibling.ref : null,
 children: children.map(function (child) { return child.toJSON(); })
 }
 };
 Node.isNode = function (n) { return node instanceof Node; };
 
 var MODULE = {
 DOM: 'dom',
 DATA: 'data',
 JSAPI: 'jsapi'
 };
 var METHOD = {
 CALLBACK: 'callback',
 FIRE_EVENT: 'fireEvent',
 CMP_HOOK: 'componentHook'
 };
 var ACTION = {
 CREATE_BODY: 'createBody',
 ADD_EVENT: 'add_event',
 ADD_HOOK: 'add_hook',
 ADD_ELEMENT: 'add_element',
 REMOVE_ELEMENT: 'remove_element',
 UPDATE_ELEMENT: 'update_element',
 DOM_EVENT: 'dom_event',
 DOM_HOOK: 'dom_hook',
 HTTP: 'httpRequest',
 OPEN_URL: 'openUrl'
 };
 
 var injections = {
 callJs: function callJs () {
 throw new Error('no callJs function injection')
 },
 callNative: function callNative () {
 throw new Error('no callNative function injection')
 }
 };
 function inject(name, injection) {
 injections[name] = injection;
 }
 var nativeMethods = ['nativeLog', 'callNative'];
 function initInjections(methods) {
 if ( methods === void 0 ) methods = [];
 nativeMethods = nativeMethods.concat(methods);
 nativeMethods.forEach(function (methodName) {
                       if (Viola[methodName]) {
                       inject(methodName, Viola[methodName]);
                       }
                       });
 }
 
 var Bridge = function Bridge () {
 this.receive.bind(this);
 this.taskerMap = {};
 };
 Bridge.prototype.register = function register (taskerId, tasker) {
 this.taskerMap[taskerId] = tasker;
 };
 Bridge.prototype.send = function send (id, tasks) {
 return injections.callNative(id, tasks)
 };
 Bridge.prototype.receive = function receive (id, args) {
 if (!id) {
 console.log('no instance id');
 }
 this.taskerMap[id] && this.taskerMap[id].receive(args);
 };
 var bridge = new Bridge();
 
 var Eventer = function Eventer (el, initEvent) {
 this.refEl = el;
 readonlyProp(this, 'id', el.ref);
 this.events = {};
 this.eventsMap = {};
 this.hook = {};
 this.hookMap = {};
 this.cbMap = {};
 this.__cbId = 0;
 Object.defineProperty(this, '__isBlank', {
                       enumerable: false,
                       get: function get () {
                       return isEmptyObj(this.cbMap)
                       }
                       });
 this.ownerTasker = null;
 this.__isRegistered = false;
 initEvent && this.__initEvent(initEvent);
 };
 Eventer.prototype.addEvent = function addEvent (type, cb, isImmediate) {
 if ( isImmediate === void 0 ) isImmediate = true;
 if (!this.events[type]) {
 this.events[type] = [];
 this.eventsMap[type] = [];
 }
 var evs = this.events[type];
 evs && evs.push(cb);
 var cbId = this.__cbId++;
 this.cbMap[cbId] = cb;
 this.eventsMap[type].push(cbId);
 if (isImmediate) {
 console.log(' === call bridge add event ===');
 this.send(ACTION.ADD_EVENT, { ref: this.id, type: type });
 console.log(' === call bridge add event end ===\n');
 } else if (!this.__isRegistered) {
 this.registerToTasker();
 }
 return cbId
 };
 Eventer.prototype.registerToTasker = function registerToTasker (tasker) {
 if (this.__isRegistered) { return true }
 var _tasker = tasker ? (this.ownerTasker = tasker) : this.ownerTasker;
 if (this.__isBlank) { return false }
 if (_tasker && _tasker.register) {
 return this.__isRegistered = _tasker.register(MODULE.DOM, this)
 }
 return false
 };
 Eventer.prototype.emitEvent = function emitEvent (type, event) {
 var this$1 = this;
 var evts = this.events[type];
 var isBubble = true;
 event.stopPropagation = function () { isBubble = false;};
 if (evts && evts.length > 0) {
 for (var i = 0; i < evts.length; i++) {
 var evt = evts[i];
 evt.call(this$1.refEl, event);
 }
 }
 var parent;
 if (isBubble && (parent = this.refEl.parentNode)) {
 parent.emit(type, event);
 }
 };
 Eventer.prototype.emitEventById = function emitEventById () {
 var this$1 = this;
 var ref;
 var args = [], len = arguments.length;
 while ( len-- ) args[ len ] = arguments[ len ];
 if (Array.isArray(args[0])) {
 args[0].forEach(function (cb) {
                 this$1.cbMap[cb.id].call(this$1.refEl, cb.e, cb.payload);
                 });
 } else {
 (ref = this.cbMap[args[0]]).call.apply(ref, [ this.refEl ].concat( args.slice(1) ));
 }
 };
 Eventer.prototype.addHook = function addHook (type, cb) {
 var cbId = this.__cbId++;
 this.hook[type] = cb;
 this.hookMap[type] = cbId;
 this.cbMap[cbId] = cb;
 this.send(ACTION.ADD_HOOK, { type: type });
 };
 Eventer.prototype.emitHook = function emitHook (type, payload) {
 this.hook[type] && this.hook[type].call(this, payload);
 };
 Eventer.prototype.getEventMap = function getEventMap () {
 return this.eventsMap
 };
 Eventer.prototype.getEventList = function getEventList () {
 return Object.keys(this.eventsMap)
 };
 Eventer.prototype.offEvent = function offEvent (type, fncId) {
 var this$1 = this;
 if (this.events[type]) {
 if (fncId) {
 var fnc = this.cbMap[fncId];
 var fncIndex = this.events[type].indexOf(fnc),
 idIndex = this.eventsMap[type].indexOf(fncId);
 this.events[type].splice(fncIndex, 1);
 this.eventsMap[type].splice(idIndex, 1);
 delete this.cbMap[fncId];
 } else {
 delete this.events[type];
 var cbIdArray = this.eventsMap[type];
 while (cbIdArray.length) {
 delete this$1.cbMap[cbIdArray.pop()];
 }
 delete this.eventsMap[type];
 }
 }
 };
 Eventer.prototype.__initEvent = function __initEvent (evts) {
 var this$1 = this;
 for (var type in evts) {
 if (evts.hasOwnProperty(type)) {
 var ev = evts[type];
 this$1.addEvent(type, ev, false);
 }
 }
 };
 Eventer.prototype.send = function send (method, payload, cb) {
 var this$1 = this;
 var cbId;
 if (cb && typeof cb === 'function') {
 cbId = this.__cbId++;
 this.cbMap[cbId] = cb;
 }
 var __send = function (method, payload, cb) {
 var cbId;
 if (cb && typeof cb === 'function') {
 cbId = this$1.__cbId++;
 this$1.cbMap[cbId] = cb;
 }
 this$1.ownerTasker.sendTask([{
                              module: 'dom',
                              method: method,
                              args: [Object.assign({}, {ref: this$1.id},
                                                   payload,
                                                   {cbId: cbId})]
                              }]);
 };
 if (!this.__isRegistered && this.registerToTasker()) {
 this.send = __send;
 }
 this.ownerTasker && this.ownerTasker.sendTask([{
                                                module: 'dom',
                                                method: method,
                                                args: [Object.assign({}, {ref: this.id},
                                                                     payload,
                                                                     {cbId: cbId})]
                                                }]);
 };
 
 var TYPEMAP;
 {
 TYPEMAP = {
 'body': 'div',
 'div': 'div',
 'p': 'text',
 'img': 'image'
 };
 }
 function getType(type) {
 return TYPEMAP[type] || 'div'
 }
 
 function createBody(doc, bodyRef) {
 if ( bodyRef === void 0 ) bodyRef = 'root';
 var body = new Element('body', {}, bodyRef);
 body.parentNode = doc;
 body.__setCTX(doc.ctx);
 return body
 }
 var Element = (function (Node$$1) {
                function Element (type, opts, ref) {
                if ( type === void 0 ) type = 'div';
                if ( opts === void 0 ) opts = {};
                Node$$1.call(this, ref);
                this.ctx = null;
                this.type = getType(type);
                this.nodeType = NodeType.ELEMENT_NODE;
                unenumerable(this, '_opts', opts);
                this.style = opts.style || {};
                this.attr = opts.attr || {};
                opts.children && (this.children = this.children.concat(opts.children));
                this.eventer = new Eventer(this, this._opts.events);
                unenumerable(this, 'eventer');
                Object.defineProperty(this, 'events', {
                                      enumerable: true,
                                      get: function get() {
                                      return this.eventer.getEventList()
                                      }
                                      });
                }
                if ( Node$$1 ) Element.__proto__ = Node$$1;
                Element.prototype = Object.create( Node$$1 && Node$$1.prototype );
                Element.prototype.constructor = Element;
                Element.prototype.__setCTX = function __setCTX (instance) {
                if (!instance) { return }
                this.ctx = instance;
                this.eventer.registerToTasker(this.ctx.tasker);
                };
                Element.prototype.setAttr = function setAttr (key, value, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                this.attr[key] = value;
                if (isImmediate || this.isNatived) {
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, {
                                                  ref: this.ref,
                                                  update: {
                                                  attr: this.attr
                                                  }
                                                  });
                }
                };
                Element.prototype.setAttrs = function setAttrs (attrObj, isReplaceAll, isImmediate) {
                if ( isReplaceAll === void 0 ) isReplaceAll = false;
                if ( isImmediate === void 0 ) isImmediate = false;
                if (isReplaceAll) {
                this.attr = attrObj;
                } else {
                Object.assign(this.attr, attrObj);
                }
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, {
                                                  ref: this.ref,
                                                  update: {
                                                  attr: this.attr
                                                  }
                                                  });
                }
                };
                Element.prototype.setStyle = function setStyle (styleObj) {
                if ( styleObj === void 0 ) styleObj = {};
                Object.assign(this.style, styleObj);
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, {
                                                  ref: this.ref,
                                                  update: {
                                                  style: this.style
                                                  }
                                                  });
                }
                };
                Element.prototype.appendChild = function appendChild (node, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                resetNode (node);
                append(this, node, this.children);
                if(isImmediate || this.isNatived) {
                this.eventer && this.eventer.send(ACTION.ADD_ELEMENT, {
                                                  ref: this.ref,
                                                  domObj: node
                                                  });
                node.isNatived = true;
                }
                return node
                };
                Element.prototype.insertBefore = function insertBefore$$1 (node, refNode, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (!isChild(this, refNode)) {
                console.error('reference node isn\'t in this node');
                }
                resetNode(node);
                return insertBefore(node, refNode, this.children)
                };
                Element.prototype.insertAfter = function insertAfter$$1 (node, refNode, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (!isChild(this, refNode)) {
                return console.error('reference node isn\'t in this node')
                }
                resetNode(node);
                return insertAfter(node, refNode, this.children)
                };
                Element.prototype.removeChild = function removeChild (node, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (isChild(this, node)) {
                remove(node);
                if (isImmediate || this.isNatived) {
                this.eventer && this.eventer.send(ACTION.REMOVE_ELEMENT, {
                                                  ref: this.ref,
                                                  delRef: node.ref
                                                  });
                node.isNatived = false;
                }
                return node
                }
                return null
                };
                Element.prototype.render = function render () {
                };
                Element.prototype.on = function on (type, fnc, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = true;
                return (typeof fnc === 'function')
                ? this.eventer.addEvent(type, fnc, (isImmediate || this.isNatived))
                : console.error(new Error('the event callback must be a function'))
                };
                Element.prototype.emit = function emit (type, param) {
                this.eventer.emitEvent(type, param);
                };
                Element.prototype.off = function off (type, fncId) {
                this.eventer.offEvent(type, fncId);
                };
                Element.prototype.toJSON = function toJSON () {
                var ref$1 = this;
                var ref = ref$1.ref;
                var style = ref$1.style;
                var attr = ref$1.attr;
                var events = ref$1.events;
                var children = ref$1.children;
                var type = ref$1.type;
                return {
                ref: ref,
                type: type,
                style: style,
                attr: attr,
                events: events,
                children: children.map(function (child) { return child.toJSON(); })
                }
                };
                return Element;
                }(Node));
 
 var TextNode = (function (Node$$1) {
                 function TextNode (text) {
                 Node$$1.call(this);
                 this.text = text;
                 this.attr = {};
                 this.attr.value = text;
                 this.style = {};
                 this.nodeType = NodeType.TEXT_NODE;
                 this.type = 'text';
                 }
                 if ( Node$$1 ) TextNode.__proto__ = Node$$1;
                 TextNode.prototype = Object.create( Node$$1 && Node$$1.prototype );
                 TextNode.prototype.constructor = TextNode;
                 TextNode.prototype.setText = function setText (text) {
                 this.text = text;
                 this.attr.value = text;
                 };
                 TextNode.prototype.toJSON = function toJSON () {
                 var ref$1 = this;
                 var ref = ref$1.ref;
                 var text = ref$1.text;
                 var type = ref$1.type;
                 var attr = ref$1.attr;
                 var children = ref$1.children;
                 var style = ref$1.style;
                 return {
                 ref: ref,
                 text: text,
                 type: type,
                 attr: attr,
                 children: children,
                 style: style
                 }
                 };
                 return TextNode;
                 }(Node));
 
 var BODY_REF = 'root';
 var DOC_REF = '_root';
 var docMap = {};
 function addDoc(doc) {
 doc instanceof Document && (docMap[doc.id] = doc);
 }
 function removeDoc(docId) {
 delete docMap[docId];
 }
 var Document = function Document (ctx, tasker) {
 this.ctx = ctx;
 this.id = this._instanceId = ctx.getId();
 this.tasker = tasker;
 this.nodeType = NodeType.DOCUMENT_NODE;
 this.body = createBody(this, BODY_REF);
 this.ref = DOC_REF;
 this.children = [ this.body ];
 this.eventer = new Eventer(this);
 this.eventer.registerToTasker(this.tasker);
 this.isNatived = true;
 addDoc(this);
 };
 Document.prototype.createElement = function createElement (type, opts) {
 return new Element(type, opts)
 };
 Document.prototype.createTextNode = function createTextNode (text) {
 return new TextNode(text)
 };
 Document.prototype.createComment = function createComment () {
 };
 Document.prototype.appendChild = function appendChild (body) {
 if (body instanceof Element) {
 body.ref = BODY_REF;
 this.body = body;
 this.render();
 }
 };
 Document.prototype.removeChild = function removeChild (body) {
 return false
 };
 Document.prototype.render = function render (fnc) {
 this.eventer.send(ACTION.CREATE_BODY, this.body.toJSON(), fnc);
 this.body.setInNative();
 };
 Document.prototype.on = function on (type, fnc, isImmediate) {
 return (typeof fnc === 'function')
 ? this.eventer.addEvent(type, fnc, isImmediate)
 : console.error(new Error('the event callback must be a function'))
 };
 Document.prototype.emit = function emit (type, param) {
 this.eventer.emitEvent(type, param);
 };
 Document.prototype.destroy = function destroy () {
 removeDoc(this.instanceId);
 };
 
 var Tasker = function Tasker (instanceId) {
 readonlyProp(this, 'id', instanceId);
 this.callbackMap = {};
 this.domRegisterMap = {};
 this.dom = {
 act: function act (ref$1) {
 var ref = ref$1.ref;
 this.domRegisterMap[ref].emit();
 }
 };
 this.receive.bind(this);
 bridge.register(instanceId, this);
 };
 Tasker.prototype.register = function register (type, resolver) {
 console.log('tasker register:', { type: type, resolver: resolver });
 switch (type) {
 case MODULE.DOM:
 this.domRegisterMap[resolver.id] = resolver;
 return true
 default:
 return false
 }
 };
 Tasker.prototype.sendNative = function sendNative (instanceId, tasks) {
 };
 Tasker.prototype.moduleTask = function moduleTask (task) {
 };
 Tasker.prototype.sendTask = function sendTask (tasks) {
 return bridge.send(this.id, tasks)
 };
 Tasker.prototype.receive = function receive (tasks) {
 var this$1 = this;
 console.log('========== receive ==========');
 console.log(tasks);
 if (Array.isArray(tasks)) {
 tasks.forEach(function (task) {
               switch (task.method) {
               case METHOD.CALLBACK:
               this$1.dom.act(task.args);
               break;
               case MODULE.DATA:
               default:
               break;
               }
               });
 }
 console.log('========== receive End ==========');
 };
 
 var idProperty = '[[instanceId]]';
 var ViolaInstance = function ViolaInstance (instanceId, config, data) {
 if ( config === void 0 ) config = {};
 if (isUndef(instanceId)) {
 throw new Error('ViolaInstance miss instanceId')
 }
 readonlyProp(this, idProperty, instanceId);
 this.config = config;
 this.pageData = data;
 this.tasker = new Tasker(instanceId);
 this.document = new Document(this, this.tasker);
 };
 ViolaInstance.prototype.getId = function getId () {
 return this[idProperty]
 };
 ViolaInstance.prototype.requireAPI = function requireAPI (name) {
 console.log('coming require functional API');
 };
 
 function toGlobal(methods) {
 var loop = function ( name ) {
 var method = methods[name];
 Viola[name] = function () {
 var args = [], len = arguments.length;
 while ( len-- ) args[ len ] = arguments[ len ];
 return method.apply(methods, args)
 };
 inject(name, method);
 };
 for (var name in methods) loop( name );
 }
 
 function createInstanceCtx(id, config, data) {
 var viola = new ViolaInstance(id, config, data);
 return { viola: viola, document: viola.document }
 }
 function createInstance(id, code, config, data) {
 if ( config === void 0 ) config = {};
 var ctx = createInstanceCtx(id, config, data);
 runCodeInCtx(ctx, code);
 }
 function runCodeInCtx(ctx, code) {
 var keys = [], ctxValue = [];
 for (var key in ctx) {
 keys.push(key);
 ctxValue.push(ctx[key]);
 }
 return (new (Function.prototype.bind.apply( Function, [ null ].concat( keys, [code]) ))).apply(void 0, ctxValue)
 }
 var globalMethods = {
 createInstance: createInstance,
 callJS: function callJS (id, task) {
 return bridge.receive(id, task)
 }
 };
 function init(runtimeCfg) {
 if ( runtimeCfg === void 0 ) runtimeCfg = {};
 runtimeCfg.methods && Object.assign(globalMethods, runtimeCfg.methods);
 initInjections();
 toGlobal(globalMethods);
 }
 
 init();
 
 }());
