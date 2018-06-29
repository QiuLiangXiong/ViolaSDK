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
 
 if (Viola.nativeLog) {
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
 if (node === refNodePrev) { return node }
 if (refNodePrev) {
 node.previousSibling = refNodePrev;
 refNodePrev.nextSibling = node;
 }
 node.nextSibling = refNode;
 refNode.previousSibling = node;
 node.parentNode = refNode.parentNode;
 var insertIndex = list.indexOf(refNode);
 list.splice(insertIndex, 0, node);
 return insertIndex
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
 var insertIndex = list.indexOf(refNode) + 1;
 list.splice(insertIndex, 0, node);
 return insertIndex
 }
 function isChild(parent, node) {
 return parent === node.parentNode
 }
 
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
 
 var NodeType = {
 ELEMENT_NODE: 1,
 DOCUMENT_NODE: 9,
 TEXT_NODE: 3
 }
 
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
 ADD_EVENT: 'addEvent',
 ADD_HOOK: 'add_hook',
 ADD_ELEMENT: 'addElement',
 REMOVE_ELEMENT: 'removeElement',
 UPDATE_ELEMENT: 'updateElement',
 MOVE_ELEMENT: 'moveElement',
 DOM_EVENT: 'dom_event',
 DOM_HOOK: 'dom_hook',
 HTTP: 'httpRequest',
 OPEN_URL: 'openUrl'
 };
 
 var injections = {
 callJS: function callJS () {
 throw new Error('no callJs function injection')
 },
 callNative: function callNative () {
 throw new Error('no callNative function injection')
 },
 globalMethods: {},
 modules: {},
 components: {}
 };
 if (typeof ENV === 'string' && ENV === 'web') {
 window.injections = injections;
 }
 function inject(name, injection) {
 injections[name] = injection;
 }
 function registerModules(modules) {
 var violaModule = injections.modules;
 var loop = function ( name ) {
 violaModule[name] || (violaModule[name] = {});
 var moduleFnc = modules[name];
 moduleFnc.forEach(function (fnc) {
                   violaModule[name][fnc.name] = fnc.args;
                   });
 };
 for (var name in modules) loop( name );
 }
 function getModule(name) {
 return injections.modules[name]
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
 if (!id || isUndef(this.taskerMap[id])) {
 console.error(("[receive from native]: 无效 instanceId: " + id));
 }
 this.taskerMap[id].receive(args);
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
 Eventer.prototype.send = function send (method, args, cb) {
 var this$1 = this;
 var cbId;
 if (cb && typeof cb === 'function') {
 cbId = this.__cbId++;
 this.cbMap[cbId] = cb;
 args.push(cbId);
 }
 var __send = function (method, args, cb) {
 var cbId;
 if (cb && typeof cb === 'function') {
 cbId = this$1.__cbId++;
 this$1.cbMap[cbId] = cb;
 args.push(cbId);
 }
 this$1.ownerTasker.sendTask([{
                              module: 'dom',
                              method: method,
                              args: args
                              }]);
 };
 if (!this.__isRegistered && this.registerToTasker()) {
 this.send = __send;
 }
 this.ownerTasker && this.ownerTasker.sendTask([{
                                                module: 'dom',
                                                method: method,
                                                args: args
                                                }]);
 };
 
 function createBody(doc, bodyRef) {
 if ( bodyRef === void 0 ) bodyRef = 'root';
 var body = new Element('body', {}, bodyRef);
 body.role = bodyRef;
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
                this.type = type;
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
                var children = this.children;
                if (children.length) {
                children.forEach(function (child) {
                                 if (!child.ctx) {
                                 child.__setCTX(instance);
                                 }
                                 });
                }
                };
                Element.prototype.setAttr = function setAttr (key, value, isImmediate) {
                var obj;
                if ( isImmediate === void 0 ) isImmediate = false;
                this.attr[key] = value;
                if (isImmediate || this.isNatived) {
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, [
                                                                          this.ref,
                                                                          { attr: ( obj = {}, obj[key] = value, obj ) }
                                                                          ]);
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
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, [
                                                                          this.ref,
                                                                          { attr: attrObj }
                                                                          ]);
                }
                };
                Element.prototype.setStyle = function setStyle (styleObj) {
                if ( styleObj === void 0 ) styleObj = {};
                Object.assign(this.style, styleObj);
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.UPDATE_ELEMENT, [
                                                                          this.ref,
                                                                          { style: styleObj}
                                                                          ]);
                }
                };
                Element.prototype.addChild = function addChild (node, index) {
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.ADD_ELEMENT, [
                                                                       this.ref,
                                                                       node.toJSON(),
                                                                       index
                                                                       ]);
                node.setInNative();
                }
                };
                Element.prototype.moveChild = function moveChild (ref, index) {
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.MOVE_ELEMENT, [
                                                                        this.ref,
                                                                        ref,
                                                                        index
                                                                        ]);
                }
                };
                Element.prototype.appendChild = function appendChild (node, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (node === this.children[this.children.length - 1]) { return node }
                var index = -1;
                resetNode (node);
                append(this, node, this.children);
                if (node.isNatived) {
                this.moveChild(node.ref, index);
                } else {
                this.addChild(node, index);
                }
                node.__setCTX(this.ctx);
                return node
                };
                Element.prototype.insertBefore = function insertBefore$$1 (node, refNode, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (refNode.previousSibling === node) { return this.children.indexOf(node) }
                if (!isChild(this, refNode)) {
                console.error('reference node isn\'t in this node');
                }
                resetNode(node);
                var index = insertBefore(node, refNode, this.children);
                if (node.isNatived) {
                this.moveChild(node.ref, index);
                } else {
                this.addChild(node, index);
                }
                node.__setCTX(this.ctx);
                return index
                };
                Element.prototype.insertAfter = function insertAfter$$1 (node, refNode, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (refNode.nextSibling === node) { return this.children.indexOf(node) }
                if (!isChild(this, refNode)) {
                return console.error('reference node isn\'t in this node')
                }
                resetNode(node);
                var index = insertAfter(node, refNode, this.children);
                if (node.isNatived) {
                this.moveChild(node.ref, index);
                } else {
                this.addChild(node, index);
                }
                node.__setCTX(this.ctx);
                };
                Element.prototype.removeChild = function removeChild (node, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = false;
                if (isChild(this, node)) {
                remove(node);
                if (this.isNatived) {
                this.eventer && this.eventer.send(ACTION.REMOVE_ELEMENT, [
                                                                          node.ref
                                                                          ]);
                node.outNative();
                }
                return node
                } else {
                console.error('error in removeChild: the child is not in this node');
                return null
                }
                };
                Element.prototype.render = function render () {
                };
                Element.prototype.on = function on (type, fnc, isImmediate) {
                if ( isImmediate === void 0 ) isImmediate = true;
                return (typeof fnc === 'function')
                ? this.eventer.addEvent(type, fnc, (this.isNatived))
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
 
 var TextNode = (function (Element$$1) {
                 function TextNode (text) {
                 Element$$1.call(this);
                 this.text = text;
                 this.attr.value = text;
                 this.nodeType = NodeType.TEXT_NODE;
                 this.type = 'text';
                 }
                 if ( Element$$1 ) TextNode.__proto__ = Element$$1;
                 TextNode.prototype = Object.create( Element$$1 && Element$$1.prototype );
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
                 }(Element));
 
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
 var el = new Element(type, opts);
 el.__setCTX(this.ctx);
 return el
 };
 Document.prototype.createTextNode = function createTextNode (text) {
 return new TextNode(text)
 };
 Document.prototype.createComment = function createComment () {
 };
 Document.prototype.appendChild = function appendChild (body) {
 if (body instanceof Element) {
 body.role = BODY_REF;
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
 
 var DomModuler$1 = function DomModuler$$1 (id) {
 this.domRegisterMap = {};
 this.ctxId = id;
 };
 DomModuler$1.prototype.register = function register (eventer) {
 this.domRegisterMap[eventer.id] = eventer;
 };
 DomModuler$1.prototype.actEvent = function actEvent (ref, type, event) {
 var el;
 if (el = this.domRegisterMap[ref]) {
 el.emitEvent(type, event);
 } else {
 console.error(("[fireEvent]: 找不到元素 " + ref));
 }
 };
 var callbackId = 1;
 function genCallbackId () {
 return String(callbackId++)
 }
 var Tasker = function Tasker (instanceId) {
 readonlyProp(this, 'id', instanceId);
 this.callbackMap = {};
 this.domModuler = new DomModuler$1(this.id);
 this.receive.bind(this);
 bridge.register(instanceId, this);
 };
 Tasker.prototype.register = function register (type, resolver) {
 console.log('tasker register:', { type: type, resolver: resolver });
 switch (type) {
 case MODULE.DOM:
 this.domModuler.register(resolver);
 return true
 default:
 return false
 }
 };
 Tasker.prototype.genCallback = function genCallback (cb) {
 var cbId = genCallbackId();
 this.callbackMap[cbId] = cb;
 return cbId
 };
 Tasker.prototype.sendNative = function sendNative (instanceId, tasks) {
 };
 Tasker.prototype.moduleTask = function moduleTask (moduleName, method, args) {
 var cb;
 if (typeof (cb = args[args.length - 1]) === 'function') {
 var cbId = this.genCallback(cb);
 args.splice(-1, 1, cbId);
 }
 return this.sendTask([moduleName, method, args])
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
               var ref;
               switch (task.method) {
               case METHOD.CALLBACK:
               this$1.actCallback(task);
               break
               case METHOD.FIRE_EVENT:
               (ref = this$1.domModuler).actEvent.apply(ref, task.args);
               break
               case METHOD.CMP_HOOK:
               default:
               break
               }
               });
 }
 console.log('========== receive End ==========');
 };
 Tasker.prototype.actCallback = function actCallback (task) {
 var args = task.args;
 this.callbackMap[args.shift()].apply(null, args);
 };
 
 var ViolaInstanceMap = {};
 if (typeof ENV !== 'undefined' && ENV === 'web') {
 window.violaInstances = ViolaInstanceMap;
 }
 function registerInstance(instance) {
 if (instance instanceof ViolaInstance) {
 ViolaInstanceMap[instance.getId()] = instance;
 }
 }
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
 this.proxyModule = {};
 registerInstance(this);
 };
 ViolaInstance.prototype.getId = function getId () {
 return this[idProperty]
 };
 ViolaInstance.prototype.requireAPI = function requireAPI (name) {
 var this$1 = this;
 if (this.proxyModule[name]) {
 console.log(((this.getId()) + " 存在已经代理模块: " + name) );
 return this.proxyModule[name]
 }
 var nativeModule = getModule(name);
 if (!nativeModule) {
 console.log('不存在 module： ' + name);
 return {}
 }
 var modules = this.proxyModule[name] = {};
 var loop = function ( method ) {
 Object.defineProperty(modules, method, {
                       enumerable: true,
                       get: function () {
                       return function () {
                       var args = [], len = arguments.length;
                       while ( len-- ) args[ len ] = arguments[ len ];
                       return this$1.tasker.moduleTask(name, method, args);
                       }
                       }
                       });
 };
 for (var method in nativeModule) loop( method );
 return modules
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
 
 var emptyObject = Object.freeze({});
 function isUndef$1 (v) {
 return v === undefined || v === null
 }
 function isDef$1 (v) {
 return v !== undefined && v !== null
 }
 function isTrue (v) {
 return v === true
 }
 function isFalse (v) {
 return v === false
 }
 function isPrimitive (value) {
 return (
         typeof value === 'string' ||
         typeof value === 'number' ||
         typeof value === 'symbol' ||
         typeof value === 'boolean'
         )
 }
 function isObject$1 (obj) {
 return obj !== null && typeof obj === 'object'
 }
 var _toString = Object.prototype.toString;
 function toRawType (value) {
 return _toString.call(value).slice(8, -1)
 }
 function isPlainObject (obj) {
 return _toString.call(obj) === '[object Object]'
 }
 function isRegExp (v) {
 return _toString.call(v) === '[object RegExp]'
 }
 function isValidArrayIndex (val) {
 var n = parseFloat(String(val));
 return n >= 0 && Math.floor(n) === n && isFinite(val)
 }
 function toString$1 (val) {
 return val == null
 ? ''
 : typeof val === 'object'
 ? JSON.stringify(val, null, 2)
 : String(val)
 }
 function toNumber (val) {
 var n = parseFloat(val);
 return isNaN(n) ? val : n
 }
 function makeMap (
                   str,
                   expectsLowerCase
                   ) {
 var map = Object.create(null);
 var list = str.split(',');
 for (var i = 0; i < list.length; i++) {
 map[list[i]] = true;
 }
 return expectsLowerCase
 ? function (val) { return map[val.toLowerCase()]; }
 : function (val) { return map[val]; }
 }
 var isBuiltInTag = makeMap('slot,component', true);
 var isReservedAttribute = makeMap('key,ref,slot,slot-scope,is');
 function remove$1 (arr, item) {
 if (arr.length) {
 var index = arr.indexOf(item);
 if (index > -1) {
 return arr.splice(index, 1)
 }
 }
 }
 var hasOwnProperty = Object.prototype.hasOwnProperty;
 function hasOwn (obj, key) {
 return hasOwnProperty.call(obj, key)
 }
 function cached (fn) {
 var cache = Object.create(null);
 return (function cachedFn (str) {
         var hit = cache[str];
         return hit || (cache[str] = fn(str))
         })
 }
 var camelizeRE = /-(\w)/g;
 var camelize = cached(function (str) {
                       return str.replace(camelizeRE, function (_, c) { return c ? c.toUpperCase() : ''; })
                       });
 var capitalize = cached(function (str) {
                         return str.charAt(0).toUpperCase() + str.slice(1)
                         });
 var hyphenateRE = /\B([A-Z])/g;
 var hyphenate = cached(function (str) {
                        return str.replace(hyphenateRE, '-$1').toLowerCase()
                        });
 function polyfillBind (fn, ctx) {
 function boundFn (a) {
 var l = arguments.length;
 return l
 ? l > 1
 ? fn.apply(ctx, arguments)
 : fn.call(ctx, a)
 : fn.call(ctx)
 }
 boundFn._length = fn.length;
 return boundFn
 }
 function nativeBind (fn, ctx) {
 return fn.bind(ctx)
 }
 var bind = Function.prototype.bind
 ? nativeBind
 : polyfillBind;
 function toArray (list, start) {
 start = start || 0;
 var i = list.length - start;
 var ret = new Array(i);
 while (i--) {
 ret[i] = list[i + start];
 }
 return ret
 }
 function extend (to, _from) {
 for (var key in _from) {
 to[key] = _from[key];
 }
 return to
 }
 function toObject (arr) {
 var res = {};
 for (var i = 0; i < arr.length; i++) {
 if (arr[i]) {
 extend(res, arr[i]);
 }
 }
 return res
 }
 function noop (a, b, c) {}
 var no = function (a, b, c) { return false; };
 var identity = function (_) { return _; };
 function looseEqual (a, b) {
 if (a === b) { return true }
 var isObjectA = isObject$1(a);
 var isObjectB = isObject$1(b);
 if (isObjectA && isObjectB) {
 try {
 var isArrayA = Array.isArray(a);
 var isArrayB = Array.isArray(b);
 if (isArrayA && isArrayB) {
 return a.length === b.length && a.every(function (e, i) {
                                         return looseEqual(e, b[i])
                                         })
 } else if (!isArrayA && !isArrayB) {
 var keysA = Object.keys(a);
 var keysB = Object.keys(b);
 return keysA.length === keysB.length && keysA.every(function (key) {
                                                     return looseEqual(a[key], b[key])
                                                     })
 } else {
 return false
 }
 } catch (e) {
 return false
 }
 } else if (!isObjectA && !isObjectB) {
 return String(a) === String(b)
 } else {
 return false
 }
 }
 function looseIndexOf (arr, val) {
 for (var i = 0; i < arr.length; i++) {
 if (looseEqual(arr[i], val)) { return i }
 }
 return -1
 }
 function once (fn) {
 var called = false;
 return function () {
 if (!called) {
 called = true;
 fn.apply(this, arguments);
 }
 }
 }
 var SSR_ATTR = 'data-server-rendered';
 var ASSET_TYPES = [
                    'component',
                    'directive',
                    'filter'
                    ];
 var LIFECYCLE_HOOKS = [
                        'beforeCreate',
                        'created',
                        'beforeMount',
                        'mounted',
                        'beforeUpdate',
                        'updated',
                        'beforeDestroy',
                        'destroyed',
                        'activated',
                        'deactivated',
                        'errorCaptured'
                        ];
 var config = ({
               optionMergeStrategies: Object.create(null),
               silent: false,
               productionTip: "development" !== 'production',
               devtools: "development" !== 'production',
               performance: false,
               errorHandler: null,
               warnHandler: null,
               ignoredElements: [],
               keyCodes: Object.create(null),
               isReservedTag: no,
               isReservedAttr: no,
               isUnknownElement: no,
               getTagNamespace: noop,
               parsePlatformTagName: identity,
               mustUseProp: no,
               _lifecycleHooks: LIFECYCLE_HOOKS
               });
 function isReserved (str) {
 var c = (str + '').charCodeAt(0);
 return c === 0x24 || c === 0x5F
 }
 function def (obj, key, val, enumerable) {
 Object.defineProperty(obj, key, {
                       value: val,
                       enumerable: !!enumerable,
                       writable: true,
                       configurable: true
                       });
 }
 var bailRE = /[^\w.$]/;
 function parsePath (path) {
 if (bailRE.test(path)) {
 return
 }
 var segments = path.split('.');
 return function (obj) {
 for (var i = 0; i < segments.length; i++) {
 if (!obj) { return }
 obj = obj[segments[i]];
 }
 return obj
 }
 }
 var hasProto = '__proto__' in {};
 var inBrowser = typeof window !== 'undefined';
 var inWeex = typeof WXEnvironment !== 'undefined' && !!WXEnvironment.platform;
 var weexPlatform = inWeex && WXEnvironment.platform.toLowerCase();
 var UA = inBrowser && window.navigator.userAgent.toLowerCase();
 var isIE = UA && /msie|trident/.test(UA);
 var isIE9 = UA && UA.indexOf('msie 9.0') > 0;
 var isEdge = UA && UA.indexOf('edge/') > 0;
 var isAndroid = (UA && UA.indexOf('android') > 0) || (weexPlatform === 'android');
 var isIOS = (UA && /iphone|ipad|ipod|ios/.test(UA)) || (weexPlatform === 'ios');
 var isChrome = UA && /chrome\/\d+/.test(UA) && !isEdge;
 var nativeWatch = ({}).watch;
 if (inBrowser) {
 try {
 var opts = {};
 Object.defineProperty(opts, 'passive', ({
                                         get: function get () {
                                         }
                                         }));
 window.addEventListener('test-passive', null, opts);
 } catch (e) {}
 }
 var _isServer;
 var isServerRendering = function () {
 if (_isServer === undefined) {
 if (!inBrowser && !inWeex && typeof global !== 'undefined') {
 _isServer = global['process'].env.VUE_ENV === 'server';
 } else {
 _isServer = false;
 }
 }
 return _isServer
 };
 var devtools = inBrowser && window.__VUE_DEVTOOLS_GLOBAL_HOOK__;
 function isNative (Ctor) {
 return typeof Ctor === 'function' && /native code/.test(Ctor.toString())
 }
 var hasSymbol =
 typeof Symbol !== 'undefined' && isNative(Symbol) &&
 typeof Reflect !== 'undefined' && isNative(Reflect.ownKeys);
 var _Set;
 if (typeof Set !== 'undefined' && isNative(Set)) {
 _Set = Set;
 } else {
 _Set = (function () {
         function Set () {
         this.set = Object.create(null);
         }
         Set.prototype.has = function has (key) {
         return this.set[key] === true
         };
         Set.prototype.add = function add (key) {
         this.set[key] = true;
         };
         Set.prototype.clear = function clear () {
         this.set = Object.create(null);
         };
         return Set;
         }());
 }
 var warn = noop;
 var tip = noop;
 var generateComponentTrace = (noop);
 var formatComponentName = (noop);
 {
 var hasConsole = typeof console !== 'undefined';
 var classifyRE = /(?:^|[-_])(\w)/g;
 var classify = function (str) { return str
 .replace(classifyRE, function (c) { return c.toUpperCase(); })
 .replace(/[-_]/g, ''); };
 warn = function (msg, vm) {
 var trace = vm ? generateComponentTrace(vm) : '';
 if (config.warnHandler) {
 config.warnHandler.call(null, msg, vm, trace);
 } else if (hasConsole && (!config.silent)) {
 console.error(("[Vue warn]: " + msg + trace));
 }
 };
 tip = function (msg, vm) {
 if (hasConsole && (!config.silent)) {
 console.warn("[Vue tip]: " + msg + (
                                     vm ? generateComponentTrace(vm) : ''
                                     ));
 }
 };
 formatComponentName = function (vm, includeFile) {
 if (vm.$root === vm) {
 return '<Root>'
 }
 var options = typeof vm === 'function' && vm.cid != null
 ? vm.options
 : vm._isVue
 ? vm.$options || vm.constructor.options
 : vm || {};
 var name = options.name || options._componentTag;
 var file = options.__file;
 if (!name && file) {
 var match = file.match(/([^/\\]+)\.vue$/);
 name = match && match[1];
 }
 return (
         (name ? ("<" + (classify(name)) + ">") : "<Anonymous>") +
         (file && includeFile !== false ? (" at " + file) : '')
         )
 };
 var repeat = function (str, n) {
 var res = '';
 while (n) {
 if (n % 2 === 1) { res += str; }
 if (n > 1) { str += str; }
 n >>= 1;
 }
 return res
 };
 generateComponentTrace = function (vm) {
 if (vm._isVue && vm.$parent) {
 var tree = [];
 var currentRecursiveSequence = 0;
 while (vm) {
 if (tree.length > 0) {
 var last = tree[tree.length - 1];
 if (last.constructor === vm.constructor) {
 currentRecursiveSequence++;
 vm = vm.$parent;
 continue
 } else if (currentRecursiveSequence > 0) {
 tree[tree.length - 1] = [last, currentRecursiveSequence];
 currentRecursiveSequence = 0;
 }
 }
 tree.push(vm);
 vm = vm.$parent;
 }
 return '\n\nfound in\n\n' + tree
 .map(function (vm, i) { return ("" + (i === 0 ? '---> ' : repeat(' ', 5 + i * 2)) + (Array.isArray(vm)
                                                                                      ? ((formatComponentName(vm[0])) + "... (" + (vm[1]) + " recursive calls)")
                                                                                      : formatComponentName(vm))); })
 .join('\n')
 } else {
 return ("\n\n(found in " + (formatComponentName(vm)) + ")")
 }
 };
 }
 var uid = 0;
 var Dep = function Dep () {
 this.id = uid++;
 this.subs = [];
 };
 Dep.prototype.addSub = function addSub (sub) {
 this.subs.push(sub);
 };
 Dep.prototype.removeSub = function removeSub (sub) {
 remove$1(this.subs, sub);
 };
 Dep.prototype.depend = function depend () {
 if (Dep.target) {
 Dep.target.addDep(this);
 }
 };
 Dep.prototype.notify = function notify () {
 var subs = this.subs.slice();
 for (var i = 0, l = subs.length; i < l; i++) {
 subs[i].update();
 }
 };
 Dep.target = null;
 var targetStack = [];
 function pushTarget (_target) {
 if (Dep.target) { targetStack.push(Dep.target); }
 Dep.target = _target;
 }
 function popTarget () {
 Dep.target = targetStack.pop();
 }
 var VNode = function VNode (
                             tag,
                             data,
                             children,
                             text,
                             elm,
                             context,
                             componentOptions,
                             asyncFactory
                             ) {
 this.tag = tag;
 this.data = data;
 this.children = children;
 this.text = text;
 this.elm = elm;
 this.ns = undefined;
 this.context = context;
 this.fnContext = undefined;
 this.fnOptions = undefined;
 this.fnScopeId = undefined;
 this.key = data && data.key;
 this.componentOptions = componentOptions;
 this.componentInstance = undefined;
 this.parent = undefined;
 this.raw = false;
 this.isStatic = false;
 this.isRootInsert = true;
 this.isComment = false;
 this.isCloned = false;
 this.isOnce = false;
 this.asyncFactory = asyncFactory;
 this.asyncMeta = undefined;
 this.isAsyncPlaceholder = false;
 };
 var prototypeAccessors = { child: { configurable: true } };
 prototypeAccessors.child.get = function () {
 return this.componentInstance
 };
 Object.defineProperties( VNode.prototype, prototypeAccessors );
 var createEmptyVNode = function (text) {
 if ( text === void 0 ) text = '';
 var node = new VNode();
 node.text = text;
 node.isComment = true;
 return node
 };
 function createTextVNode (val) {
 return new VNode(undefined, undefined, undefined, String(val))
 }
 function cloneVNode (vnode) {
 var cloned = new VNode(
                        vnode.tag,
                        vnode.data,
                        vnode.children,
                        vnode.text,
                        vnode.elm,
                        vnode.context,
                        vnode.componentOptions,
                        vnode.asyncFactory
                        );
 cloned.ns = vnode.ns;
 cloned.isStatic = vnode.isStatic;
 cloned.key = vnode.key;
 cloned.isComment = vnode.isComment;
 cloned.fnContext = vnode.fnContext;
 cloned.fnOptions = vnode.fnOptions;
 cloned.fnScopeId = vnode.fnScopeId;
 cloned.asyncMeta = vnode.asyncMeta;
 cloned.isCloned = true;
 return cloned
 }
 var arrayProto = Array.prototype;
 var arrayMethods = Object.create(arrayProto);
 var methodsToPatch = [
                       'push',
                       'pop',
                       'shift',
                       'unshift',
                       'splice',
                       'sort',
                       'reverse'
                       ];
 methodsToPatch.forEach(function (method) {
                        var original = arrayProto[method];
                        def(arrayMethods, method, function mutator () {
                            var args = [], len = arguments.length;
                            while ( len-- ) args[ len ] = arguments[ len ];
                            var result = original.apply(this, args);
                            var ob = this.__ob__;
                            var inserted;
                            switch (method) {
                            case 'push':
                            case 'unshift':
                            inserted = args;
                            break
                            case 'splice':
                            inserted = args.slice(2);
                            break
                            }
                            if (inserted) { ob.observeArray(inserted); }
                            ob.dep.notify();
                            return result
                            });
                        });
 var arrayKeys = Object.getOwnPropertyNames(arrayMethods);
 var shouldObserve = true;
 function toggleObserving (value) {
 shouldObserve = value;
 }
 var Observer = function Observer (value) {
 this.value = value;
 this.dep = new Dep();
 this.vmCount = 0;
 def(value, '__ob__', this);
 if (Array.isArray(value)) {
 var augment = hasProto
 ? protoAugment
 : copyAugment;
 augment(value, arrayMethods, arrayKeys);
 this.observeArray(value);
 } else {
 this.walk(value);
 }
 };
 Observer.prototype.walk = function walk (obj) {
 var keys = Object.keys(obj);
 for (var i = 0; i < keys.length; i++) {
 defineReactive(obj, keys[i]);
 }
 };
 Observer.prototype.observeArray = function observeArray (items) {
 for (var i = 0, l = items.length; i < l; i++) {
 observe(items[i]);
 }
 };
 function protoAugment (target, src, keys) {
 target.__proto__ = src;
 }
 function copyAugment (target, src, keys) {
 for (var i = 0, l = keys.length; i < l; i++) {
 var key = keys[i];
 def(target, key, src[key]);
 }
 }
 function observe (value, asRootData) {
 if (!isObject$1(value) || value instanceof VNode) {
 return
 }
 var ob;
 if (hasOwn(value, '__ob__') && value.__ob__ instanceof Observer) {
 ob = value.__ob__;
 } else if (
            shouldObserve &&
            !isServerRendering() &&
            (Array.isArray(value) || isPlainObject(value)) &&
            Object.isExtensible(value) &&
            !value._isVue
            ) {
 ob = new Observer(value);
 }
 if (asRootData && ob) {
 ob.vmCount++;
 }
 return ob
 }
 function defineReactive (
                          obj,
                          key,
                          val,
                          customSetter,
                          shallow
                          ) {
 var dep = new Dep();
 var property = Object.getOwnPropertyDescriptor(obj, key);
 if (property && property.configurable === false) {
 return
 }
 var getter = property && property.get;
 var setter = property && property.set;
 if ((!getter || setter) && arguments.length === 2) {
 val = obj[key];
 }
 var childOb = !shallow && observe(val);
 Object.defineProperty(obj, key, {
                       enumerable: true,
                       configurable: true,
                       get: function reactiveGetter () {
                       var value = getter ? getter.call(obj) : val;
                       if (Dep.target) {
                       dep.depend();
                       if (childOb) {
                       childOb.dep.depend();
                       if (Array.isArray(value)) {
                       dependArray(value);
                       }
                       }
                       }
                       return value
                       },
                       set: function reactiveSetter (newVal) {
                       var value = getter ? getter.call(obj) : val;
                       if (newVal === value || (newVal !== newVal && value !== value)) {
                       return
                       }
                       if (customSetter) {
                       customSetter();
                       }
                       if (setter) {
                       setter.call(obj, newVal);
                       } else {
                       val = newVal;
                       }
                       childOb = !shallow && observe(newVal);
                       dep.notify();
                       }
                       });
 }
 function set (target, key, val) {
 if (isUndef$1(target) || isPrimitive(target)
     ) {
 warn(("Cannot set reactive property on undefined, null, or primitive value: " + ((target))));
 }
 if (Array.isArray(target) && isValidArrayIndex(key)) {
 target.length = Math.max(target.length, key);
 target.splice(key, 1, val);
 return val
 }
 if (key in target && !(key in Object.prototype)) {
 target[key] = val;
 return val
 }
 var ob = (target).__ob__;
 if (target._isVue || (ob && ob.vmCount)) {
 warn(
      'Avoid adding reactive properties to a Vue instance or its root $data ' +
      'at runtime - declare it upfront in the data option.'
      );
 return val
 }
 if (!ob) {
 target[key] = val;
 return val
 }
 defineReactive(ob.value, key, val);
 ob.dep.notify();
 return val
 }
 function del (target, key) {
 if (isUndef$1(target) || isPrimitive(target)
     ) {
 warn(("Cannot delete reactive property on undefined, null, or primitive value: " + ((target))));
 }
 if (Array.isArray(target) && isValidArrayIndex(key)) {
 target.splice(key, 1);
 return
 }
 var ob = (target).__ob__;
 if (target._isVue || (ob && ob.vmCount)) {
 warn(
      'Avoid deleting properties on a Vue instance or its root $data ' +
      '- just set it to null.'
      );
 return
 }
 if (!hasOwn(target, key)) {
 return
 }
 delete target[key];
 if (!ob) {
 return
 }
 ob.dep.notify();
 }
 function dependArray (value) {
 for (var e = (void 0), i = 0, l = value.length; i < l; i++) {
 e = value[i];
 e && e.__ob__ && e.__ob__.dep.depend();
 if (Array.isArray(e)) {
 dependArray(e);
 }
 }
 }
 var strats = config.optionMergeStrategies;
 {
 strats.el = strats.propsData = function (parent, child, vm, key) {
 if (!vm) {
 warn(
      "option \"" + key + "\" can only be used during instance " +
      'creation with the `new` keyword.'
      );
 }
 return defaultStrat(parent, child)
 };
 }
 function mergeData (to, from) {
 if (!from) { return to }
 var key, toVal, fromVal;
 var keys = Object.keys(from);
 for (var i = 0; i < keys.length; i++) {
 key = keys[i];
 toVal = to[key];
 fromVal = from[key];
 if (!hasOwn(to, key)) {
 set(to, key, fromVal);
 } else if (isPlainObject(toVal) && isPlainObject(fromVal)) {
 mergeData(toVal, fromVal);
 }
 }
 return to
 }
 function mergeDataOrFn (
                         parentVal,
                         childVal,
                         vm
                         ) {
 if (!vm) {
 if (!childVal) {
 return parentVal
 }
 if (!parentVal) {
 return childVal
 }
 return function mergedDataFn () {
 return mergeData(
                  typeof childVal === 'function' ? childVal.call(this, this) : childVal,
                  typeof parentVal === 'function' ? parentVal.call(this, this) : parentVal
                  )
 }
 } else {
 return function mergedInstanceDataFn () {
 var instanceData = typeof childVal === 'function'
 ? childVal.call(vm, vm)
 : childVal;
 var defaultData = typeof parentVal === 'function'
 ? parentVal.call(vm, vm)
 : parentVal;
 if (instanceData) {
 return mergeData(instanceData, defaultData)
 } else {
 return defaultData
 }
 }
 }
 }
 strats.data = function (
                         parentVal,
                         childVal,
                         vm
                         ) {
 if (!vm) {
 if (childVal && typeof childVal !== 'function') {
 warn(
      'The "data" option should be a function ' +
      'that returns a per-instance value in component ' +
      'definitions.',
      vm
      );
 return parentVal
 }
 return mergeDataOrFn(parentVal, childVal)
 }
 return mergeDataOrFn(parentVal, childVal, vm)
 };
 function mergeHook (
                     parentVal,
                     childVal
                     ) {
 return childVal
 ? parentVal
 ? parentVal.concat(childVal)
 : Array.isArray(childVal)
 ? childVal
 : [childVal]
 : parentVal
 }
 LIFECYCLE_HOOKS.forEach(function (hook) {
                         strats[hook] = mergeHook;
                         });
 function mergeAssets (
                       parentVal,
                       childVal,
                       vm,
                       key
                       ) {
 var res = Object.create(parentVal || null);
 if (childVal) {
 assertObjectType(key, childVal, vm);
 return extend(res, childVal)
 } else {
 return res
 }
 }
 ASSET_TYPES.forEach(function (type) {
                     strats[type + 's'] = mergeAssets;
                     });
 strats.watch = function (
                          parentVal,
                          childVal,
                          vm,
                          key
                          ) {
 if (parentVal === nativeWatch) { parentVal = undefined; }
 if (childVal === nativeWatch) { childVal = undefined; }
 if (!childVal) { return Object.create(parentVal || null) }
 {
 assertObjectType(key, childVal, vm);
 }
 if (!parentVal) { return childVal }
 var ret = {};
 extend(ret, parentVal);
 for (var key$1 in childVal) {
 var parent = ret[key$1];
 var child = childVal[key$1];
 if (parent && !Array.isArray(parent)) {
 parent = [parent];
 }
 ret[key$1] = parent
 ? parent.concat(child)
 : Array.isArray(child) ? child : [child];
 }
 return ret
 };
 strats.props =
 strats.methods =
 strats.inject =
 strats.computed = function (
                             parentVal,
                             childVal,
                             vm,
                             key
                             ) {
 if (childVal && "development" !== 'production') {
 assertObjectType(key, childVal, vm);
 }
 if (!parentVal) { return childVal }
 var ret = Object.create(null);
 extend(ret, parentVal);
 if (childVal) { extend(ret, childVal); }
 return ret
 };
 strats.provide = mergeDataOrFn;
 var defaultStrat = function (parentVal, childVal) {
 return childVal === undefined
 ? parentVal
 : childVal
 };
 function checkComponents (options) {
 for (var key in options.components) {
 validateComponentName(key);
 }
 }
 function validateComponentName (name) {
 if (!/^[a-zA-Z][\w-]*$/.test(name)) {
 warn(
      'Invalid component name: "' + name + '". Component names ' +
      'can only contain alphanumeric characters and the hyphen, ' +
      'and must start with a letter.'
      );
 }
 if (isBuiltInTag(name) || config.isReservedTag(name)) {
 warn(
      'Do not use built-in or reserved HTML elements as component ' +
      'id: ' + name
      );
 }
 }
 function normalizeProps (options, vm) {
 var props = options.props;
 if (!props) { return }
 var res = {};
 var i, val, name;
 if (Array.isArray(props)) {
 i = props.length;
 while (i--) {
 val = props[i];
 if (typeof val === 'string') {
 name = camelize(val);
 res[name] = { type: null };
 } else {
 warn('props must be strings when using array syntax.');
 }
 }
 } else if (isPlainObject(props)) {
 for (var key in props) {
 val = props[key];
 name = camelize(key);
 res[name] = isPlainObject(val)
 ? val
 : { type: val };
 }
 } else {
 warn(
      "Invalid value for option \"props\": expected an Array or an Object, " +
      "but got " + (toRawType(props)) + ".",
      vm
      );
 }
 options.props = res;
 }
 function normalizeInject (options, vm) {
 var inject = options.inject;
 if (!inject) { return }
 var normalized = options.inject = {};
 if (Array.isArray(inject)) {
 for (var i = 0; i < inject.length; i++) {
 normalized[inject[i]] = { from: inject[i] };
 }
 } else if (isPlainObject(inject)) {
 for (var key in inject) {
 var val = inject[key];
 normalized[key] = isPlainObject(val)
 ? extend({ from: key }, val)
 : { from: val };
 }
 } else {
 warn(
      "Invalid value for option \"inject\": expected an Array or an Object, " +
      "but got " + (toRawType(inject)) + ".",
      vm
      );
 }
 }
 function normalizeDirectives (options) {
 var dirs = options.directives;
 if (dirs) {
 for (var key in dirs) {
 var def = dirs[key];
 if (typeof def === 'function') {
 dirs[key] = { bind: def, update: def };
 }
 }
 }
 }
 function assertObjectType (name, value, vm) {
 if (!isPlainObject(value)) {
 warn(
      "Invalid value for option \"" + name + "\": expected an Object, " +
      "but got " + (toRawType(value)) + ".",
      vm
      );
 }
 }
 function mergeOptions (
                        parent,
                        child,
                        vm
                        ) {
 {
 checkComponents(child);
 }
 if (typeof child === 'function') {
 child = child.options;
 }
 normalizeProps(child, vm);
 normalizeInject(child, vm);
 normalizeDirectives(child);
 var extendsFrom = child.extends;
 if (extendsFrom) {
 parent = mergeOptions(parent, extendsFrom, vm);
 }
 if (child.mixins) {
 for (var i = 0, l = child.mixins.length; i < l; i++) {
 parent = mergeOptions(parent, child.mixins[i], vm);
 }
 }
 var options = {};
 var key;
 for (key in parent) {
 mergeField(key);
 }
 for (key in child) {
 if (!hasOwn(parent, key)) {
 mergeField(key);
 }
 }
 function mergeField (key) {
 var strat = strats[key] || defaultStrat;
 options[key] = strat(parent[key], child[key], vm, key);
 }
 return options
 }
 function resolveAsset (
                        options,
                        type,
                        id,
                        warnMissing
                        ) {
 if (typeof id !== 'string') {
 return
 }
 var assets = options[type];
 if (hasOwn(assets, id)) { return assets[id] }
 var camelizedId = camelize(id);
 if (hasOwn(assets, camelizedId)) { return assets[camelizedId] }
 var PascalCaseId = capitalize(camelizedId);
 if (hasOwn(assets, PascalCaseId)) { return assets[PascalCaseId] }
 var res = assets[id] || assets[camelizedId] || assets[PascalCaseId];
 if (warnMissing && !res) {
 warn(
      'Failed to resolve ' + type.slice(0, -1) + ': ' + id,
      options
      );
 }
 return res
 }
 function validateProp (
                        key,
                        propOptions,
                        propsData,
                        vm
                        ) {
 var prop = propOptions[key];
 var absent = !hasOwn(propsData, key);
 var value = propsData[key];
 var booleanIndex = getTypeIndex(Boolean, prop.type);
 if (booleanIndex > -1) {
 if (absent && !hasOwn(prop, 'default')) {
 value = false;
 } else if (value === '' || value === hyphenate(key)) {
 var stringIndex = getTypeIndex(String, prop.type);
 if (stringIndex < 0 || booleanIndex < stringIndex) {
 value = true;
 }
 }
 }
 if (value === undefined) {
 value = getPropDefaultValue(vm, prop, key);
 var prevShouldObserve = shouldObserve;
 toggleObserving(true);
 observe(value);
 toggleObserving(prevShouldObserve);
 }
 {
 assertProp(prop, key, value, vm, absent);
 }
 return value
 }
 function getPropDefaultValue (vm, prop, key) {
 if (!hasOwn(prop, 'default')) {
 return undefined
 }
 var def = prop.default;
 if (isObject$1(def)) {
 warn(
      'Invalid default value for prop "' + key + '": ' +
      'Props with type Object/Array must use a factory function ' +
      'to return the default value.',
      vm
      );
 }
 if (vm && vm.$options.propsData &&
     vm.$options.propsData[key] === undefined &&
     vm._props[key] !== undefined
     ) {
 return vm._props[key]
 }
 return typeof def === 'function' && getType$1(prop.type) !== 'Function'
 ? def.call(vm)
 : def
 }
 function assertProp (
                      prop,
                      name,
                      value,
                      vm,
                      absent
                      ) {
 if (prop.required && absent) {
 warn(
      'Missing required prop: "' + name + '"',
      vm
      );
 return
 }
 if (value == null && !prop.required) {
 return
 }
 var type = prop.type;
 var valid = !type || type === true;
 var expectedTypes = [];
 if (type) {
 if (!Array.isArray(type)) {
 type = [type];
 }
 for (var i = 0; i < type.length && !valid; i++) {
 var assertedType = assertType(value, type[i]);
 expectedTypes.push(assertedType.expectedType || '');
 valid = assertedType.valid;
 }
 }
 if (!valid) {
 warn(
      "Invalid prop: type check failed for prop \"" + name + "\"." +
      " Expected " + (expectedTypes.map(capitalize).join(', ')) +
      ", got " + (toRawType(value)) + ".",
      vm
      );
 return
 }
 var validator = prop.validator;
 if (validator) {
 if (!validator(value)) {
 warn(
      'Invalid prop: custom validator check failed for prop "' + name + '".',
      vm
      );
 }
 }
 }
 var simpleCheckRE = /^(String|Number|Boolean|Function|Symbol)$/;
 function assertType (value, type) {
 var valid;
 var expectedType = getType$1(type);
 if (simpleCheckRE.test(expectedType)) {
 var t = typeof value;
 valid = t === expectedType.toLowerCase();
 if (!valid && t === 'object') {
 valid = value instanceof type;
 }
 } else if (expectedType === 'Object') {
 valid = isPlainObject(value);
 } else if (expectedType === 'Array') {
 valid = Array.isArray(value);
 } else {
 valid = value instanceof type;
 }
 return {
 valid: valid,
 expectedType: expectedType
 }
 }
 function getType$1 (fn) {
 var match = fn && fn.toString().match(/^\s*function (\w+)/);
 return match ? match[1] : ''
 }
 function isSameType (a, b) {
 return getType$1(a) === getType$1(b)
 }
 function getTypeIndex (type, expectedTypes) {
 if (!Array.isArray(expectedTypes)) {
 return isSameType(expectedTypes, type) ? 0 : -1
 }
 for (var i = 0, len = expectedTypes.length; i < len; i++) {
 if (isSameType(expectedTypes[i], type)) {
 return i
 }
 }
 return -1
 }
 function handleError (err, vm, info) {
 if (vm) {
 var cur = vm;
 while ((cur = cur.$parent)) {
 var hooks = cur.$options.errorCaptured;
 if (hooks) {
 for (var i = 0; i < hooks.length; i++) {
 try {
 var capture = hooks[i].call(cur, err, vm, info) === false;
 if (capture) { return }
 } catch (e) {
 globalHandleError(e, cur, 'errorCaptured hook');
 }
 }
 }
 }
 }
 globalHandleError(err, vm, info);
 }
 function globalHandleError (err, vm, info) {
 if (config.errorHandler) {
 try {
 return config.errorHandler.call(null, err, vm, info)
 } catch (e) {
 logError(e, null, 'config.errorHandler');
 }
 }
 logError(err, vm, info);
 }
 function logError (err, vm, info) {
 {
 warn(("Error in " + info + ": \"" + (err.toString()) + "\""), vm);
 }
 if ((inBrowser || inWeex) && typeof console !== 'undefined') {
 console.error(err);
 } else {
 throw err
 }
 }
 var callbacks = [];
 var pending = false;
 function flushCallbacks () {
 pending = false;
 var copies = callbacks.slice(0);
 callbacks.length = 0;
 for (var i = 0; i < copies.length; i++) {
 copies[i]();
 }
 }
 var microTimerFunc;
 var macroTimerFunc;
 var useMacroTask = false;
 if (typeof setImmediate !== 'undefined' && isNative(setImmediate)) {
 macroTimerFunc = function () {
 setImmediate(flushCallbacks);
 };
 } else if (typeof MessageChannel !== 'undefined' && (
                                                      isNative(MessageChannel) ||
                                                      MessageChannel.toString() === '[object MessageChannelConstructor]'
                                                      )) {
 var channel = new MessageChannel();
 var port = channel.port2;
 channel.port1.onmessage = flushCallbacks;
 macroTimerFunc = function () {
 port.postMessage(1);
 };
 } else {
 macroTimerFunc = function () {
 setTimeout(flushCallbacks, 0);
 };
 }
 if (typeof Promise !== 'undefined' && isNative(Promise)) {
 var p = Promise.resolve();
 microTimerFunc = function () {
 p.then(flushCallbacks);
 if (isIOS) { setTimeout(noop); }
 };
 } else {
 microTimerFunc = macroTimerFunc;
 }
 function nextTick (cb, ctx) {
 var _resolve;
 callbacks.push(function () {
                if (cb) {
                try {
                cb.call(ctx);
                } catch (e) {
                handleError(e, ctx, 'nextTick');
                }
                } else if (_resolve) {
                _resolve(ctx);
                }
                });
 if (!pending) {
 pending = true;
 if (useMacroTask) {
 macroTimerFunc();
 } else {
 microTimerFunc();
 }
 }
 if (!cb && typeof Promise !== 'undefined') {
 return new Promise(function (resolve) {
                    _resolve = resolve;
                    })
 }
 }
 var initProxy;
 {
 var allowedGlobals = makeMap(
                              'Infinity,undefined,NaN,isFinite,isNaN,' +
                              'parseFloat,parseInt,decodeURI,decodeURIComponent,encodeURI,encodeURIComponent,' +
                              'Math,Number,Date,Array,Object,Boolean,String,RegExp,Map,Set,JSON,Intl,' +
                              'require'
                              );
 var warnNonPresent = function (target, key) {
 warn(
      "Property or method \"" + key + "\" is not defined on the instance but " +
      'referenced during render. Make sure that this property is reactive, ' +
      'either in the data option, or for class-based components, by ' +
      'initializing the property. ' +
      'See: https://vuejs.org/v2/guide/reactivity.html#Declaring-Reactive-Properties.',
      target
      );
 };
 var hasProxy =
 typeof Proxy !== 'undefined' && isNative(Proxy);
 if (hasProxy) {
 var isBuiltInModifier = makeMap('stop,prevent,self,ctrl,shift,alt,meta,exact');
 config.keyCodes = new Proxy(config.keyCodes, {
                             set: function set (target, key, value) {
                             if (isBuiltInModifier(key)) {
                             warn(("Avoid overwriting built-in modifier in config.keyCodes: ." + key));
                             return false
                             } else {
                             target[key] = value;
                             return true
                             }
                             }
                             });
 }
 var hasHandler = {
 has: function has (target, key) {
 var has = key in target;
 var isAllowed = allowedGlobals(key) || (typeof key === 'string' && key.charAt(0) === '_');
 if (!has && !isAllowed) {
 warnNonPresent(target, key);
 }
 return has || !isAllowed
 }
 };
 var getHandler = {
 get: function get (target, key) {
 if (typeof key === 'string' && !(key in target)) {
 warnNonPresent(target, key);
 }
 return target[key]
 }
 };
 initProxy = function initProxy (vm) {
 if (hasProxy) {
 var options = vm.$options;
 var handlers = options.render && options.render._withStripped
 ? getHandler
 : hasHandler;
 vm._renderProxy = new Proxy(vm, handlers);
 } else {
 vm._renderProxy = vm;
 }
 };
 }
 var seenObjects = new _Set();
 function traverse (val) {
 _traverse(val, seenObjects);
 seenObjects.clear();
 }
 function _traverse (val, seen) {
 var i, keys;
 var isA = Array.isArray(val);
 if ((!isA && !isObject$1(val)) || Object.isFrozen(val) || val instanceof VNode) {
 return
 }
 if (val.__ob__) {
 var depId = val.__ob__.dep.id;
 if (seen.has(depId)) {
 return
 }
 seen.add(depId);
 }
 if (isA) {
 i = val.length;
 while (i--) { _traverse(val[i], seen); }
 } else {
 keys = Object.keys(val);
 i = keys.length;
 while (i--) { _traverse(val[keys[i]], seen); }
 }
 }
 var mark;
 var measure;
 {
 var perf = inBrowser && window.performance;
 if (
     perf &&
     perf.mark &&
     perf.measure &&
     perf.clearMarks &&
     perf.clearMeasures
     ) {
 mark = function (tag) { return perf.mark(tag); };
 measure = function (name, startTag, endTag) {
 perf.measure(name, startTag, endTag);
 perf.clearMarks(startTag);
 perf.clearMarks(endTag);
 perf.clearMeasures(name);
 };
 }
 }
 var normalizeEvent = cached(function (name) {
                             var passive = name.charAt(0) === '&';
                             name = passive ? name.slice(1) : name;
                             var once$$1 = name.charAt(0) === '~';
                             name = once$$1 ? name.slice(1) : name;
                             var capture = name.charAt(0) === '!';
                             name = capture ? name.slice(1) : name;
                             return {
                             name: name,
                             once: once$$1,
                             capture: capture,
                             passive: passive
                             }
                             });
 function createFnInvoker (fns) {
 function invoker () {
 var arguments$1 = arguments;
 var fns = invoker.fns;
 if (Array.isArray(fns)) {
 var cloned = fns.slice();
 for (var i = 0; i < cloned.length; i++) {
 cloned[i].apply(null, arguments$1);
 }
 } else {
 return fns.apply(null, arguments)
 }
 }
 invoker.fns = fns;
 return invoker
 }
 function updateListeners (
                           on,
                           oldOn,
                           add,
                           remove$$1,
                           vm
                           ) {
 var name, def, cur, old, event;
 for (name in on) {
 def = cur = on[name];
 old = oldOn[name];
 event = normalizeEvent(name);
 if (isUndef$1(cur)) {
 warn(
      "Invalid handler for event \"" + (event.name) + "\": got " + String(cur),
      vm
      );
 } else if (isUndef$1(old)) {
 if (isUndef$1(cur.fns)) {
 cur = on[name] = createFnInvoker(cur);
 }
 add(event.name, cur, event.once, event.capture, event.passive, event.params);
 } else if (cur !== old) {
 old.fns = cur;
 on[name] = old;
 }
 }
 for (name in oldOn) {
 if (isUndef$1(on[name])) {
 event = normalizeEvent(name);
 remove$$1(event.name, oldOn[name], event.capture);
 }
 }
 }
 function mergeVNodeHook (def, hookKey, hook) {
 if (def instanceof VNode) {
 def = def.data.hook || (def.data.hook = {});
 }
 var invoker;
 var oldHook = def[hookKey];
 function wrappedHook () {
 hook.apply(this, arguments);
 remove$1(invoker.fns, wrappedHook);
 }
 if (isUndef$1(oldHook)) {
 invoker = createFnInvoker([wrappedHook]);
 } else {
 if (isDef$1(oldHook.fns) && isTrue(oldHook.merged)) {
 invoker = oldHook;
 invoker.fns.push(wrappedHook);
 } else {
 invoker = createFnInvoker([oldHook, wrappedHook]);
 }
 }
 invoker.merged = true;
 def[hookKey] = invoker;
 }
 function extractPropsFromVNodeData (
                                     data,
                                     Ctor,
                                     tag
                                     ) {
 var propOptions = Ctor.options.props;
 if (isUndef$1(propOptions)) {
 return
 }
 var res = {};
 var attrs = data.attrs;
 var props = data.props;
 if (isDef$1(attrs) || isDef$1(props)) {
 for (var key in propOptions) {
 var altKey = hyphenate(key);
 {
 var keyInLowerCase = key.toLowerCase();
 if (
     key !== keyInLowerCase &&
     attrs && hasOwn(attrs, keyInLowerCase)
     ) {
 tip(
     "Prop \"" + keyInLowerCase + "\" is passed to component " +
     (formatComponentName(tag || Ctor)) + ", but the declared prop name is" +
     " \"" + key + "\". " +
     "Note that HTML attributes are case-insensitive and camelCased " +
     "props need to use their kebab-case equivalents when using in-DOM " +
     "templates. You should probably use \"" + altKey + "\" instead of \"" + key + "\"."
     );
 }
 }
 checkProp(res, props, key, altKey, true) ||
 checkProp(res, attrs, key, altKey, false);
 }
 }
 return res
 }
 function checkProp (
                     res,
                     hash,
                     key,
                     altKey,
                     preserve
                     ) {
 if (isDef$1(hash)) {
 if (hasOwn(hash, key)) {
 res[key] = hash[key];
 if (!preserve) {
 delete hash[key];
 }
 return true
 } else if (hasOwn(hash, altKey)) {
 res[key] = hash[altKey];
 if (!preserve) {
 delete hash[altKey];
 }
 return true
 }
 }
 return false
 }
 function simpleNormalizeChildren (children) {
 for (var i = 0; i < children.length; i++) {
 if (Array.isArray(children[i])) {
 return Array.prototype.concat.apply([], children)
 }
 }
 return children
 }
 function normalizeChildren (children) {
 return isPrimitive(children)
 ? [createTextVNode(children)]
 : Array.isArray(children)
 ? normalizeArrayChildren(children)
 : undefined
 }
 function isTextNode (node) {
 return isDef$1(node) && isDef$1(node.text) && isFalse(node.isComment)
 }
 function normalizeArrayChildren (children, nestedIndex) {
 var res = [];
 var i, c, lastIndex, last;
 for (i = 0; i < children.length; i++) {
 c = children[i];
 if (isUndef$1(c) || typeof c === 'boolean') { continue }
 lastIndex = res.length - 1;
 last = res[lastIndex];
 if (Array.isArray(c)) {
 if (c.length > 0) {
 c = normalizeArrayChildren(c, ((nestedIndex || '') + "_" + i));
 if (isTextNode(c[0]) && isTextNode(last)) {
 res[lastIndex] = createTextVNode(last.text + (c[0]).text);
 c.shift();
 }
 res.push.apply(res, c);
 }
 } else if (isPrimitive(c)) {
 if (isTextNode(last)) {
 res[lastIndex] = createTextVNode(last.text + c);
 } else if (c !== '') {
 res.push(createTextVNode(c));
 }
 } else {
 if (isTextNode(c) && isTextNode(last)) {
 res[lastIndex] = createTextVNode(last.text + c.text);
 } else {
 if (isTrue(children._isVList) &&
     isDef$1(c.tag) &&
     isUndef$1(c.key) &&
     isDef$1(nestedIndex)) {
 c.key = "__vlist" + nestedIndex + "_" + i + "__";
 }
 res.push(c);
 }
 }
 }
 return res
 }
 function ensureCtor (comp, base) {
 if (
     comp.__esModule ||
     (hasSymbol && comp[Symbol.toStringTag] === 'Module')
     ) {
 comp = comp.default;
 }
 return isObject$1(comp)
 ? base.extend(comp)
 : comp
 }
 function createAsyncPlaceholder (
                                  factory,
                                  data,
                                  context,
                                  children,
                                  tag
                                  ) {
 var node = createEmptyVNode();
 node.asyncFactory = factory;
 node.asyncMeta = { data: data, context: context, children: children, tag: tag };
 return node
 }
 function resolveAsyncComponent (
                                 factory,
                                 baseCtor,
                                 context
                                 ) {
 if (isTrue(factory.error) && isDef$1(factory.errorComp)) {
 return factory.errorComp
 }
 if (isDef$1(factory.resolved)) {
 return factory.resolved
 }
 if (isTrue(factory.loading) && isDef$1(factory.loadingComp)) {
 return factory.loadingComp
 }
 if (isDef$1(factory.contexts)) {
 factory.contexts.push(context);
 } else {
 var contexts = factory.contexts = [context];
 var sync = true;
 var forceRender = function () {
 for (var i = 0, l = contexts.length; i < l; i++) {
 contexts[i].$forceUpdate();
 }
 };
 var resolve = once(function (res) {
                    factory.resolved = ensureCtor(res, baseCtor);
                    if (!sync) {
                    forceRender();
                    }
                    });
 var reject = once(function (reason) {
                   warn(
                        "Failed to resolve async component: " + (String(factory)) +
                        (reason ? ("\nReason: " + reason) : '')
                        );
                   if (isDef$1(factory.errorComp)) {
                   factory.error = true;
                   forceRender();
                   }
                   });
 var res = factory(resolve, reject);
 if (isObject$1(res)) {
 if (typeof res.then === 'function') {
 if (isUndef$1(factory.resolved)) {
 res.then(resolve, reject);
 }
 } else if (isDef$1(res.component) && typeof res.component.then === 'function') {
 res.component.then(resolve, reject);
 if (isDef$1(res.error)) {
 factory.errorComp = ensureCtor(res.error, baseCtor);
 }
 if (isDef$1(res.loading)) {
 factory.loadingComp = ensureCtor(res.loading, baseCtor);
 if (res.delay === 0) {
 factory.loading = true;
 } else {
 setTimeout(function () {
            if (isUndef$1(factory.resolved) && isUndef$1(factory.error)) {
            factory.loading = true;
            forceRender();
            }
            }, res.delay || 200);
 }
 }
 if (isDef$1(res.timeout)) {
 setTimeout(function () {
            if (isUndef$1(factory.resolved)) {
            reject(
                   "timeout (" + (res.timeout) + "ms)"
                   );
            }
            }, res.timeout);
 }
 }
 }
 sync = false;
 return factory.loading
 ? factory.loadingComp
 : factory.resolved
 }
 }
 function isAsyncPlaceholder (node) {
 return node.isComment && node.asyncFactory
 }
 function getFirstComponentChild (children) {
 if (Array.isArray(children)) {
 for (var i = 0; i < children.length; i++) {
 var c = children[i];
 if (isDef$1(c) && (isDef$1(c.componentOptions) || isAsyncPlaceholder(c))) {
 return c
 }
 }
 }
 }
 function initEvents (vm) {
 vm._events = Object.create(null);
 vm._hasHookEvent = false;
 var listeners = vm.$options._parentListeners;
 if (listeners) {
 updateComponentListeners(vm, listeners);
 }
 }
 var target;
 function add (event, fn, once) {
 if (once) {
 target.$once(event, fn);
 } else {
 target.$on(event, fn);
 }
 }
 function remove$1$1 (event, fn) {
 target.$off(event, fn);
 }
 function updateComponentListeners (
                                    vm,
                                    listeners,
                                    oldListeners
                                    ) {
 target = vm;
 updateListeners(listeners, oldListeners || {}, add, remove$1$1, vm);
 target = undefined;
 }
 function eventsMixin (Vue) {
 var hookRE = /^hook:/;
 Vue.prototype.$on = function (event, fn) {
 var this$1 = this;
 var vm = this;
 if (Array.isArray(event)) {
 for (var i = 0, l = event.length; i < l; i++) {
 this$1.$on(event[i], fn);
 }
 } else {
 (vm._events[event] || (vm._events[event] = [])).push(fn);
 if (hookRE.test(event)) {
 vm._hasHookEvent = true;
 }
 }
 return vm
 };
 Vue.prototype.$once = function (event, fn) {
 var vm = this;
 function on () {
 vm.$off(event, on);
 fn.apply(vm, arguments);
 }
 on.fn = fn;
 vm.$on(event, on);
 return vm
 };
 Vue.prototype.$off = function (event, fn) {
 var this$1 = this;
 var vm = this;
 if (!arguments.length) {
 vm._events = Object.create(null);
 return vm
 }
 if (Array.isArray(event)) {
 for (var i = 0, l = event.length; i < l; i++) {
 this$1.$off(event[i], fn);
 }
 return vm
 }
 var cbs = vm._events[event];
 if (!cbs) {
 return vm
 }
 if (!fn) {
 vm._events[event] = null;
 return vm
 }
 if (fn) {
 var cb;
 var i$1 = cbs.length;
 while (i$1--) {
 cb = cbs[i$1];
 if (cb === fn || cb.fn === fn) {
 cbs.splice(i$1, 1);
 break
 }
 }
 }
 return vm
 };
 Vue.prototype.$emit = function (event) {
 var vm = this;
 {
 var lowerCaseEvent = event.toLowerCase();
 if (lowerCaseEvent !== event && vm._events[lowerCaseEvent]) {
 tip(
     "Event \"" + lowerCaseEvent + "\" is emitted in component " +
     (formatComponentName(vm)) + " but the handler is registered for \"" + event + "\". " +
     "Note that HTML attributes are case-insensitive and you cannot use " +
     "v-on to listen to camelCase events when using in-DOM templates. " +
     "You should probably use \"" + (hyphenate(event)) + "\" instead of \"" + event + "\"."
     );
 }
 }
 var cbs = vm._events[event];
 if (cbs) {
 cbs = cbs.length > 1 ? toArray(cbs) : cbs;
 var args = toArray(arguments, 1);
 for (var i = 0, l = cbs.length; i < l; i++) {
 try {
 cbs[i].apply(vm, args);
 } catch (e) {
 handleError(e, vm, ("event handler for \"" + event + "\""));
 }
 }
 }
 return vm
 };
 }
 function resolveSlots (
                        children,
                        context
                        ) {
 var slots = {};
 if (!children) {
 return slots
 }
 for (var i = 0, l = children.length; i < l; i++) {
 var child = children[i];
 var data = child.data;
 if (data && data.attrs && data.attrs.slot) {
 delete data.attrs.slot;
 }
 if ((child.context === context || child.fnContext === context) &&
     data && data.slot != null
     ) {
 var name = data.slot;
 var slot = (slots[name] || (slots[name] = []));
 if (child.tag === 'template') {
 slot.push.apply(slot, child.children || []);
 } else {
 slot.push(child);
 }
 } else {
 (slots.default || (slots.default = [])).push(child);
 }
 }
 for (var name$1 in slots) {
 if (slots[name$1].every(isWhitespace)) {
 delete slots[name$1];
 }
 }
 return slots
 }
 function isWhitespace (node) {
 return (node.isComment && !node.asyncFactory) || node.text === ' '
 }
 function resolveScopedSlots (
                              fns,
                              res
                              ) {
 res = res || {};
 for (var i = 0; i < fns.length; i++) {
 if (Array.isArray(fns[i])) {
 resolveScopedSlots(fns[i], res);
 } else {
 res[fns[i].key] = fns[i].fn;
 }
 }
 return res
 }
 var activeInstance = null;
 var isUpdatingChildComponent = false;
 function initLifecycle (vm) {
 var options = vm.$options;
 var parent = options.parent;
 if (parent && !options.abstract) {
 while (parent.$options.abstract && parent.$parent) {
 parent = parent.$parent;
 }
 parent.$children.push(vm);
 }
 vm.$parent = parent;
 vm.$root = parent ? parent.$root : vm;
 vm.$children = [];
 vm.$refs = {};
 vm._watcher = null;
 vm._inactive = null;
 vm._directInactive = false;
 vm._isMounted = false;
 vm._isDestroyed = false;
 vm._isBeingDestroyed = false;
 }
 function lifecycleMixin (Vue) {
 Vue.prototype._update = function (vnode, hydrating) {
 var vm = this;
 var prevEl = vm.$el;
 var prevVnode = vm._vnode;
 var prevActiveInstance = activeInstance;
 activeInstance = vm;
 vm._vnode = vnode;
 if (!prevVnode) {
 vm.$el = vm.__patch__(vm.$el, vnode, hydrating, false                 );
 } else {
 vm.$el = vm.__patch__(prevVnode, vnode);
 }
 activeInstance = prevActiveInstance;
 if (prevEl) {
 prevEl.__vue__ = null;
 }
 if (vm.$el) {
 vm.$el.__vue__ = vm;
 }
 if (vm.$vnode && vm.$parent && vm.$vnode === vm.$parent._vnode) {
 vm.$parent.$el = vm.$el;
 }
 };
 Vue.prototype.$forceUpdate = function () {
 var vm = this;
 if (vm._watcher) {
 vm._watcher.update();
 }
 };
 Vue.prototype.$destroy = function () {
 var vm = this;
 if (vm._isBeingDestroyed) {
 return
 }
 callHook(vm, 'beforeDestroy');
 vm._isBeingDestroyed = true;
 var parent = vm.$parent;
 if (parent && !parent._isBeingDestroyed && !vm.$options.abstract) {
 remove$1(parent.$children, vm);
 }
 if (vm._watcher) {
 vm._watcher.teardown();
 }
 var i = vm._watchers.length;
 while (i--) {
 vm._watchers[i].teardown();
 }
 if (vm._data.__ob__) {
 vm._data.__ob__.vmCount--;
 }
 vm._isDestroyed = true;
 vm.__patch__(vm._vnode, null);
 callHook(vm, 'destroyed');
 vm.$off();
 if (vm.$el) {
 vm.$el.__vue__ = null;
 }
 if (vm.$vnode) {
 vm.$vnode.parent = null;
 }
 };
 }
 function mountComponent (
                          vm,
                          el,
                          hydrating
                          ) {
 vm.$el = el;
 if (!vm.$options.render) {
 vm.$options.render = createEmptyVNode;
 {
 if ((vm.$options.template && vm.$options.template.charAt(0) !== '#') ||
     vm.$options.el || el) {
 warn(
      'You are using the runtime-only build of Vue where the template ' +
      'compiler is not available. Either pre-compile the templates into ' +
      'render functions, or use the compiler-included build.',
      vm
      );
 } else {
 warn(
      'Failed to mount component: template or render function not defined.',
      vm
      );
 }
 }
 }
 callHook(vm, 'beforeMount');
 var updateComponent;
 if (config.performance && mark) {
 updateComponent = function () {
 var name = vm._name;
 var id = vm._uid;
 var startTag = "vue-perf-start:" + id;
 var endTag = "vue-perf-end:" + id;
 mark(startTag);
 var vnode = vm._render();
 mark(endTag);
 measure(("vue " + name + " render"), startTag, endTag);
 mark(startTag);
 vm._update(vnode, hydrating);
 mark(endTag);
 measure(("vue " + name + " patch"), startTag, endTag);
 };
 } else {
 updateComponent = function () {
 vm._update(vm._render(), hydrating);
 };
 }
 new Watcher(vm, updateComponent, noop, {
             before: function before () {
             if (vm._isMounted) {
             callHook(vm, 'beforeUpdate');
             }
             }
             }, true                      );
 hydrating = false;
 if (vm.$vnode == null) {
 vm._isMounted = true;
 callHook(vm, 'mounted');
 }
 return vm
 }
 function updateChildComponent (
                                vm,
                                propsData,
                                listeners,
                                parentVnode,
                                renderChildren
                                ) {
 {
 isUpdatingChildComponent = true;
 }
 var hasChildren = !!(
                      renderChildren ||
                      vm.$options._renderChildren ||
                      parentVnode.data.scopedSlots ||
                      vm.$scopedSlots !== emptyObject
                      );
 vm.$options._parentVnode = parentVnode;
 vm.$vnode = parentVnode;
 if (vm._vnode) {
 vm._vnode.parent = parentVnode;
 }
 vm.$options._renderChildren = renderChildren;
 vm.$attrs = parentVnode.data.attrs || emptyObject;
 vm.$listeners = listeners || emptyObject;
 if (propsData && vm.$options.props) {
 toggleObserving(false);
 var props = vm._props;
 var propKeys = vm.$options._propKeys || [];
 for (var i = 0; i < propKeys.length; i++) {
 var key = propKeys[i];
 var propOptions = vm.$options.props;
 props[key] = validateProp(key, propOptions, propsData, vm);
 }
 toggleObserving(true);
 vm.$options.propsData = propsData;
 }
 listeners = listeners || emptyObject;
 var oldListeners = vm.$options._parentListeners;
 vm.$options._parentListeners = listeners;
 updateComponentListeners(vm, listeners, oldListeners);
 if (hasChildren) {
 vm.$slots = resolveSlots(renderChildren, parentVnode.context);
 vm.$forceUpdate();
 }
 {
 isUpdatingChildComponent = false;
 }
 }
 function isInInactiveTree (vm) {
 while (vm && (vm = vm.$parent)) {
 if (vm._inactive) { return true }
 }
 return false
 }
 function activateChildComponent (vm, direct) {
 if (direct) {
 vm._directInactive = false;
 if (isInInactiveTree(vm)) {
 return
 }
 } else if (vm._directInactive) {
 return
 }
 if (vm._inactive || vm._inactive === null) {
 vm._inactive = false;
 for (var i = 0; i < vm.$children.length; i++) {
 activateChildComponent(vm.$children[i]);
 }
 callHook(vm, 'activated');
 }
 }
 function deactivateChildComponent (vm, direct) {
 if (direct) {
 vm._directInactive = true;
 if (isInInactiveTree(vm)) {
 return
 }
 }
 if (!vm._inactive) {
 vm._inactive = true;
 for (var i = 0; i < vm.$children.length; i++) {
 deactivateChildComponent(vm.$children[i]);
 }
 callHook(vm, 'deactivated');
 }
 }
 function callHook (vm, hook) {
 pushTarget();
 var handlers = vm.$options[hook];
 if (handlers) {
 for (var i = 0, j = handlers.length; i < j; i++) {
 try {
 handlers[i].call(vm);
 } catch (e) {
 handleError(e, vm, (hook + " hook"));
 }
 }
 }
 if (vm._hasHookEvent) {
 vm.$emit('hook:' + hook);
 }
 popTarget();
 }
 var MAX_UPDATE_COUNT = 100;
 var queue = [];
 var activatedChildren = [];
 var has$1 = {};
 var circular = {};
 var waiting = false;
 var flushing = false;
 var index = 0;
 function resetSchedulerState () {
 index = queue.length = activatedChildren.length = 0;
 has$1 = {};
 {
 circular = {};
 }
 waiting = flushing = false;
 }
 function flushSchedulerQueue () {
 flushing = true;
 var watcher, id;
 queue.sort(function (a, b) { return a.id - b.id; });
 for (index = 0; index < queue.length; index++) {
 watcher = queue[index];
 if (watcher.before) {
 watcher.before();
 }
 id = watcher.id;
 has$1[id] = null;
 watcher.run();
 if (has$1[id] != null) {
 circular[id] = (circular[id] || 0) + 1;
 if (circular[id] > MAX_UPDATE_COUNT) {
 warn(
      'You may have an infinite update loop ' + (
                                                 watcher.user
                                                 ? ("in watcher with expression \"" + (watcher.expression) + "\"")
                                                 : "in a component render function."
                                                 ),
      watcher.vm
      );
 break
 }
 }
 }
 var activatedQueue = activatedChildren.slice();
 var updatedQueue = queue.slice();
 resetSchedulerState();
 callActivatedHooks(activatedQueue);
 callUpdatedHooks(updatedQueue);
 if (devtools && config.devtools) {
 devtools.emit('flush');
 }
 }
 function callUpdatedHooks (queue) {
 var i = queue.length;
 while (i--) {
 var watcher = queue[i];
 var vm = watcher.vm;
 if (vm._watcher === watcher && vm._isMounted) {
 callHook(vm, 'updated');
 }
 }
 }
 function queueActivatedComponent (vm) {
 vm._inactive = false;
 activatedChildren.push(vm);
 }
 function callActivatedHooks (queue) {
 for (var i = 0; i < queue.length; i++) {
 queue[i]._inactive = true;
 activateChildComponent(queue[i], true           );
 }
 }
 function queueWatcher (watcher) {
 var id = watcher.id;
 if (has$1[id] == null) {
 has$1[id] = true;
 if (!flushing) {
 queue.push(watcher);
 } else {
 var i = queue.length - 1;
 while (i > index && queue[i].id > watcher.id) {
 i--;
 }
 queue.splice(i + 1, 0, watcher);
 }
 if (!waiting) {
 waiting = true;
 nextTick(flushSchedulerQueue);
 }
 }
 }
 var uid$1 = 0;
 var Watcher = function Watcher (
                                 vm,
                                 expOrFn,
                                 cb,
                                 options,
                                 isRenderWatcher
                                 ) {
 this.vm = vm;
 if (isRenderWatcher) {
 vm._watcher = this;
 }
 vm._watchers.push(this);
 if (options) {
 this.deep = !!options.deep;
 this.user = !!options.user;
 this.computed = !!options.computed;
 this.sync = !!options.sync;
 this.before = options.before;
 } else {
 this.deep = this.user = this.computed = this.sync = false;
 }
 this.cb = cb;
 this.id = ++uid$1;
 this.active = true;
 this.dirty = this.computed;
 this.deps = [];
 this.newDeps = [];
 this.depIds = new _Set();
 this.newDepIds = new _Set();
 this.expression = expOrFn.toString();
 if (typeof expOrFn === 'function') {
 this.getter = expOrFn;
 } else {
 this.getter = parsePath(expOrFn);
 if (!this.getter) {
 this.getter = function () {};
 warn(
      "Failed watching path: \"" + expOrFn + "\" " +
      'Watcher only accepts simple dot-delimited paths. ' +
      'For full control, use a function instead.',
      vm
      );
 }
 }
 if (this.computed) {
 this.value = undefined;
 this.dep = new Dep();
 } else {
 this.value = this.get();
 }
 };
 Watcher.prototype.get = function get () {
 pushTarget(this);
 var value;
 var vm = this.vm;
 try {
 value = this.getter.call(vm, vm);
 } catch (e) {
 if (this.user) {
 handleError(e, vm, ("getter for watcher \"" + (this.expression) + "\""));
 } else {
 throw e
 }
 } finally {
 if (this.deep) {
 traverse(value);
 }
 popTarget();
 this.cleanupDeps();
 }
 return value
 };
 Watcher.prototype.addDep = function addDep (dep) {
 var id = dep.id;
 if (!this.newDepIds.has(id)) {
 this.newDepIds.add(id);
 this.newDeps.push(dep);
 if (!this.depIds.has(id)) {
 dep.addSub(this);
 }
 }
 };
 Watcher.prototype.cleanupDeps = function cleanupDeps () {
 var this$1 = this;
 var i = this.deps.length;
 while (i--) {
 var dep = this$1.deps[i];
 if (!this$1.newDepIds.has(dep.id)) {
 dep.removeSub(this$1);
 }
 }
 var tmp = this.depIds;
 this.depIds = this.newDepIds;
 this.newDepIds = tmp;
 this.newDepIds.clear();
 tmp = this.deps;
 this.deps = this.newDeps;
 this.newDeps = tmp;
 this.newDeps.length = 0;
 };
 Watcher.prototype.update = function update () {
 var this$1 = this;
 if (this.computed) {
 if (this.dep.subs.length === 0) {
 this.dirty = true;
 } else {
 this.getAndInvoke(function () {
                   this$1.dep.notify();
                   });
 }
 } else if (this.sync) {
 this.run();
 } else {
 queueWatcher(this);
 }
 };
 Watcher.prototype.run = function run () {
 if (this.active) {
 this.getAndInvoke(this.cb);
 }
 };
 Watcher.prototype.getAndInvoke = function getAndInvoke (cb) {
 var value = this.get();
 if (
     value !== this.value ||
     isObject$1(value) ||
     this.deep
     ) {
 var oldValue = this.value;
 this.value = value;
 this.dirty = false;
 if (this.user) {
 try {
 cb.call(this.vm, value, oldValue);
 } catch (e) {
 handleError(e, this.vm, ("callback for watcher \"" + (this.expression) + "\""));
 }
 } else {
 cb.call(this.vm, value, oldValue);
 }
 }
 };
 Watcher.prototype.evaluate = function evaluate () {
 if (this.dirty) {
 this.value = this.get();
 this.dirty = false;
 }
 return this.value
 };
 Watcher.prototype.depend = function depend () {
 if (this.dep && Dep.target) {
 this.dep.depend();
 }
 };
 Watcher.prototype.teardown = function teardown () {
 var this$1 = this;
 if (this.active) {
 if (!this.vm._isBeingDestroyed) {
 remove$1(this.vm._watchers, this);
 }
 var i = this.deps.length;
 while (i--) {
 this$1.deps[i].removeSub(this$1);
 }
 this.active = false;
 }
 };
 var sharedPropertyDefinition = {
 enumerable: true,
 configurable: true,
 get: noop,
 set: noop
 };
 function proxy (target, sourceKey, key) {
 sharedPropertyDefinition.get = function proxyGetter () {
 return this[sourceKey][key]
 };
 sharedPropertyDefinition.set = function proxySetter (val) {
 this[sourceKey][key] = val;
 };
 Object.defineProperty(target, key, sharedPropertyDefinition);
 }
 function initState (vm) {
 vm._watchers = [];
 var opts = vm.$options;
 if (opts.props) { initProps(vm, opts.props); }
 if (opts.methods) { initMethods(vm, opts.methods); }
 if (opts.data) {
 initData(vm);
 } else {
 observe(vm._data = {}, true                 );
 }
 if (opts.computed) { initComputed(vm, opts.computed); }
 if (opts.watch && opts.watch !== nativeWatch) {
 initWatch(vm, opts.watch);
 }
 }
 function initProps (vm, propsOptions) {
 var propsData = vm.$options.propsData || {};
 var props = vm._props = {};
 var keys = vm.$options._propKeys = [];
 var isRoot = !vm.$parent;
 if (!isRoot) {
 toggleObserving(false);
 }
 var loop = function ( key ) {
 keys.push(key);
 var value = validateProp(key, propsOptions, propsData, vm);
 {
 var hyphenatedKey = hyphenate(key);
 if (isReservedAttribute(hyphenatedKey) ||
     config.isReservedAttr(hyphenatedKey)) {
 warn(
      ("\"" + hyphenatedKey + "\" is a reserved attribute and cannot be used as component prop."),
      vm
      );
 }
 defineReactive(props, key, value, function () {
                if (vm.$parent && !isUpdatingChildComponent) {
                warn(
                     "Avoid mutating a prop directly since the value will be " +
                     "overwritten whenever the parent component re-renders. " +
                     "Instead, use a data or computed property based on the prop's " +
                     "value. Prop being mutated: \"" + key + "\"",
                     vm
                     );
                }
                });
 }
 if (!(key in vm)) {
 proxy(vm, "_props", key);
 }
 };
 for (var key in propsOptions) loop( key );
 toggleObserving(true);
 }
 function initData (vm) {
 var data = vm.$options.data;
 data = vm._data = typeof data === 'function'
 ? getData(data, vm)
 : data || {};
 if (!isPlainObject(data)) {
 data = {};
 warn(
      'data functions should return an object:\n' +
      'https://vuejs.org/v2/guide/components.html#data-Must-Be-a-Function',
      vm
      );
 }
 var keys = Object.keys(data);
 var props = vm.$options.props;
 var methods = vm.$options.methods;
 var i = keys.length;
 while (i--) {
 var key = keys[i];
 {
 if (methods && hasOwn(methods, key)) {
 warn(
      ("Method \"" + key + "\" has already been defined as a data property."),
      vm
      );
 }
 }
 if (props && hasOwn(props, key)) {
 warn(
      "The data property \"" + key + "\" is already declared as a prop. " +
      "Use prop default value instead.",
      vm
      );
 } else if (!isReserved(key)) {
 proxy(vm, "_data", key);
 }
 }
 observe(data, true                 );
 }
 function getData (data, vm) {
 pushTarget();
 try {
 return data.call(vm, vm)
 } catch (e) {
 handleError(e, vm, "data()");
 return {}
 } finally {
 popTarget();
 }
 }
 var computedWatcherOptions = { computed: true };
 function initComputed (vm, computed) {
 var watchers = vm._computedWatchers = Object.create(null);
 var isSSR = isServerRendering();
 for (var key in computed) {
 var userDef = computed[key];
 var getter = typeof userDef === 'function' ? userDef : userDef.get;
 if (getter == null) {
 warn(
      ("Getter is missing for computed property \"" + key + "\"."),
      vm
      );
 }
 if (!isSSR) {
 watchers[key] = new Watcher(
                             vm,
                             getter || noop,
                             noop,
                             computedWatcherOptions
                             );
 }
 if (!(key in vm)) {
 defineComputed(vm, key, userDef);
 } else {
 if (key in vm.$data) {
 warn(("The computed property \"" + key + "\" is already defined in data."), vm);
 } else if (vm.$options.props && key in vm.$options.props) {
 warn(("The computed property \"" + key + "\" is already defined as a prop."), vm);
 }
 }
 }
 }
 function defineComputed (
                          target,
                          key,
                          userDef
                          ) {
 var shouldCache = !isServerRendering();
 if (typeof userDef === 'function') {
 sharedPropertyDefinition.get = shouldCache
 ? createComputedGetter(key)
 : userDef;
 sharedPropertyDefinition.set = noop;
 } else {
 sharedPropertyDefinition.get = userDef.get
 ? shouldCache && userDef.cache !== false
 ? createComputedGetter(key)
 : userDef.get
 : noop;
 sharedPropertyDefinition.set = userDef.set
 ? userDef.set
 : noop;
 }
 if (sharedPropertyDefinition.set === noop) {
 sharedPropertyDefinition.set = function () {
 warn(
      ("Computed property \"" + key + "\" was assigned to but it has no setter."),
      this
      );
 };
 }
 Object.defineProperty(target, key, sharedPropertyDefinition);
 }
 function createComputedGetter (key) {
 return function computedGetter () {
 var watcher = this._computedWatchers && this._computedWatchers[key];
 if (watcher) {
 watcher.depend();
 return watcher.evaluate()
 }
 }
 }
 function initMethods (vm, methods) {
 var props = vm.$options.props;
 for (var key in methods) {
 {
 if (methods[key] == null) {
 warn(
      "Method \"" + key + "\" has an undefined value in the component definition. " +
      "Did you reference the function correctly?",
      vm
      );
 }
 if (props && hasOwn(props, key)) {
 warn(
      ("Method \"" + key + "\" has already been defined as a prop."),
      vm
      );
 }
 if ((key in vm) && isReserved(key)) {
 warn(
      "Method \"" + key + "\" conflicts with an existing Vue instance method. " +
      "Avoid defining component methods that start with _ or $."
      );
 }
 }
 vm[key] = methods[key] == null ? noop : bind(methods[key], vm);
 }
 }
 function initWatch (vm, watch) {
 for (var key in watch) {
 var handler = watch[key];
 if (Array.isArray(handler)) {
 for (var i = 0; i < handler.length; i++) {
 createWatcher(vm, key, handler[i]);
 }
 } else {
 createWatcher(vm, key, handler);
 }
 }
 }
 function createWatcher (
                         vm,
                         expOrFn,
                         handler,
                         options
                         ) {
 if (isPlainObject(handler)) {
 options = handler;
 handler = handler.handler;
 }
 if (typeof handler === 'string') {
 handler = vm[handler];
 }
 return vm.$watch(expOrFn, handler, options)
 }
 function stateMixin (Vue) {
 var dataDef = {};
 dataDef.get = function () { return this._data };
 var propsDef = {};
 propsDef.get = function () { return this._props };
 {
 dataDef.set = function (newData) {
 warn(
      'Avoid replacing instance root $data. ' +
      'Use nested data properties instead.',
      this
      );
 };
 propsDef.set = function () {
 warn("$props is readonly.", this);
 };
 }
 Object.defineProperty(Vue.prototype, '$data', dataDef);
 Object.defineProperty(Vue.prototype, '$props', propsDef);
 Vue.prototype.$set = set;
 Vue.prototype.$delete = del;
 Vue.prototype.$watch = function (
                                  expOrFn,
                                  cb,
                                  options
                                  ) {
 var vm = this;
 if (isPlainObject(cb)) {
 return createWatcher(vm, expOrFn, cb, options)
 }
 options = options || {};
 options.user = true;
 var watcher = new Watcher(vm, expOrFn, cb, options);
 if (options.immediate) {
 cb.call(vm, watcher.value);
 }
 return function unwatchFn () {
 watcher.teardown();
 }
 };
 }
 function initProvide (vm) {
 var provide = vm.$options.provide;
 if (provide) {
 vm._provided = typeof provide === 'function'
 ? provide.call(vm)
 : provide;
 }
 }
 function initInjections$1 (vm) {
 var result = resolveInject(vm.$options.inject, vm);
 if (result) {
 toggleObserving(false);
 Object.keys(result).forEach(function (key) {
                             {
                             defineReactive(vm, key, result[key], function () {
                                            warn(
                                                 "Avoid mutating an injected value directly since the changes will be " +
                                                 "overwritten whenever the provided component re-renders. " +
                                                 "injection being mutated: \"" + key + "\"",
                                                 vm
                                                 );
                                            });
                             }
                             });
 toggleObserving(true);
 }
 }
 function resolveInject (inject, vm) {
 if (inject) {
 var result = Object.create(null);
 var keys = hasSymbol
 ? Reflect.ownKeys(inject).filter(function (key) {
                                  return Object.getOwnPropertyDescriptor(inject, key).enumerable
                                  })
 : Object.keys(inject);
 for (var i = 0; i < keys.length; i++) {
 var key = keys[i];
 var provideKey = inject[key].from;
 var source = vm;
 while (source) {
 if (source._provided && hasOwn(source._provided, provideKey)) {
 result[key] = source._provided[provideKey];
 break
 }
 source = source.$parent;
 }
 if (!source) {
 if ('default' in inject[key]) {
 var provideDefault = inject[key].default;
 result[key] = typeof provideDefault === 'function'
 ? provideDefault.call(vm)
 : provideDefault;
 } else {
 warn(("Injection \"" + key + "\" not found"), vm);
 }
 }
 }
 return result
 }
 }
 function renderList (
                      val,
                      render
                      ) {
 var ret, i, l, keys, key;
 if (Array.isArray(val) || typeof val === 'string') {
 ret = new Array(val.length);
 for (i = 0, l = val.length; i < l; i++) {
 ret[i] = render(val[i], i);
 }
 } else if (typeof val === 'number') {
 ret = new Array(val);
 for (i = 0; i < val; i++) {
 ret[i] = render(i + 1, i);
 }
 } else if (isObject$1(val)) {
 keys = Object.keys(val);
 ret = new Array(keys.length);
 for (i = 0, l = keys.length; i < l; i++) {
 key = keys[i];
 ret[i] = render(val[key], key, i);
 }
 }
 if (isDef$1(ret)) {
 (ret)._isVList = true;
 }
 return ret
 }
 function renderSlot (
                      name,
                      fallback,
                      props,
                      bindObject
                      ) {
 var scopedSlotFn = this.$scopedSlots[name];
 var nodes;
 if (scopedSlotFn) {
 props = props || {};
 if (bindObject) {
 if (!isObject$1(bindObject)) {
 warn(
      'slot v-bind without argument expects an Object',
      this
      );
 }
 props = extend(extend({}, bindObject), props);
 }
 nodes = scopedSlotFn(props) || fallback;
 } else {
 var slotNodes = this.$slots[name];
 if (slotNodes) {
 if (slotNodes._rendered) {
 warn(
      "Duplicate presence of slot \"" + name + "\" found in the same render tree " +
      "- this will likely cause render errors.",
      this
      );
 }
 slotNodes._rendered = true;
 }
 nodes = slotNodes || fallback;
 }
 var target = props && props.slot;
 if (target) {
 return this.$createElement('template', { slot: target }, nodes)
 } else {
 return nodes
 }
 }
 function resolveFilter (id) {
 return resolveAsset(this.$options, 'filters', id, true) || identity
 }
 function isKeyNotMatch (expect, actual) {
 if (Array.isArray(expect)) {
 return expect.indexOf(actual) === -1
 } else {
 return expect !== actual
 }
 }
 function checkKeyCodes (
                         eventKeyCode,
                         key,
                         builtInKeyCode,
                         eventKeyName,
                         builtInKeyName
                         ) {
 var mappedKeyCode = config.keyCodes[key] || builtInKeyCode;
 if (builtInKeyName && eventKeyName && !config.keyCodes[key]) {
 return isKeyNotMatch(builtInKeyName, eventKeyName)
 } else if (mappedKeyCode) {
 return isKeyNotMatch(mappedKeyCode, eventKeyCode)
 } else if (eventKeyName) {
 return hyphenate(eventKeyName) !== key
 }
 }
 function bindObjectProps (
                           data,
                           tag,
                           value,
                           asProp,
                           isSync
                           ) {
 if (value) {
 if (!isObject$1(value)) {
 warn(
      'v-bind without argument expects an Object or Array value',
      this
      );
 } else {
 if (Array.isArray(value)) {
 value = toObject(value);
 }
 var hash;
 var loop = function ( key ) {
 if (
     key === 'class' ||
     key === 'style' ||
     isReservedAttribute(key)
     ) {
 hash = data;
 } else {
 var type = data.attrs && data.attrs.type;
 hash = asProp || config.mustUseProp(tag, type, key)
 ? data.domProps || (data.domProps = {})
 : data.attrs || (data.attrs = {});
 }
 if (!(key in hash)) {
 hash[key] = value[key];
 if (isSync) {
 var on = data.on || (data.on = {});
 on[("update:" + key)] = function ($event) {
 value[key] = $event;
 };
 }
 }
 };
 for (var key in value) loop( key );
 }
 }
 return data
 }
 function renderStatic (
                        index,
                        isInFor
                        ) {
 var cached = this._staticTrees || (this._staticTrees = []);
 var tree = cached[index];
 if (tree && !isInFor) {
 return tree
 }
 tree = cached[index] = this.$options.staticRenderFns[index].call(
                                                                  this._renderProxy,
                                                                  null,
                                                                  this
                                                                  );
 markStatic(tree, ("__static__" + index), false);
 return tree
 }
 function markOnce (
                    tree,
                    index,
                    key
                    ) {
 markStatic(tree, ("__once__" + index + (key ? ("_" + key) : "")), true);
 return tree
 }
 function markStatic (
                      tree,
                      key,
                      isOnce
                      ) {
 if (Array.isArray(tree)) {
 for (var i = 0; i < tree.length; i++) {
 if (tree[i] && typeof tree[i] !== 'string') {
 markStaticNode(tree[i], (key + "_" + i), isOnce);
 }
 }
 } else {
 markStaticNode(tree, key, isOnce);
 }
 }
 function markStaticNode (node, key, isOnce) {
 node.isStatic = true;
 node.key = key;
 node.isOnce = isOnce;
 }
 function bindObjectListeners (data, value) {
 if (value) {
 if (!isPlainObject(value)) {
 warn(
      'v-on without argument expects an Object value',
      this
      );
 } else {
 var on = data.on = data.on ? extend({}, data.on) : {};
 for (var key in value) {
 var existing = on[key];
 var ours = value[key];
 on[key] = existing ? [].concat(existing, ours) : ours;
 }
 }
 }
 return data
 }
 function installRenderHelpers (target) {
 target._o = markOnce;
 target._n = toNumber;
 target._s = toString$1;
 target._l = renderList;
 target._t = renderSlot;
 target._q = looseEqual;
 target._i = looseIndexOf;
 target._m = renderStatic;
 target._f = resolveFilter;
 target._k = checkKeyCodes;
 target._b = bindObjectProps;
 target._v = createTextVNode;
 target._e = createEmptyVNode;
 target._u = resolveScopedSlots;
 target._g = bindObjectListeners;
 }
 function FunctionalRenderContext (
                                   data,
                                   props,
                                   children,
                                   parent,
                                   Ctor
                                   ) {
 var options = Ctor.options;
 var contextVm;
 if (hasOwn(parent, '_uid')) {
 contextVm = Object.create(parent);
 contextVm._original = parent;
 } else {
 contextVm = parent;
 parent = parent._original;
 }
 var isCompiled = isTrue(options._compiled);
 var needNormalization = !isCompiled;
 this.data = data;
 this.props = props;
 this.children = children;
 this.parent = parent;
 this.listeners = data.on || emptyObject;
 this.injections = resolveInject(options.inject, parent);
 this.slots = function () { return resolveSlots(children, parent); };
 if (isCompiled) {
 this.$options = options;
 this.$slots = this.slots();
 this.$scopedSlots = data.scopedSlots || emptyObject;
 }
 if (options._scopeId) {
 this._c = function (a, b, c, d) {
 var vnode = createElement(contextVm, a, b, c, d, needNormalization);
 if (vnode && !Array.isArray(vnode)) {
 vnode.fnScopeId = options._scopeId;
 vnode.fnContext = parent;
 }
 return vnode
 };
 } else {
 this._c = function (a, b, c, d) { return createElement(contextVm, a, b, c, d, needNormalization); };
 }
 }
 installRenderHelpers(FunctionalRenderContext.prototype);
 function createFunctionalComponent (
                                     Ctor,
                                     propsData,
                                     data,
                                     contextVm,
                                     children
                                     ) {
 var options = Ctor.options;
 var props = {};
 var propOptions = options.props;
 if (isDef$1(propOptions)) {
 for (var key in propOptions) {
 props[key] = validateProp(key, propOptions, propsData || emptyObject);
 }
 } else {
 if (isDef$1(data.attrs)) { mergeProps(props, data.attrs); }
 if (isDef$1(data.props)) { mergeProps(props, data.props); }
 }
 var renderContext = new FunctionalRenderContext(
                                                 data,
                                                 props,
                                                 children,
                                                 contextVm,
                                                 Ctor
                                                 );
 var vnode = options.render.call(null, renderContext._c, renderContext);
 if (vnode instanceof VNode) {
 return cloneAndMarkFunctionalResult(vnode, data, renderContext.parent, options)
 } else if (Array.isArray(vnode)) {
 var vnodes = normalizeChildren(vnode) || [];
 var res = new Array(vnodes.length);
 for (var i = 0; i < vnodes.length; i++) {
 res[i] = cloneAndMarkFunctionalResult(vnodes[i], data, renderContext.parent, options);
 }
 return res
 }
 }
 function cloneAndMarkFunctionalResult (vnode, data, contextVm, options) {
 var clone = cloneVNode(vnode);
 clone.fnContext = contextVm;
 clone.fnOptions = options;
 if (data.slot) {
 (clone.data || (clone.data = {})).slot = data.slot;
 }
 return clone
 }
 function mergeProps (to, from) {
 for (var key in from) {
 to[camelize(key)] = from[key];
 }
 }
 var componentVNodeHooks = {
 init: function init (vnode, hydrating) {
 if (
     vnode.componentInstance &&
     !vnode.componentInstance._isDestroyed &&
     vnode.data.keepAlive
     ) {
 var mountedNode = vnode;
 componentVNodeHooks.prepatch(mountedNode, mountedNode);
 } else {
 var child = vnode.componentInstance = createComponentInstanceForVnode(
                                                                       vnode,
                                                                       activeInstance
                                                                       );
 child.$mount(hydrating ? vnode.elm : undefined, hydrating);
 }
 },
 prepatch: function prepatch (oldVnode, vnode) {
 var options = vnode.componentOptions;
 var child = vnode.componentInstance = oldVnode.componentInstance;
 updateChildComponent(
                      child,
                      options.propsData,
                      options.listeners,
                      vnode,
                      options.children
                      );
 },
 insert: function insert (vnode) {
 var context = vnode.context;
 var componentInstance = vnode.componentInstance;
 if (!componentInstance._isMounted) {
 componentInstance._isMounted = true;
 callHook(componentInstance, 'mounted');
 }
 if (vnode.data.keepAlive) {
 if (context._isMounted) {
 queueActivatedComponent(componentInstance);
 } else {
 activateChildComponent(componentInstance, true             );
 }
 }
 },
 destroy: function destroy (vnode) {
 var componentInstance = vnode.componentInstance;
 if (!componentInstance._isDestroyed) {
 if (!vnode.data.keepAlive) {
 componentInstance.$destroy();
 } else {
 deactivateChildComponent(componentInstance, true             );
 }
 }
 }
 };
 var hooksToMerge = Object.keys(componentVNodeHooks);
 function createComponent (
                           Ctor,
                           data,
                           context,
                           children,
                           tag
                           ) {
 if (isUndef$1(Ctor)) {
 return
 }
 var baseCtor = context.$options._base;
 if (isObject$1(Ctor)) {
 Ctor = baseCtor.extend(Ctor);
 }
 if (typeof Ctor !== 'function') {
 {
 warn(("Invalid Component definition: " + (String(Ctor))), context);
 }
 return
 }
 var asyncFactory;
 if (isUndef$1(Ctor.cid)) {
 asyncFactory = Ctor;
 Ctor = resolveAsyncComponent(asyncFactory, baseCtor, context);
 if (Ctor === undefined) {
 return createAsyncPlaceholder(
                               asyncFactory,
                               data,
                               context,
                               children,
                               tag
                               )
 }
 }
 data = data || {};
 resolveConstructorOptions(Ctor);
 if (isDef$1(data.model)) {
 transformModel(Ctor.options, data);
 }
 var propsData = extractPropsFromVNodeData(data, Ctor, tag);
 if (isTrue(Ctor.options.functional)) {
 return createFunctionalComponent(Ctor, propsData, data, context, children)
 }
 var listeners = data.on;
 data.on = data.nativeOn;
 if (isTrue(Ctor.options.abstract)) {
 var slot = data.slot;
 data = {};
 if (slot) {
 data.slot = slot;
 }
 }
 installComponentHooks(data);
 var name = Ctor.options.name || tag;
 var vnode = new VNode(
                       ("vue-component-" + (Ctor.cid) + (name ? ("-" + name) : '')),
                       data, undefined, undefined, undefined, context,
                       { Ctor: Ctor, propsData: propsData, listeners: listeners, tag: tag, children: children },
                       asyncFactory
                       );
 return vnode
 }
 function createComponentInstanceForVnode (
                                           vnode,
                                           parent
                                           ) {
 var options = {
 _isComponent: true,
 _parentVnode: vnode,
 parent: parent,
 };
 var inlineTemplate = vnode.data.inlineTemplate;
 if (isDef$1(inlineTemplate)) {
 options.render = inlineTemplate.render;
 options.staticRenderFns = inlineTemplate.staticRenderFns;
 }
 return new vnode.componentOptions.Ctor(options)
 }
 function installComponentHooks (data) {
 var hooks = data.hook || (data.hook = {});
 for (var i = 0; i < hooksToMerge.length; i++) {
 var key = hooksToMerge[i];
 var existing = hooks[key];
 var toMerge = componentVNodeHooks[key];
 if (existing !== toMerge && !(existing && existing._merged)) {
 hooks[key] = existing ? mergeHook$1(toMerge, existing) : toMerge;
 }
 }
 }
 function mergeHook$1 (f1, f2) {
 var merged = function (a, b) {
 f1(a, b);
 f2(a, b);
 };
 merged._merged = true;
 return merged
 }
 function transformModel (options, data) {
 var prop = (options.model && options.model.prop) || 'value';
 var event = (options.model && options.model.event) || 'input';(data.props || (data.props = {}))[prop] = data.model.value;
 var on = data.on || (data.on = {});
 if (isDef$1(on[event])) {
 on[event] = [data.model.callback].concat(on[event]);
 } else {
 on[event] = data.model.callback;
 }
 }
 var SIMPLE_NORMALIZE = 1;
 var ALWAYS_NORMALIZE = 2;
 function createElement (
                         context,
                         tag,
                         data,
                         children,
                         normalizationType,
                         alwaysNormalize
                         ) {
 if (Array.isArray(data) || isPrimitive(data)) {
 normalizationType = children;
 children = data;
 data = undefined;
 }
 if (isTrue(alwaysNormalize)) {
 normalizationType = ALWAYS_NORMALIZE;
 }
 return _createElement(context, tag, data, children, normalizationType)
 }
 function _createElement (
                          context,
                          tag,
                          data,
                          children,
                          normalizationType
                          ) {
 if (isDef$1(data) && isDef$1((data).__ob__)) {
 warn(
      "Avoid using observed data object as vnode data: " + (JSON.stringify(data)) + "\n" +
      'Always create fresh vnode data objects in each render!',
      context
      );
 return createEmptyVNode()
 }
 if (isDef$1(data) && isDef$1(data.is)) {
 tag = data.is;
 }
 if (!tag) {
 return createEmptyVNode()
 }
 if (isDef$1(data) && isDef$1(data.key) && !isPrimitive(data.key)
     ) {
 {
 warn(
      'Avoid using non-primitive value as key, ' +
      'use string/number value instead.',
      context
      );
 }
 }
 if (Array.isArray(children) &&
     typeof children[0] === 'function'
     ) {
 data = data || {};
 data.scopedSlots = { default: children[0] };
 children.length = 0;
 }
 if (normalizationType === ALWAYS_NORMALIZE) {
 children = normalizeChildren(children);
 } else if (normalizationType === SIMPLE_NORMALIZE) {
 children = simpleNormalizeChildren(children);
 }
 var vnode, ns;
 if (typeof tag === 'string') {
 var Ctor;
 ns = (context.$vnode && context.$vnode.ns) || config.getTagNamespace(tag);
 if (config.isReservedTag(tag)) {
 vnode = new VNode(
                   config.parsePlatformTagName(tag), data, children,
                   undefined, undefined, context
                   );
 } else if (isDef$1(Ctor = resolveAsset(context.$options, 'components', tag))) {
 vnode = createComponent(Ctor, data, context, children, tag);
 } else {
 vnode = new VNode(
                   tag, data, children,
                   undefined, undefined, context
                   );
 }
 } else {
 vnode = createComponent(tag, data, context, children);
 }
 if (Array.isArray(vnode)) {
 return vnode
 } else if (isDef$1(vnode)) {
 if (isDef$1(ns)) { applyNS(vnode, ns); }
 if (isDef$1(data)) { registerDeepBindings(data); }
 return vnode
 } else {
 return createEmptyVNode()
 }
 }
 function applyNS (vnode, ns, force) {
 vnode.ns = ns;
 if (vnode.tag === 'foreignObject') {
 ns = undefined;
 force = true;
 }
 if (isDef$1(vnode.children)) {
 for (var i = 0, l = vnode.children.length; i < l; i++) {
 var child = vnode.children[i];
 if (isDef$1(child.tag) && (
                            isUndef$1(child.ns) || (isTrue(force) && child.tag !== 'svg'))) {
 applyNS(child, ns, force);
 }
 }
 }
 }
 function registerDeepBindings (data) {
 if (isObject$1(data.style)) {
 traverse(data.style);
 }
 if (isObject$1(data.class)) {
 traverse(data.class);
 }
 }
 function initRender (vm) {
 vm._vnode = null;
 vm._staticTrees = null;
 var options = vm.$options;
 var parentVnode = vm.$vnode = options._parentVnode;
 var renderContext = parentVnode && parentVnode.context;
 vm.$slots = resolveSlots(options._renderChildren, renderContext);
 vm.$scopedSlots = emptyObject;
 vm._c = function (a, b, c, d) { return createElement(vm, a, b, c, d, false); };
 vm.$createElement = function (a, b, c, d) { return createElement(vm, a, b, c, d, true); };
 var parentData = parentVnode && parentVnode.data;
 {
 defineReactive(vm, '$attrs', parentData && parentData.attrs || emptyObject, function () {
                !isUpdatingChildComponent && warn("$attrs is readonly.", vm);
                }, true);
 defineReactive(vm, '$listeners', options._parentListeners || emptyObject, function () {
                !isUpdatingChildComponent && warn("$listeners is readonly.", vm);
                }, true);
 }
 }
 function renderMixin (Vue) {
 installRenderHelpers(Vue.prototype);
 Vue.prototype.$nextTick = function (fn) {
 return nextTick(fn, this)
 };
 Vue.prototype._render = function () {
 var vm = this;
 var ref = vm.$options;
 var render = ref.render;
 var _parentVnode = ref._parentVnode;
 {
 for (var key in vm.$slots) {
 vm.$slots[key]._rendered = false;
 }
 }
 if (_parentVnode) {
 vm.$scopedSlots = _parentVnode.data.scopedSlots || emptyObject;
 }
 vm.$vnode = _parentVnode;
 var vnode;
 try {
 vnode = render.call(vm._renderProxy, vm.$createElement);
 } catch (e) {
 handleError(e, vm, "render");
 {
 if (vm.$options.renderError) {
 try {
 vnode = vm.$options.renderError.call(vm._renderProxy, vm.$createElement, e);
 } catch (e) {
 handleError(e, vm, "renderError");
 vnode = vm._vnode;
 }
 } else {
 vnode = vm._vnode;
 }
 }
 }
 if (!(vnode instanceof VNode)) {
 if (Array.isArray(vnode)) {
 warn(
      'Multiple root nodes returned from render function. Render function ' +
      'should return a single root node.',
      vm
      );
 }
 vnode = createEmptyVNode();
 }
 vnode.parent = _parentVnode;
 return vnode
 };
 }
 var uid$3 = 0;
 function initMixin (Vue) {
 Vue.prototype._init = function (options) {
 var vm = this;
 vm._uid = uid$3++;
 var startTag, endTag;
 if (config.performance && mark) {
 startTag = "vue-perf-start:" + (vm._uid);
 endTag = "vue-perf-end:" + (vm._uid);
 mark(startTag);
 }
 vm._isVue = true;
 if (options && options._isComponent) {
 initInternalComponent(vm, options);
 } else {
 vm.$options = mergeOptions(
                            resolveConstructorOptions(vm.constructor),
                            options || {},
                            vm
                            );
 }
 {
 initProxy(vm);
 }
 vm._self = vm;
 initLifecycle(vm);
 initEvents(vm);
 initRender(vm);
 callHook(vm, 'beforeCreate');
 initInjections$1(vm);
 initState(vm);
 initProvide(vm);
 callHook(vm, 'created');
 if (config.performance && mark) {
 vm._name = formatComponentName(vm, false);
 mark(endTag);
 measure(("vue " + (vm._name) + " init"), startTag, endTag);
 }
 if (vm.$options.el) {
 vm.$mount(vm.$options.el);
 }
 };
 }
 function initInternalComponent (vm, options) {
 var opts = vm.$options = Object.create(vm.constructor.options);
 var parentVnode = options._parentVnode;
 opts.parent = options.parent;
 opts._parentVnode = parentVnode;
 var vnodeComponentOptions = parentVnode.componentOptions;
 opts.propsData = vnodeComponentOptions.propsData;
 opts._parentListeners = vnodeComponentOptions.listeners;
 opts._renderChildren = vnodeComponentOptions.children;
 opts._componentTag = vnodeComponentOptions.tag;
 if (options.render) {
 opts.render = options.render;
 opts.staticRenderFns = options.staticRenderFns;
 }
 }
 function resolveConstructorOptions (Ctor) {
 var options = Ctor.options;
 if (Ctor.super) {
 var superOptions = resolveConstructorOptions(Ctor.super);
 var cachedSuperOptions = Ctor.superOptions;
 if (superOptions !== cachedSuperOptions) {
 Ctor.superOptions = superOptions;
 var modifiedOptions = resolveModifiedOptions(Ctor);
 if (modifiedOptions) {
 extend(Ctor.extendOptions, modifiedOptions);
 }
 options = Ctor.options = mergeOptions(superOptions, Ctor.extendOptions);
 if (options.name) {
 options.components[options.name] = Ctor;
 }
 }
 }
 return options
 }
 function resolveModifiedOptions (Ctor) {
 var modified;
 var latest = Ctor.options;
 var extended = Ctor.extendOptions;
 var sealed = Ctor.sealedOptions;
 for (var key in latest) {
 if (latest[key] !== sealed[key]) {
 if (!modified) { modified = {}; }
 modified[key] = dedupe(latest[key], extended[key], sealed[key]);
 }
 }
 return modified
 }
 function dedupe (latest, extended, sealed) {
 if (Array.isArray(latest)) {
 var res = [];
 sealed = Array.isArray(sealed) ? sealed : [sealed];
 extended = Array.isArray(extended) ? extended : [extended];
 for (var i = 0; i < latest.length; i++) {
 if (extended.indexOf(latest[i]) >= 0 || sealed.indexOf(latest[i]) < 0) {
 res.push(latest[i]);
 }
 }
 return res
 } else {
 return latest
 }
 }
 function Vue (options) {
 if (!(this instanceof Vue)
     ) {
 warn('Vue is a constructor and should be called with the `new` keyword');
 }
 this._init(options);
 }
 initMixin(Vue);
 stateMixin(Vue);
 eventsMixin(Vue);
 lifecycleMixin(Vue);
 renderMixin(Vue);
 function initUse (Vue) {
 Vue.use = function (plugin) {
 var installedPlugins = (this._installedPlugins || (this._installedPlugins = []));
 if (installedPlugins.indexOf(plugin) > -1) {
 return this
 }
 var args = toArray(arguments, 1);
 args.unshift(this);
 if (typeof plugin.install === 'function') {
 plugin.install.apply(plugin, args);
 } else if (typeof plugin === 'function') {
 plugin.apply(null, args);
 }
 installedPlugins.push(plugin);
 return this
 };
 }
 function initMixin$1 (Vue) {
 Vue.mixin = function (mixin) {
 this.options = mergeOptions(this.options, mixin);
 return this
 };
 }
 function initExtend (Vue) {
 Vue.cid = 0;
 var cid = 1;
 Vue.extend = function (extendOptions) {
 extendOptions = extendOptions || {};
 var Super = this;
 var SuperId = Super.cid;
 var cachedCtors = extendOptions._Ctor || (extendOptions._Ctor = {});
 if (cachedCtors[SuperId]) {
 return cachedCtors[SuperId]
 }
 var name = extendOptions.name || Super.options.name;
 if (name) {
 validateComponentName(name);
 }
 var Sub = function VueComponent (options) {
 this._init(options);
 };
 Sub.prototype = Object.create(Super.prototype);
 Sub.prototype.constructor = Sub;
 Sub.cid = cid++;
 Sub.options = mergeOptions(
                            Super.options,
                            extendOptions
                            );
 Sub['super'] = Super;
 if (Sub.options.props) {
 initProps$1(Sub);
 }
 if (Sub.options.computed) {
 initComputed$1(Sub);
 }
 Sub.extend = Super.extend;
 Sub.mixin = Super.mixin;
 Sub.use = Super.use;
 ASSET_TYPES.forEach(function (type) {
                     Sub[type] = Super[type];
                     });
 if (name) {
 Sub.options.components[name] = Sub;
 }
 Sub.superOptions = Super.options;
 Sub.extendOptions = extendOptions;
 Sub.sealedOptions = extend({}, Sub.options);
 cachedCtors[SuperId] = Sub;
 return Sub
 };
 }
 function initProps$1 (Comp) {
 var props = Comp.options.props;
 for (var key in props) {
 proxy(Comp.prototype, "_props", key);
 }
 }
 function initComputed$1 (Comp) {
 var computed = Comp.options.computed;
 for (var key in computed) {
 defineComputed(Comp.prototype, key, computed[key]);
 }
 }
 function initAssetRegisters (Vue) {
 ASSET_TYPES.forEach(function (type) {
                     Vue[type] = function (
                                           id,
                                           definition
                                           ) {
                     if (!definition) {
                     return this.options[type + 's'][id]
                     } else {
                     if (type === 'component') {
                     validateComponentName(id);
                     }
                     if (type === 'component' && isPlainObject(definition)) {
                     definition.name = definition.name || id;
                     definition = this.options._base.extend(definition);
                     }
                     if (type === 'directive' && typeof definition === 'function') {
                     definition = { bind: definition, update: definition };
                     }
                     this.options[type + 's'][id] = definition;
                     return definition
                     }
                     };
                     });
 }
 function getComponentName (opts) {
 return opts && (opts.Ctor.options.name || opts.tag)
 }
 function matches (pattern, name) {
 if (Array.isArray(pattern)) {
 return pattern.indexOf(name) > -1
 } else if (typeof pattern === 'string') {
 return pattern.split(',').indexOf(name) > -1
 } else if (isRegExp(pattern)) {
 return pattern.test(name)
 }
 return false
 }
 function pruneCache (keepAliveInstance, filter) {
 var cache = keepAliveInstance.cache;
 var keys = keepAliveInstance.keys;
 var _vnode = keepAliveInstance._vnode;
 for (var key in cache) {
 var cachedNode = cache[key];
 if (cachedNode) {
 var name = getComponentName(cachedNode.componentOptions);
 if (name && !filter(name)) {
 pruneCacheEntry(cache, key, keys, _vnode);
 }
 }
 }
 }
 function pruneCacheEntry (
                           cache,
                           key,
                           keys,
                           current
                           ) {
 var cached$$1 = cache[key];
 if (cached$$1 && (!current || cached$$1.tag !== current.tag)) {
 cached$$1.componentInstance.$destroy();
 }
 cache[key] = null;
 remove$1(keys, key);
 }
 var patternTypes = [String, RegExp, Array];
 var KeepAlive = {
 name: 'keep-alive',
 abstract: true,
 props: {
 include: patternTypes,
 exclude: patternTypes,
 max: [String, Number]
 },
 created: function created () {
 this.cache = Object.create(null);
 this.keys = [];
 },
 destroyed: function destroyed () {
 var this$1 = this;
 for (var key in this$1.cache) {
 pruneCacheEntry(this$1.cache, key, this$1.keys);
 }
 },
 mounted: function mounted () {
 var this$1 = this;
 this.$watch('include', function (val) {
             pruneCache(this$1, function (name) { return matches(val, name); });
             });
 this.$watch('exclude', function (val) {
             pruneCache(this$1, function (name) { return !matches(val, name); });
             });
 },
 render: function render () {
 var slot = this.$slots.default;
 var vnode = getFirstComponentChild(slot);
 var componentOptions = vnode && vnode.componentOptions;
 if (componentOptions) {
 var name = getComponentName(componentOptions);
 var ref = this;
 var include = ref.include;
 var exclude = ref.exclude;
 if (
     (include && (!name || !matches(include, name))) ||
     (exclude && name && matches(exclude, name))
     ) {
 return vnode
 }
 var ref$1 = this;
 var cache = ref$1.cache;
 var keys = ref$1.keys;
 var key = vnode.key == null
 ? componentOptions.Ctor.cid + (componentOptions.tag ? ("::" + (componentOptions.tag)) : '')
 : vnode.key;
 if (cache[key]) {
 vnode.componentInstance = cache[key].componentInstance;
 remove$1(keys, key);
 keys.push(key);
 } else {
 cache[key] = vnode;
 keys.push(key);
 if (this.max && keys.length > parseInt(this.max)) {
 pruneCacheEntry(cache, keys[0], keys, this._vnode);
 }
 }
 vnode.data.keepAlive = true;
 }
 return vnode || (slot && slot[0])
 }
 };
 var builtInComponents = {
 KeepAlive: KeepAlive
 };
 function initGlobalAPI (Vue) {
 var configDef = {};
 configDef.get = function () { return config; };
 {
 configDef.set = function () {
 warn(
      'Do not replace the Vue.config object, set individual fields instead.'
      );
 };
 }
 Object.defineProperty(Vue, 'config', configDef);
 Vue.util = {
 warn: warn,
 extend: extend,
 mergeOptions: mergeOptions,
 defineReactive: defineReactive
 };
 Vue.set = set;
 Vue.delete = del;
 Vue.nextTick = nextTick;
 Vue.options = Object.create(null);
 ASSET_TYPES.forEach(function (type) {
                     Vue.options[type + 's'] = Object.create(null);
                     });
 Vue.options._base = Vue;
 extend(Vue.options.components, builtInComponents);
 initUse(Vue);
 initMixin$1(Vue);
 initExtend(Vue);
 initAssetRegisters(Vue);
 }
 initGlobalAPI(Vue);
 Object.defineProperty(Vue.prototype, '$isServer', {
                       get: isServerRendering
                       });
 Object.defineProperty(Vue.prototype, '$ssrContext', {
                       get: function get () {
                       return this.$vnode && this.$vnode.ssrContext
                       }
                       });
 Object.defineProperty(Vue, 'FunctionalRenderContext', {
                       value: FunctionalRenderContext
                       });
 Vue.version = '2.5.17-beta.0';
 var namespaceMap = {};
 function createElement$1 (tagName) {
 return doc.createElement(tagName)
 }
 function createElementNS (namespace, tagName) {
 return doc.createElement(namespace + ':' + tagName)
 }
 function createTextNode (text) {
 return doc.createTextNode(text)
 }
 function createComment (text) {
 return doc.createComment(text)
 }
 function insertBefore$1 (
                          node,
                          target,
                          beforeMount
                          ) {
 node.insertBefore(target, before);
 }
 function removeChild (node, child) {
 if (child.nodeType === 3) {
 node.setText('');
 return
 }
 node.removeChild(child);
 }
 function appendChild (node, child) {
 node.appendChild(child);
 child.setInNative && child.setInNative();
 }
 function parentNode (node) {
 return node.parentNode
 }
 function nextSibling (node) {
 return node.nextSibling
 }
 function tagName (node) {
 return node.type
 }
 function setTextContent (node, text) {
 if (node.nodeType === 3) {
 node.setText(text);
 } else if (node.parentNode) {
 node.parentNode.setAttr(value, text);
 }
 }
 function setAttribute (node, key, val) {
 node.setAttr(key, val);
 }
 function setStyleScope (node, scopeId) {
 node.setAttr('@styleScope', scopeId);
 }
 var nodeOps = Object.freeze({
                             namespaceMap: namespaceMap,
                             createElement: createElement$1,
                             createElementNS: createElementNS,
                             createTextNode: createTextNode,
                             createComment: createComment,
                             insertBefore: insertBefore$1,
                             removeChild: removeChild,
                             appendChild: appendChild,
                             parentNode: parentNode,
                             nextSibling: nextSibling,
                             tagName: tagName,
                             setTextContent: setTextContent,
                             setAttribute: setAttribute,
                             setStyleScope: setStyleScope
                             });
 var ref = {
 create: function create (_, vnode) {
 registerRef(vnode);
 },
 update: function update (oldVnode, vnode) {
 if (oldVnode.data.ref !== vnode.data.ref) {
 registerRef(oldVnode, true);
 registerRef(vnode);
 }
 },
 destroy: function destroy (vnode) {
 registerRef(vnode, true);
 }
 };
 function registerRef (vnode, isRemoval) {
 var key = vnode.data.ref;
 if (!isDef$1(key)) { return }
 var vm = vnode.context;
 var ref = vnode.componentInstance || vnode.elm;
 var refs = vm.$refs;
 if (isRemoval) {
 if (Array.isArray(refs[key])) {
 remove$1(refs[key], ref);
 } else if (refs[key] === ref) {
 refs[key] = undefined;
 }
 } else {
 if (vnode.data.refInFor) {
 if (!Array.isArray(refs[key])) {
 refs[key] = [ref];
 } else if (refs[key].indexOf(ref) < 0) {
 refs[key].push(ref);
 }
 } else {
 refs[key] = ref;
 }
 }
 }
 var isHTMLTag = makeMap(
                         'html,body,base,head,link,meta,style,title,' +
                         'address,article,aside,footer,header,h1,h2,h3,h4,h5,h6,hgroup,nav,section,' +
                         'div,dd,dl,dt,figcaption,figure,picture,hr,img,li,main,ol,p,pre,ul,' +
                         'a,b,abbr,bdi,bdo,br,cite,code,data,dfn,em,i,kbd,mark,q,rp,rt,rtc,ruby,' +
                         's,samp,small,span,strong,sub,sup,time,u,var,wbr,area,audio,map,track,video,' +
                         'embed,object,param,source,canvas,script,noscript,del,ins,' +
                         'caption,col,colgroup,table,thead,tbody,td,th,tr,' +
                         'button,datalist,fieldset,form,input,label,legend,meter,optgroup,option,' +
                         'output,progress,select,textarea,' +
                         'details,dialog,menu,menuitem,summary,' +
                         'content,element,shadow,template,blockquote,iframe,tfoot'
                         );
 var isSVG = makeMap(
                     'svg,animate,circle,clippath,cursor,defs,desc,ellipse,filter,font-face,' +
                     'foreignObject,g,glyph,image,line,marker,mask,missing-glyph,path,pattern,' +
                     'polygon,polyline,rect,switch,symbol,text,textpath,tspan,use,view',
                     true
                     );
 var isTextInputType = makeMap('text,number,password,search,email,tel,url');
 var emptyNode = new VNode('', {}, []);
 var hooks = ['create', 'activate', 'update', 'remove', 'destroy'];
 function sameVnode (a, b) {
 return (
         a.key === b.key && (
                             (
                              a.tag === b.tag &&
                              a.isComment === b.isComment &&
                              isDef$1(a.data) === isDef$1(b.data) &&
                              sameInputType(a, b)
                              ) || (
                                    isTrue(a.isAsyncPlaceholder) &&
                                    a.asyncFactory === b.asyncFactory &&
                                    isUndef$1(b.asyncFactory.error)
                                    )
                             )
         )
 }
 function sameInputType (a, b) {
 if (a.tag !== 'input') { return true }
 var i;
 var typeA = isDef$1(i = a.data) && isDef$1(i = i.attrs) && i.type;
 var typeB = isDef$1(i = b.data) && isDef$1(i = i.attrs) && i.type;
 return typeA === typeB || isTextInputType(typeA) && isTextInputType(typeB)
 }
 function createKeyToOldIdx (children, beginIdx, endIdx) {
 var i, key;
 var map = {};
 for (i = beginIdx; i <= endIdx; ++i) {
 key = children[i].key;
 if (isDef$1(key)) { map[key] = i; }
 }
 return map
 }
 function createPatchFunction (backend) {
 var i, j;
 var cbs = {};
 var modules = backend.modules;
 var nodeOps = backend.nodeOps;
 for (i = 0; i < hooks.length; ++i) {
 cbs[hooks[i]] = [];
 for (j = 0; j < modules.length; ++j) {
 if (isDef$1(modules[j][hooks[i]])) {
 cbs[hooks[i]].push(modules[j][hooks[i]]);
 }
 }
 }
 function emptyNodeAt (elm) {
 return new VNode(nodeOps.tagName(elm).toLowerCase(), {}, [], undefined, elm)
 }
 function createRmCb (childElm, listeners) {
 function remove () {
 if (--remove.listeners === 0) {
 removeNode(childElm);
 }
 }
 remove.listeners = listeners;
 return remove
 }
 function removeNode (el) {
 var parent = nodeOps.parentNode(el);
 if (isDef$1(parent)) {
 nodeOps.removeChild(parent, el);
 }
 }
 function isUnknownElement$$1 (vnode, inVPre) {
 return (
         !inVPre &&
         !vnode.ns &&
         !(
           config.ignoredElements.length &&
           config.ignoredElements.some(function (ignore) {
                                       return isRegExp(ignore)
                                       ? ignore.test(vnode.tag)
                                       : ignore === vnode.tag
                                       })
           ) &&
         config.isUnknownElement(vnode.tag)
         )
 }
 var creatingElmInVPre = 0;
 function createElm (
                     vnode,
                     insertedVnodeQueue,
                     parentElm,
                     refElm,
                     nested,
                     ownerArray,
                     index
                     ) {
 if (isDef$1(vnode.elm) && isDef$1(ownerArray)) {
 vnode = ownerArray[index] = cloneVNode(vnode);
 }
 vnode.isRootInsert = !nested;
 if (createComponent(vnode, insertedVnodeQueue, parentElm, refElm)) {
 return
 }
 var data = vnode.data;
 var children = vnode.children;
 var tag = vnode.tag;
 if (isDef$1(tag)) {
 {
 if (data && data.pre) {
 creatingElmInVPre++;
 }
 if (isUnknownElement$$1(vnode, creatingElmInVPre)) {
 warn(
      'Unknown custom element: <' + tag + '> - did you ' +
      'register the component correctly? For recursive components, ' +
      'make sure to provide the "name" option.',
      vnode.context
      );
 }
 }
 vnode.elm = vnode.ns
 ? nodeOps.createElementNS(vnode.ns, tag)
 : nodeOps.createElement(tag, vnode);
 setScope(vnode);
 {
 createChildren(vnode, children, insertedVnodeQueue);
 if (isDef$1(data)) {
 invokeCreateHooks(vnode, insertedVnodeQueue);
 }
 insert(parentElm, vnode.elm, refElm);
 }
 if (data && data.pre) {
 creatingElmInVPre--;
 }
 } else if (isTrue(vnode.isComment)) {
 vnode.elm = nodeOps.createComment(vnode.text);
 insert(parentElm, vnode.elm, refElm);
 } else {
 vnode.elm = nodeOps.createTextNode(vnode.text);
 insert(parentElm, vnode.elm, refElm);
 }
 }
 function createComponent (vnode, insertedVnodeQueue, parentElm, refElm) {
 var i = vnode.data;
 if (isDef$1(i)) {
 var isReactivated = isDef$1(vnode.componentInstance) && i.keepAlive;
 if (isDef$1(i = i.hook) && isDef$1(i = i.init)) {
 i(vnode, false                );
 }
 if (isDef$1(vnode.componentInstance)) {
 initComponent(vnode, insertedVnodeQueue);
 insert(parentElm, vnode.elm, refElm);
 if (isTrue(isReactivated)) {
 reactivateComponent(vnode, insertedVnodeQueue, parentElm, refElm);
 }
 return true
 }
 }
 }
 function initComponent (vnode, insertedVnodeQueue) {
 if (isDef$1(vnode.data.pendingInsert)) {
 insertedVnodeQueue.push.apply(insertedVnodeQueue, vnode.data.pendingInsert);
 vnode.data.pendingInsert = null;
 }
 vnode.elm = vnode.componentInstance.$el;
 if (isPatchable(vnode)) {
 invokeCreateHooks(vnode, insertedVnodeQueue);
 setScope(vnode);
 } else {
 registerRef(vnode);
 insertedVnodeQueue.push(vnode);
 }
 }
 function reactivateComponent (vnode, insertedVnodeQueue, parentElm, refElm) {
 var i;
 var innerNode = vnode;
 while (innerNode.componentInstance) {
 innerNode = innerNode.componentInstance._vnode;
 if (isDef$1(i = innerNode.data) && isDef$1(i = i.transition)) {
 for (i = 0; i < cbs.activate.length; ++i) {
 cbs.activate[i](emptyNode, innerNode);
 }
 insertedVnodeQueue.push(innerNode);
 break
 }
 }
 insert(parentElm, vnode.elm, refElm);
 }
 function insert (parent, elm, ref$$1) {
 if (isDef$1(parent)) {
 if (isDef$1(ref$$1)) {
 if (ref$$1.parentNode === parent) {
 nodeOps.insertBefore(parent, elm, ref$$1);
 }
 } else {
 nodeOps.appendChild(parent, elm);
 }
 }
 }
 function createChildren (vnode, children, insertedVnodeQueue) {
 if (Array.isArray(children)) {
 {
 checkDuplicateKeys(children);
 }
 for (var i = 0; i < children.length; ++i) {
 createElm(children[i], insertedVnodeQueue, vnode.elm, null, true, children, i);
 }
 } else if (isPrimitive(vnode.text)) {
 nodeOps.appendChild(vnode.elm, nodeOps.createTextNode(String(vnode.text)));
 }
 }
 function isPatchable (vnode) {
 while (vnode.componentInstance) {
 vnode = vnode.componentInstance._vnode;
 }
 return isDef$1(vnode.tag)
 }
 function invokeCreateHooks (vnode, insertedVnodeQueue) {
 for (var i$1 = 0; i$1 < cbs.create.length; ++i$1) {
 cbs.create[i$1](emptyNode, vnode);
 }
 i = vnode.data.hook;
 if (isDef$1(i)) {
 if (isDef$1(i.create)) { i.create(emptyNode, vnode); }
 if (isDef$1(i.insert)) { insertedVnodeQueue.push(vnode); }
 }
 }
 function setScope (vnode) {
 var i;
 if (isDef$1(i = vnode.fnScopeId)) {
 nodeOps.setStyleScope(vnode.elm, i);
 } else {
 var ancestor = vnode;
 while (ancestor) {
 if (isDef$1(i = ancestor.context) && isDef$1(i = i.$options._scopeId)) {
 nodeOps.setStyleScope(vnode.elm, i);
 }
 ancestor = ancestor.parent;
 }
 }
 if (isDef$1(i = activeInstance) &&
     i !== vnode.context &&
     i !== vnode.fnContext &&
     isDef$1(i = i.$options._scopeId)
     ) {
 nodeOps.setStyleScope(vnode.elm, i);
 }
 }
 function addVnodes (parentElm, refElm, vnodes, startIdx, endIdx, insertedVnodeQueue) {
 for (; startIdx <= endIdx; ++startIdx) {
 createElm(vnodes[startIdx], insertedVnodeQueue, parentElm, refElm, false, vnodes, startIdx);
 }
 }
 function invokeDestroyHook (vnode) {
 var i, j;
 var data = vnode.data;
 if (isDef$1(data)) {
 if (isDef$1(i = data.hook) && isDef$1(i = i.destroy)) { i(vnode); }
 for (i = 0; i < cbs.destroy.length; ++i) { cbs.destroy[i](vnode); }
 }
 if (isDef$1(i = vnode.children)) {
 for (j = 0; j < vnode.children.length; ++j) {
 invokeDestroyHook(vnode.children[j]);
 }
 }
 }
 function removeVnodes (parentElm, vnodes, startIdx, endIdx) {
 for (; startIdx <= endIdx; ++startIdx) {
 var ch = vnodes[startIdx];
 if (isDef$1(ch)) {
 if (isDef$1(ch.tag)) {
 removeAndInvokeRemoveHook(ch);
 invokeDestroyHook(ch);
 } else {
 removeNode(ch.elm);
 }
 }
 }
 }
 function removeAndInvokeRemoveHook (vnode, rm) {
 if (isDef$1(rm) || isDef$1(vnode.data)) {
 var i;
 var listeners = cbs.remove.length + 1;
 if (isDef$1(rm)) {
 rm.listeners += listeners;
 } else {
 rm = createRmCb(vnode.elm, listeners);
 }
 if (isDef$1(i = vnode.componentInstance) && isDef$1(i = i._vnode) && isDef$1(i.data)) {
 removeAndInvokeRemoveHook(i, rm);
 }
 for (i = 0; i < cbs.remove.length; ++i) {
 cbs.remove[i](vnode, rm);
 }
 if (isDef$1(i = vnode.data.hook) && isDef$1(i = i.remove)) {
 i(vnode, rm);
 } else {
 rm();
 }
 } else {
 removeNode(vnode.elm);
 }
 }
 function updateChildren (parentElm, oldCh, newCh, insertedVnodeQueue, removeOnly) {
 var oldStartIdx = 0;
 var newStartIdx = 0;
 var oldEndIdx = oldCh.length - 1;
 var oldStartVnode = oldCh[0];
 var oldEndVnode = oldCh[oldEndIdx];
 var newEndIdx = newCh.length - 1;
 var newStartVnode = newCh[0];
 var newEndVnode = newCh[newEndIdx];
 var oldKeyToIdx, idxInOld, vnodeToMove, refElm;
 var canMove = !removeOnly;
 {
 checkDuplicateKeys(newCh);
 }
 while (oldStartIdx <= oldEndIdx && newStartIdx <= newEndIdx) {
 if (isUndef$1(oldStartVnode)) {
 oldStartVnode = oldCh[++oldStartIdx];
 } else if (isUndef$1(oldEndVnode)) {
 oldEndVnode = oldCh[--oldEndIdx];
 } else if (sameVnode(oldStartVnode, newStartVnode)) {
 patchVnode(oldStartVnode, newStartVnode, insertedVnodeQueue);
 oldStartVnode = oldCh[++oldStartIdx];
 newStartVnode = newCh[++newStartIdx];
 } else if (sameVnode(oldEndVnode, newEndVnode)) {
 patchVnode(oldEndVnode, newEndVnode, insertedVnodeQueue);
 oldEndVnode = oldCh[--oldEndIdx];
 newEndVnode = newCh[--newEndIdx];
 } else if (sameVnode(oldStartVnode, newEndVnode)) {
 patchVnode(oldStartVnode, newEndVnode, insertedVnodeQueue);
 canMove && nodeOps.insertBefore(parentElm, oldStartVnode.elm, nodeOps.nextSibling(oldEndVnode.elm));
 oldStartVnode = oldCh[++oldStartIdx];
 newEndVnode = newCh[--newEndIdx];
 } else if (sameVnode(oldEndVnode, newStartVnode)) {
 patchVnode(oldEndVnode, newStartVnode, insertedVnodeQueue);
 canMove && nodeOps.insertBefore(parentElm, oldEndVnode.elm, oldStartVnode.elm);
 oldEndVnode = oldCh[--oldEndIdx];
 newStartVnode = newCh[++newStartIdx];
 } else {
 if (isUndef$1(oldKeyToIdx)) { oldKeyToIdx = createKeyToOldIdx(oldCh, oldStartIdx, oldEndIdx); }
 idxInOld = isDef$1(newStartVnode.key)
 ? oldKeyToIdx[newStartVnode.key]
 : findIdxInOld(newStartVnode, oldCh, oldStartIdx/ldEndIdx);
 if (isUndef$1(idxInOld)) {
 createElm(newStartVnode, insertedVnodeQueue, parentElm, oldStartVnode.elm, false, newCh, newStartIdx);
 } else {
 vnodeToMove = oldCh[idxInOld];
 if (sameVnode(vnodeToMove, newStartVnode)) {
 patchVnode(vnodeToMove, newStartVnode, insertedVnodeQueue);
 oldCh[idxInOld] = undefined;
 canMove && nodeOps.insertBefore(parentElm, vnodeToMove.elm, oldStartVnode.elm);
 } else {
 createElm(newStartVnode, insertedVnodeQueue, parentElm, oldStartVnode.elm, false, newCh, newStartIdx);
 }
 }
 newStartVnode = newCh[++newStartIdx];
 }
 }
 if (oldStartIdx > oldEndIdx) {
 refElm = isUndef$1(newCh[newEndIdx + 1]) ? null : newCh[newEndIdx + 1].elm;
 addVnodes(parentElm, refElm, newCh, newStartIdx, newEndIdx, insertedVnodeQueue);
 } else if (newStartIdx > newEndIdx) {
 removeVnodes(parentElm, oldCh, oldStartIdx, oldEndIdx);
 }
 }
 function checkDuplicateKeys (children) {
 var seenKeys = {};
 for (var i = 0; i < children.length; i++) {
 var vnode = children[i];
 var key = vnode.key;
 if (isDef$1(key)) {
 if (seenKeys[key]) {
 warn(
      ("Duplicate keys detected: '" + key + "'. This may cause an update error."),
      vnode.context
      );
 } else {
 seenKeys[key] = true;
 }
 }
 }
 }
 function findIdxInOld (node, oldCh, start, end) {
 for (var i = start; i < end; i++) {
 var c = oldCh[i];
 if (isDef$1(c) && sameVnode(node, c)) { return i }
 }
 }
 function patchVnode (oldVnode, vnode, insertedVnodeQueue, removeOnly) {
 if (oldVnode === vnode) {
 return
 }
 console.log('start patch Node', oldVnode, vnode);
 var elm = vnode.elm = oldVnode.elm;
 if (isTrue(oldVnode.isAsyncPlaceholder)) {
 if (isDef$1(vnode.asyncFactory.resolved)) {
 hydrate(oldVnode.elm, vnode, insertedVnodeQueue);
 } else {
 vnode.isAsyncPlaceholder = true;
 }
 return
 }
 if (isTrue(vnode.isStatic) &&
     isTrue(oldVnode.isStatic) &&
     vnode.key === oldVnode.key &&
     (isTrue(vnode.isCloned) || isTrue(vnode.isOnce))
     ) {
 vnode.componentInstance = oldVnode.componentInstance;
 return
 }
 var i;
 var data = vnode.data;
 if (isDef$1(data) && isDef$1(i = data.hook) && isDef$1(i = i.prepatch)) {
 i(oldVnode, vnode);
 }
 var oldCh = oldVnode.children;
 var ch = vnode.children;
 if (isDef$1(data) && isPatchable(vnode)) {
 for (i = 0; i < cbs.update.length; ++i) { cbs.update[i](oldVnode, vnode); }
 if (isDef$1(i = data.hook) && isDef$1(i = i.update)) { i(oldVnode, vnode); }
 }
 if (isUndef$1(vnode.text)) {
 if (isDef$1(oldCh) && isDef$1(ch)) {
 if (oldCh !== ch) { updateChildren(elm, oldCh, ch, insertedVnodeQueue, removeOnly); }
 } else if (isDef$1(ch)) {
 if (isDef$1(oldVnode.text)) { nodeOps.setTextContent(elm, ''); }
 addVnodes(elm, null, ch, 0, ch.length - 1, insertedVnodeQueue);
 } else if (isDef$1(oldCh)) {
 removeVnodes(elm, oldCh, 0, oldCh.length - 1);
 } else if (isDef$1(oldVnode.text)) {
 nodeOps.setTextContent(elm, '');
 }
 } else if (oldVnode.text !== vnode.text) {
 nodeOps.setTextContent(elm, vnode.text);
 }
 if (isDef$1(data)) {
 if (isDef$1(i = data.hook) && isDef$1(i = i.postpatch)) { i(oldVnode, vnode); }
 }
 }
 function invokeInsertHook (vnode, queue, initial) {
 if (isTrue(initial) && isDef$1(vnode.parent)) {
 vnode.parent.data.pendingInsert = queue;
 } else {
 for (var i = 0; i < queue.length; ++i) {
 queue[i].data.hook.insert(queue[i]);
 }
 }
 }
 var hydrationBailed = false;
 var isRenderedModule = makeMap('attrs,class,staticClass,staticStyle,key');
 function hydrate (elm, vnode, insertedVnodeQueue, inVPre) {
 var i;
 var tag = vnode.tag;
 var data = vnode.data;
 var children = vnode.children;
 inVPre = inVPre || (data && data.pre);
 vnode.elm = elm;
 if (isTrue(vnode.isComment) && isDef$1(vnode.asyncFactory)) {
 vnode.isAsyncPlaceholder = true;
 return true
 }
 {
 if (!assertNodeMatch(elm, vnode, inVPre)) {
 return false
 }
 }
 if (isDef$1(data)) {
 if (isDef$1(i = data.hook) && isDef$1(i = i.init)) { i(vnode, true                ); }
 if (isDef$1(i = vnode.componentInstance)) {
 initComponent(vnode, insertedVnodeQueue);
 return true
 }
 }
 if (isDef$1(tag)) {
 if (isDef$1(children)) {
 if (!elm.hasChildNodes()) {
 createChildren(vnode, children, insertedVnodeQueue);
 } else {
 if (isDef$1(i = data) && isDef$1(i = i.domProps) && isDef$1(i = i.innerHTML)) {
 if (i !== elm.innerHTML) {
 if (typeof console !== 'undefined' &&
     !hydrationBailed
     ) {
 hydrationBailed = true;
 console.warn('Parent: ', elm);
 console.warn('server innerHTML: ', i);
 console.warn('client innerHTML: ', elm.innerHTML);
 }
 return false
 }
 } else {
 var childrenMatch = true;
 var childNode = elm.firstChild;
 for (var i$1 = 0; i$1 < children.length; i$1++) {
 if (!childNode || !hydrate(childNode, children[i$1], insertedVnodeQueue, inVPre)) {
 childrenMatch = false;
 break
 }
 childNode = childNode.nextSibling;
 }
 if (!childrenMatch || childNode) {
 if (typeof console !== 'undefined' &&
     !hydrationBailed
     ) {
 hydrationBailed = true;
 console.warn('Parent: ', elm);
 console.warn('Mismatching childNodes vs. VNodes: ', elm.childNodes, children);
 }
 return false
 }
 }
 }
 }
 if (isDef$1(data)) {
 var fullInvoke = false;
 for (var key in data) {
 if (!isRenderedModule(key)) {
 fullInvoke = true;
 invokeCreateHooks(vnode, insertedVnodeQueue);
 break
 }
 }
 if (!fullInvoke && data['class']) {
 traverse(data['class']);
 }
 }
 } else if (elm.data !== vnode.text) {
 elm.data = vnode.text;
 }
 return true
 }
 function assertNodeMatch (node, vnode, inVPre) {
 if (isDef$1(vnode.tag)) {
 return vnode.tag.indexOf('vue-component') === 0 || (
                                                     !isUnknownElement$$1(vnode, inVPre) &&
                                                     vnode.tag.toLowerCase() === (node.tagName && node.tagName.toLowerCase())
                                                     )
 } else {
 return node.nodeType === (vnode.isComment ? 8 : 3)
 }
 }
 return function patch (oldVnode, vnode, hydrating, removeOnly) {
 if (isUndef$1(vnode)) {
 if (isDef$1(oldVnode)) { invokeDestroyHook(oldVnode); }
 return
 }
 var isInitialPatch = false;
 var insertedVnodeQueue = [];
 if (isUndef$1(oldVnode)) {
 isInitialPatch = true;
 createElm(vnode, insertedVnodeQueue);
 } else {
 var isRealElement = isDef$1(oldVnode.nodeType);
 if (!isRealElement && sameVnode(oldVnode, vnode)) {
 patchVnode(oldVnode, vnode, insertedVnodeQueue, removeOnly);
 } else {
 if (isRealElement) {
 if (oldVnode.nodeType === 1 && oldVnode.hasAttribute(SSR_ATTR)) {
 oldVnode.removeAttribute(SSR_ATTR);
 hydrating = true;
 }
 if (isTrue(hydrating)) {
 if (hydrate(oldVnode, vnode, insertedVnodeQueue)) {
 invokeInsertHook(vnode, insertedVnodeQueue, true);
 return oldVnode
 } else {
 warn(
      'The client-side rendered virtual DOM tree is not matching ' +
      'server-rendered content. This is likely caused by incorrect ' +
      'HTML markup, for example nesting block-level elements inside ' +
      '<p>, or missing <tbody>. Bailing hydration and performing ' +
      'full client-side render.'
      );
 }
 }
 oldVnode = emptyNodeAt(oldVnode);
 }
 var oldElm = oldVnode.elm;
 var parentElm = nodeOps.parentNode(oldElm);
 createElm(
           vnode,
           insertedVnodeQueue,
           oldElm._leaveCb ? null : parentElm,
           nodeOps.nextSibling(oldElm)
           );
 if (isDef$1(vnode.parent)) {
 var ancestor = vnode.parent;
 var patchable = isPatchable(vnode);
 while (ancestor) {
 for (var i = 0; i < cbs.destroy.length; ++i) {
 cbs.destroy[i](ancestor);
 }
 ancestor.elm = vnode.elm;
 if (patchable) {
 for (var i$1 = 0; i$1 < cbs.create.length; ++i$1) {
 cbs.create[i$1](emptyNode, ancestor);
 }
 var insert = ancestor.data.hook.insert;
 if (insert.merged) {
 for (var i$2 = 1; i$2 < insert.fns.length; i$2++) {
 insert.fns[i$2]();
 }
 }
 } else {
 registerRef(ancestor);
 }
 ancestor = ancestor.parent;
 }
 }
 if (isDef$1(parentElm)) {
 removeVnodes(parentElm, [oldVnode], 0, 0);
 } else if (isDef$1(oldVnode.tag)) {
 invokeDestroyHook(oldVnode);
 }
 }
 }
 invokeInsertHook(vnode, insertedVnodeQueue, isInitialPatch);
 return vnode.elm
 }
 }
 var directives = {
 create: updateDirectives,
 update: updateDirectives,
 destroy: function unbindDirectives (vnode) {
 updateDirectives(vnode, emptyNode);
 }
 };
 function updateDirectives (oldVnode, vnode) {
 if (oldVnode.data.directives || vnode.data.directives) {
 _update(oldVnode, vnode);
 }
 }
 function _update (oldVnode, vnode) {
 var isCreate = oldVnode === emptyNode;
 var isDestroy = vnode === emptyNode;
 var oldDirs = normalizeDirectives$1(oldVnode.data.directives, oldVnode.context);
 var newDirs = normalizeDirectives$1(vnode.data.directives, vnode.context);
 var dirsWithInsert = [];
 var dirsWithPostpatch = [];
 var key, oldDir, dir;
 for (key in newDirs) {
 oldDir = oldDirs[key];
 dir = newDirs[key];
 if (!oldDir) {
 callHook$1(dir, 'bind', vnode, oldVnode);
 if (dir.def && dir.def.inserted) {
 dirsWithInsert.push(dir);
 }
 } else {
 dir.oldValue = oldDir.value;
 callHook$1(dir, 'update', vnode, oldVnode);
 if (dir.def && dir.def.componentUpdated) {
 dirsWithPostpatch.push(dir);
 }
 }
 }
 if (dirsWithInsert.length) {
 var callInsert = function () {
 for (var i = 0; i < dirsWithInsert.length; i++) {
 callHook$1(dirsWithInsert[i], 'inserted', vnode, oldVnode);
 }
 };
 if (isCreate) {
 mergeVNodeHook(vnode, 'insert', callInsert);
 } else {
 callInsert();
 }
 }
 if (dirsWithPostpatch.length) {
 mergeVNodeHook(vnode, 'postpatch', function () {
                for (var i = 0; i < dirsWithPostpatch.length; i++) {
                callHook$1(dirsWithPostpatch[i], 'componentUpdated', vnode, oldVnode);
                }
                });
 }
 if (!isCreate) {
 for (key in oldDirs) {
 if (!newDirs[key]) {
 callHook$1(oldDirs[key], 'unbind', oldVnode, oldVnode, isDestroy);
 }
 }
 }
 }
 var emptyModifiers = Object.create(null);
 function normalizeDirectives$1 (
                                 dirs,
                                 vm
                                 ) {
 var res = Object.create(null);
 if (!dirs) {
 return res
 }
 var i, dir;
 for (i = 0; i < dirs.length; i++) {
 dir = dirs[i];
 if (!dir.modifiers) {
 dir.modifiers = emptyModifiers;
 }
 res[getRawDirName(dir)] = dir;
 dir.def = resolveAsset(vm.$options, 'directives', dir.name, true);
 }
 return res
 }
 function getRawDirName (dir) {
 return dir.rawName || ((dir.name) + "." + (Object.keys(dir.modifiers || {}).join('.')))
 }
 function callHook$1 (dir, hook, vnode, oldVnode, isDestroy) {
 var fn = dir.def && dir.def[hook];
 if (fn) {
 try {
 fn(vnode.elm, dir, vnode, oldVnode, isDestroy);
 } catch (e) {
 handleError(e, vnode.context, ("directive " + (dir.name) + " " + hook + " hook"));
 }
 }
 }
 var baseModules = [
                    ref,
                    directives
                    ];
 var getOwnProp = Object.getOwnPropertyNames;
 function updateAttrs (oldVnode, vnode) {
 if (!oldVnode.data.attrs && !vnode.data.attrs) {
 return
 }
 var hasDifference = false;
 var elm = vnode.elm;
 var oldAttrs = oldVnode.data.attrs || {};
 var attrs = vnode.data.attrs || {};
 if (attrs.__ob__) {
 attrs = vnode.data.attrs = extend({}, attrs);
 }
 hasDifference =
 getOwnProp(attrs).length === getOwnProp(oldAttrs).length
 ? false
 : true;
 for (var key$1 in attrs) {
 var attr = attrs[key$1];
 if (isUndef$1(oldAttrs[key$1]) || attr !== oldAttrs[key$1]) {
 hasDifference = true;
 break
 }
 }
 if (hasDifference) {
 elm.setAttrs(attrs, true);
 }
 }
 var attrs = {
 create: updateAttrs,
 update: updateAttrs
 };
 var isReservedAttr = makeMap('style,class');
 var acceptValue = makeMap('input,textarea,option,select,progress');
 var isEnumeratedAttr = makeMap('contenteditable,draggable,spellcheck');
 var isBooleanAttr = makeMap(
                             'allowfullscreen,async,autofocus,autoplay,checked,compact,controls,declare,' +
                             'default,defaultchecked,defaultmuted,defaultselected,defer,disabled,' +
                             'enabled,formnovalidate,hidden,indeterminate,inert,ismap,itemscope,loop,multiple,' +
                             'muted,nohref,noresize,noshade,novalidate,nowrap,open,pauseonexit,readonly,' +
                             'required,reversed,scoped,seamless,selected,sortable,translate,' +
                             'truespeed,typemustmatch,visible'
                             );
 function genClassForVnode (vnode) {
 var data = vnode.data;
 var parentNode = vnode;
 var childNode = vnode;
 while (isDef$1(childNode.componentInstance)) {
 childNode = childNode.componentInstance._vnode;
 if (childNode && childNode.data) {
 data = mergeClassData(childNode.data, data);
 }
 }
 while (isDef$1(parentNode = parentNode.parent)) {
 if (parentNode && parentNode.data) {
 data = mergeClassData(data, parentNode.data);
 }
 }
 return renderClass(data.staticClass, data.class)
 }
 function mergeClassData (child, parent) {
 return {
 staticClass: concat(child.staticClass, parent.staticClass),
 class: isDef$1(child.class)
 ? [child.class, parent.class]
 : parent.class
 }
 }
 function renderClass (
                       staticClass,
                       dynamicClass
                       ) {
 if (isDef$1(staticClass) || isDef$1(dynamicClass)) {
 return concat(staticClass, stringifyClass(dynamicClass))
 }
 return ''
 }
 function concat (a, b) {
 return a ? b ? (a + ' ' + b) : a : (b || '')
 }
 function stringifyClass (value) {
 if (Array.isArray(value)) {
 return stringifyArray(value)
 }
 if (isObject$1(value)) {
 return stringifyObject(value)
 }
 if (typeof value === 'string') {
 return value
 }
 return ''
 }
 function stringifyArray (value) {
 var res = '';
 var stringified;
 for (var i = 0, l = value.length; i < l; i++) {
 if (isDef$1(stringified = stringifyClass(value[i])) && stringified !== '') {
 if (res) { res += ' '; }
 res += stringified;
 }
 }
 return res
 }
 function stringifyObject (value) {
 var res = '';
 for (var key in value) {
 if (value[key]) {
 if (res) { res += ' '; }
 res += key;
 }
 }
 return res
 }
 function updateClass (oldVnode, vnode) {
 var el = vnode.elm;
 var ctx = vnode.context;
 var data = vnode.data;
 var oldData = oldVnode.data;
 if (!data.staticClass &&
     !data.class &&
     (!oldData || (!oldData.staticClass && !oldData.class))
     ) {
 return
 }
 var cls = genClassForVnode(vnode);
 el.setAttr({'class': cls});
 }
 var klass = {
 create: updateClass,
 update: updateClass
 };
 var target$1;
 function add$1 (
                 event,
                 handler,
                 once,
                 capture,
                 passive,
                 params
                 ) {
 if (capture) {
 console.log('do not support event in bubble phase.');
 return
 }
 target$1.on(event, handler);
 }
 function remove$2 (
                    event,
                    handler,
                    capture,
                    _target
                    ) {
 (_target || target$1).off(event);
 }
 function updateDOMListeners (oldVnode, vnode) {
 if (!oldVnode.data.on && !vnode.data.on) {
 return
 }
 var on = vnode.data.on || {};
 var oldOn = oldVnode.data.on || {};
 target$1 = vnode.elm;
 updateListeners(on, oldOn, add$1, remove$2, vnode.context);
 target$1 = undefined;
 }
 var events = {
 create: updateDOMListeners,
 update: updateDOMListeners
 };
 function createStyle (oldVnode, vnode) {
 if (!vnode.data.staticStyle) {
 updateStyle(oldVnode, vnode);
 return
 }
 var elm = vnode.elm;
 elm.setStyle(vnode.data.staticStyle);
 updateStyle(oldVnode, vnode);
 }
 function updateStyle (oldVnode, vnode) {
 if (!oldVnode.data.style && !vnode.data.style) {
 return
 }
 var elm = vnode.elm;
 var oldStyle = oldVnode.data.style || {};
 var style = vnode.data.style || {};
 var needClone = style.__ob__;
 if (Array.isArray(style)) {
 style = vnode.data.style = toObject$1(style);
 }
 if (needClone) {
 style = vnode.data.style = extend({}, style);
 }
 var mergedStyle = Object.assign({}, oldStyle, style);
 elm.setStyle(mergedStyle);
 }
 function toObject$1 (arr) {
 var res = {};
 for (var i = 0; i < arr.length; i++) {
 if (arr[i]) {
 extend(res, arr[i]);
 }
 }
 return res
 }
 var style = {
 create: createStyle,
 update: updateStyle
 };
 var platformModules = [
                        attrs,
                        klass,
                        events,
                        style ];
 var modules = platformModules.concat(baseModules);
 var patch = createPatchFunction({
                                 nodeOps: nodeOps,
                                 modules: modules
                                 });
 var platformDirectives = {
 };
 function getVNodeType (vnode) {
 if (!vnode.tag) {
 return ''
 }
 return vnode.tag.replace(/vue\-component\-(\d+\-)?/, '')
 }
 function isSimpleSpan (vnode) {
 return vnode.children &&
 vnode.children.length === 1 &&
 !vnode.children[0].tag
 }
 function parseStyle (vnode) {
 if (!vnode || !vnode.data) {
 return
 }
 var ref = vnode.data;
 var staticStyle = ref.staticStyle;
 var staticClass = ref.staticClass;
 if (vnode.data.style || vnode.data.class || staticStyle || staticClass) {
 var styles = Object.assign({}, staticStyle, vnode.data.style);
 var cssMap = vnode.context.$options.style || {};
 var classList = [].concat(staticClass, vnode.data.class);
 classList.forEach(function (name) {
                   if (name && cssMap[name]) {
                   Object.assign(styles, cssMap[name]);
                   }
                   });
 return styles
 }
 }
 function convertVNodeChildren (children) {
 if (!children.length) {
 return
 }
 return children.map(function (vnode) {
                     var type = getVNodeType(vnode);
                     var props = { type: type };
                     if (!type) {
                     props.type = 'span';
                     props.attr = {
                     value: (vnode.text || '').trim()
                     };
                     } else {
                     props.style = parseStyle(vnode);
                     if (vnode.data) {
                     props.attr = vnode.data.attrs;
                     if (vnode.data.on) {
                     props.events = vnode.data.on;
                     }
                     }
                     if (type === 'span' && isSimpleSpan(vnode)) {
                     props.attr = props.attr || {};
                     props.attr.value = vnode.children[0].text.trim();
                     return props
                     }
                     }
                     if (vnode.children && vnode.children.length) {
                     props.children = convertVNodeChildren(vnode.children);
                     }
                     return props
                     })
 }
 var Richtext = {
 name: 'richtext',
 render: function render (h) {
 return h('weex:richtext', {
          on: this._events,
          attrs: {
          value: convertVNodeChildren(this.$options._renderChildren || [])
          }
          })
 }
 };
 var transitionProps = {
 name: String,
 appear: Boolean,
 css: Boolean,
 mode: String,
 type: String,
 enterClass: String,
 leaveClass: String,
 enterToClass: String,
 leaveToClass: String,
 enterActiveClass: String,
 leaveActiveClass: String,
 appearClass: String,
 appearActiveClass: String,
 appearToClass: String,
 duration: [Number, String, Object]
 };
 function getRealChild (vnode) {
 var compOptions = vnode && vnode.componentOptions;
 if (compOptions && compOptions.Ctor.options.abstract) {
 return getRealChild(getFirstComponentChild(compOptions.children))
 } else {
 return vnode
 }
 }
 function extractTransitionData (comp) {
 var data = {};
 var options = comp.$options;
 for (var key in options.propsData) {
 data[key] = comp[key];
 }
 var listeners = options._parentListeners;
 for (var key$1 in listeners) {
 data[camelize(key$1)] = listeners[key$1];
 }
 return data
 }
 function placeholder (h, rawChild) {
 if (/\d-keep-alive$/.test(rawChild.tag)) {
 return h('keep-alive', {
          props: rawChild.componentOptions.propsData
          })
 }
 }
 function hasParentTransition (vnode) {
 while ((vnode = vnode.parent)) {
 if (vnode.data.transition) {
 return true
 }
 }
 }
 function isSameChild (child, oldChild) {
 return oldChild.key === child.key && oldChild.tag === child.tag
 }
 var Transition = {
 name: 'transition',
 props: transitionProps,
 abstract: true,
 render: function render (h) {
 var this$1 = this;
 var children = this.$slots.default;
 if (!children) {
 return
 }
 children = children.filter(function (c) { return c.tag || isAsyncPlaceholder(c); });
 if (!children.length) {
 return
 }
 if (children.length > 1) {
 warn(
      '<transition> can only be used on a single element. Use ' +
      '<transition-group> for lists.',
      this.$parent
      );
 }
 var mode = this.mode;
 if (mode && mode !== 'in-out' && mode !== 'out-in'
     ) {
 warn(
      'invalid <transition> mode: ' + mode,
      this.$parent
      );
 }
 var rawChild = children[0];
 if (hasParentTransition(this.$vnode)) {
 return rawChild
 }
 var child = getRealChild(rawChild);
 if (!child) {
 return rawChild
 }
 if (this._leaving) {
 return placeholder(h, rawChild)
 }
 var id = "__transition-" + (this._uid) + "-";
 child.key = child.key == null
 ? child.isComment
 ? id + 'comment'
 : id + child.tag
 : isPrimitive(child.key)
 ? (String(child.key).indexOf(id) === 0 ? child.key : id + child.key)
 : child.key;
 var data = (child.data || (child.data = {})).transition = extractTransitionData(this);
 var oldRawChild = this._vnode;
 var oldChild = getRealChild(oldRawChild);
 if (child.data.directives && child.data.directives.some(function (d) { return d.name === 'show'; })) {
 child.data.show = true;
 }
 if (
     oldChild &&
     oldChild.data &&
     !isSameChild(child, oldChild) &&
     !isAsyncPlaceholder(oldChild) &&
     !(oldChild.componentInstance && oldChild.componentInstance._vnode.isComment)
     ) {
 var oldData = oldChild.data.transition = extend({}, data);
 if (mode === 'out-in') {
 this._leaving = true;
 mergeVNodeHook(oldData, 'afterLeave', function () {
                this$1._leaving = false;
                this$1.$forceUpdate();
                });
 return placeholder(h, rawChild)
 } else if (mode === 'in-out') {
 if (isAsyncPlaceholder(child)) {
 return oldRawChild
 }
 var delayedLeave;
 var performLeave = function () { delayedLeave(); };
 mergeVNodeHook(data, 'afterEnter', performLeave);
 mergeVNodeHook(data, 'enterCancelled', performLeave);
 mergeVNodeHook(oldData, 'delayLeave', function (leave) { delayedLeave = leave; });
 }
 }
 return rawChild
 }
 };
 var props = extend({
                    tag: String,
                    moveClass: String
                    }, transitionProps);
 delete props.mode;
 var TransitionGroup = {
 props: props,
 created: function created () {
 var dom = this.$requireWeexModule('dom');
 this.getPosition = function (el) { return new Promise(function (resolve, reject) {
                                                       dom.getComponentRect(el.ref, function (res) {
                                                                            if (!res.result) {
                                                                            reject(new Error(("failed to get rect for element: " + (el.tag))));
                                                                            } else {
                                                                            resolve(res.size);
                                                                            }
                                                                            });
                                                       }); };
 var animation = this.$requireWeexModule('animation');
 this.animate = function (el, options) { return new Promise(function (resolve) {
                                                            animation.transition(el.ref, options, resolve);
                                                            }); };
 },
 render: function render (h) {
 var tag = this.tag || this.$vnode.data.tag || 'span';
 var map = Object.create(null);
 var prevChildren = this.prevChildren = this.children;
 var rawChildren = this.$slots.default || [];
 var children = this.children = [];
 var transitionData = extractTransitionData(this);
 for (var i = 0; i < rawChildren.length; i++) {
 var c = rawChildren[i];
 if (c.tag) {
 if (c.key != null && String(c.key).indexOf('__vlist') !== 0) {
 children.push(c);
 map[c.key] = c
 ;(c.data || (c.data = {})).transition = transitionData;
 } else {
 var opts = c.componentOptions;
 var name = opts
 ? (opts.Ctor.options.name || opts.tag)
 : c.tag;
 warn(("<transition-group> children must be keyed: <" + name + ">"));
 }
 }
 }
 if (prevChildren) {
 var kept = [];
 var removed = [];
 prevChildren.forEach(function (c) {
                      c.data.transition = transitionData;
                      if (map[c.key]) {
                      kept.push(c);
                      } else {
                      removed.push(c);
                      }
                      });
 this.kept = h(tag, null, kept);
 this.removed = removed;
 }
 return h(tag, null, children)
 },
 beforeUpdate: function beforeUpdate () {
 this.__patch__(
                this._vnode,
                this.kept,
                false,
                true
                );
 this._vnode = this.kept;
 },
 updated: function updated () {
 var children = this.prevChildren;
 var moveClass = this.moveClass || ((this.name || 'v') + '-move');
 var moveData = children.length && this.getMoveData(children[0].context, moveClass);
 if (!moveData) {
 return
 }
 },
 methods: {
 getMoveData: function getMoveData (context, moveClass) {
 var stylesheet = context.$options.style || {};
 return stylesheet['@TRANSITION'] && stylesheet['@TRANSITION'][moveClass]
 }
 }
 };
 var platformComponents = {
 Richtext: Richtext,
 Transition: Transition,
 TransitionGroup: TransitionGroup
 };
 var isReservedTag$1 = makeMap(
                               'template,script,style,element,content,slot,link,meta,svg,view,' +
                               'a,div,img,image,text,span,input,switch,textarea,spinner,select,p' +
                               'slider,slider-neighbor,indicator,canvas,' +
                               'list,cell,header,loading,loading-indicator,refresh,scrollable,scroller,' +
                               'video,web,embed,tabbar,tabheader,datepicker,timepicker,marquee,countdown',
                               true
                               );
 var canBeLeftOpenTag = makeMap(
                                'web,spinner,switch,video,textarea,canvas,' +
                                'indicator,marquee,countdown',
                                true
                                );
 var isRuntimeComponent = makeMap(
                                  'richtext,transition,transition-group',
                                  true
                                  );
 var isUnaryTag = makeMap(
                          'embed,img,image,input,link,meta',
                          true
                          );
 function mustUseProp$1 (tag, type, name) {
 return false
 }
 function isUnknownElement$1 (tag) {
 return false
 }
 function query$1 (el, document) {
 var p = {
 hasAttribute: function hasAttribute() { return false },
 removeAttribute: function removeAttribute() { return false }
 };
 Object.assign(doc.body, p);
 return doc.body
 }
 Vue.config.mustUseProp = mustUseProp$1;
 Vue.config.isReservedTag = isReservedTag$1;
 Vue.config.isRuntimeComponent = isRuntimeComponent;
 Vue.config.isUnknownElement = isUnknownElement$1;
 Vue.options.directives = platformDirectives;
 Vue.options.components = platformComponents;
 Vue.prototype.__patch__ = patch;
 Vue.prototype.$mount = function (
                                  el,
                                  hydrating
                                  ) {
 return mountComponent(
                       this,
                       el && query$1(el, this.$document),
                       hydrating
                       )
 };
 
 function createInstanceCtx(id, config, data) {
 var viola = new ViolaInstance(id, config, data);
 var ctx = { viola: viola, document: viola.document, doc: viola.document, Vue: Vue };
 Object.freeze(ctx);
 return ctx
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
 registerModules: registerModules,
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
