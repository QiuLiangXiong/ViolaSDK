/******/ (function(modules) { // webpackBootstrap
/******/     // The module cache
/******/     var installedModules = {};
/******/
/******/     // The require function
/******/     function __webpack_require__(moduleId) {
/******/
/******/         // Check if module is in cache
/******/         if(installedModules[moduleId]) {
/******/             return installedModules[moduleId].exports;
/******/         }
/******/         // Create a new module (and put it into the cache)
/******/         var module = installedModules[moduleId] = {
/******/             i: moduleId,
/******/             l: false,
/******/             exports: {}
/******/         };
/******/
/******/         // Execute the module function
/******/         modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/         // Flag the module as loaded
/******/         module.l = true;
/******/
/******/         // Return the exports of the module
/******/         return module.exports;
/******/     }
/******/
/******/
/******/     // expose the modules object (__webpack_modules__)
/******/     __webpack_require__.m = modules;
/******/
/******/     // expose the module cache
/******/     __webpack_require__.c = installedModules;
/******/
/******/     // define getter function for harmony exports
/******/     __webpack_require__.d = function(exports, name, getter) {
/******/         if(!__webpack_require__.o(exports, name)) {
/******/             Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/         }
/******/     };
/******/
/******/     // define __esModule on exports
/******/     __webpack_require__.r = function(exports) {
/******/         if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/             Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/         }
/******/         Object.defineProperty(exports, '__esModule', { value: true });
/******/     };
/******/
/******/     // create a fake namespace object
/******/     // mode & 1: value is a module id, require it
/******/     // mode & 2: merge all properties of value into the ns
/******/     // mode & 4: return value when already ns object
/******/     // mode & 8|1: behave like require
/******/     __webpack_require__.t = function(value, mode) {
/******/         if(mode & 1) value = __webpack_require__(value);
/******/         if(mode & 8) return value;
/******/         if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/         var ns = Object.create(null);
/******/         __webpack_require__.r(ns);
/******/         Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/         if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/         return ns;
/******/     };
/******/
/******/     // getDefaultExport function for compatibility with non-harmony modules
/******/     __webpack_require__.n = function(module) {
/******/         var getter = module && module.__esModule ?
/******/             function getDefault() { return module['default']; } :
/******/             function getModuleExports() { return module; };
/******/         __webpack_require__.d(getter, 'a', getter);
/******/         return getter;
/******/     };
/******/
/******/     // Object.prototype.hasOwnProperty.call
/******/     __webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/     // __webpack_public_path__
/******/     __webpack_require__.p = "";
/******/
/******/
/******/     // Load entry module and return exports
/******/     return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {
       
       "use strict";
       __webpack_require__.r(__webpack_exports__);
/* harmony import */ var _hello_vue__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(1);
       // var Vue = require('vue')
       
       // var hello = require('./hello.vue')
       
       // hello()
       
       // const Vue = require('vue')
       // import Vue from 'viola-vue'
       new Vue({
                            el: '#app',
                            // template: '<hello/>',
                            components: { hello: _hello_vue__WEBPACK_IMPORTED_MODULE_0__["default"] },
                            render: (h) => h(_hello_vue__WEBPACK_IMPORTED_MODULE_0__["default"])
                            })
       // console.log(Vue)
/*
 var cls = genClassForVnode(vnode);
 var oldCls = genClassForVnode(oldVnode);
 console.log('cls:', cls)
 console.log('oldCls:', oldCls)
 var styles = $getStyle(oldCls || [], cls, vnode.context)
 console.log('style: ', styles)
 
 for (const key in styles) {
 if (styles.hasOwnProperty(key)) {
 let s = styles[key]
 if (!isNaN(parseInt(s))) s += 'px'
 el.style[key] = s
 }
 } */
       
/*
 
 function $getStyle(oldClassList, classList, ctx) {
 // style is a weex-only injected object
 // compiled from <style> tags in weex files
 const stylesheet = ctx.$options.style || {}
 const result = {}
 classList.forEach(name => {
 const style = stylesheet[name]
 extend(result, style)
 })
 oldClassList.forEach(name => {
 const style = stylesheet[name]
 for (const key in style) {
 if (!result.hasOwnProperty(key)) {
 result[key] = ''
 }
 }
 })
 return result
 }
 
 */
       
/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {
       
       "use strict";
       __webpack_require__.r(__webpack_exports__);
/* harmony import */ var _babel_loader_node_modules_vue_loader_lib_selector_type_script_index_0_hello_vue__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3);
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_template_compiler_index_id_data_v_dc790388_hasScoped_true_optionsId_0_buble_transforms_node_modules_vue_loader_lib_selector_type_template_index_0_hello_vue__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(4);
/* harmony import */ var _node_modules_vue_loader_lib_runtime_component_normalizer__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(5);
       var injectStyle = __webpack_require__(2)
/* script */
       
       
/* template */
       
/* template functional */
       var __vue_template_functional__ = false
/* styles */
       var __vue_styles__ = injectStyle
/* scopeId */
       var __vue_scopeId__ = "data-v-dc790388"
/* moduleIdentifier (server only) */
       var __vue_module_identifier__ = null
       
       var Component = Object(_node_modules_vue_loader_lib_runtime_component_normalizer__WEBPACK_IMPORTED_MODULE_2__["default"])(
                                                                                                                                 _babel_loader_node_modules_vue_loader_lib_selector_type_script_index_0_hello_vue__WEBPACK_IMPORTED_MODULE_0__["default"],
                                                                                                                                 _node_modules_vue_loader_lib_template_compiler_index_id_data_v_dc790388_hasScoped_true_optionsId_0_buble_transforms_node_modules_vue_loader_lib_selector_type_template_index_0_hello_vue__WEBPACK_IMPORTED_MODULE_1__["render"],
                                                                                                                                 _node_modules_vue_loader_lib_template_compiler_index_id_data_v_dc790388_hasScoped_true_optionsId_0_buble_transforms_node_modules_vue_loader_lib_selector_type_template_index_0_hello_vue__WEBPACK_IMPORTED_MODULE_1__["staticRenderFns"],
                                                                                                                                 __vue_template_functional__,
                                                                                                                                 __vue_styles__,
                                                                                                                                 __vue_scopeId__,
                                                                                                                                 __vue_module_identifier__
                                                                                                                                 )
       Component.options.__file = "src\\hello.vue"
       
/* harmony default export */ __webpack_exports__["default"] = (Component.exports);
       
       
/***/ }),
/* 2 */
/***/ (function(module, exports) {
       
       module.exports = {
       "textStyle": {
       "style": {
       "borderWidth": "10dp",
       "borderColor": "yellow",
       "margin": "10dp"
       },
       "scoped_id": "data-v-dc790388",
       "state": {},
       "attrs": {},
       "children": []
       },
       "viola": {
       "style": {
       "backgroundColor": "#4d45be",
       "width:hover": "300px"
       },
       "scoped_id": "data-v-dc790388",
       "state": {},
       "attrs": {
       "type": {
       "oj": {
       "backgroundColor": "red"
       }
       }
       },
       "children": []
       },
       "p": {
       "style": {
       "color": "blue"
       },
       "scoped_id": "data-v-dc790388",
       "state": {},
       "attrs": {},
       "children": []
       },
       "text": {
       "style": {
       "color": "'red'"
       },
       "scoped_id": "data-v-dc790388",
       "state": {},
       "attrs": {},
       "children": []
       }
       }
       
/***/ }),
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {
       
       "use strict";
       __webpack_require__.r(__webpack_exports__);
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       //
       
       
       // var a = viola.requireAPI('data')
       
       var list = [];
       
       for (let index = 0; index < 5; index++) {
       list.push('将 样式加载 放入了回调钩子了将 样式加载 放入了回调钩子了将 样式加载 放入');
       }
       
       // import helloText from './sub.vue'
/* harmony default export */ __webpack_exports__["default"] = ({
                                                               data() {
                                                               return {
                                                               helloText: 'ronk',
                                                               style: {
                                                               width: '500px',
                                                               height: '500px',
                                                               backgroundColor: 'red'
                                                               },
                                                               text: 'viola',
                                                               dynamic: true,
                                                               list: []
                                                               };
                                                               },
                                                               created() {
                                                                this.list = list
                                                                console.log('================= create =============');
                                                               },
                                                               mounted() {
                                                                console.log('================= mounted =============');
                                                               var that = this
                                                               setTimeout(function(){
                                                                           that.list.unshift('2222')
                                                                          },2000);
                                                               
                                                              
//                                                                                                                              this.list.push('2');
//                                                               this.list.pop();
                                                               },
                                                               methods: {
                                                                handler() {
                                                                this.text = 'Tom';
                                                               },
                                                               helloSub(msg) {
                                                                   console.log('from my son');
                                                                   console.log(msg);
                                                               }
                                                               }
                                                               });
       
/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {
       
       "use strict";
       __webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
       var render = function() {
       var _vm = this
       var _h = _vm.$createElement
       var _c = _vm._self._c || _h
       return _c(
                 "scroller",
                 {
                 style: {
                 backgroundColor: "grey"
                 }
                 },
                 _vm._l(_vm.list, function(key) {
                        return _c("text", { key: key, staticClass: "textStyle" }, [
                                                                                   _vm._v("   " + _vm._s(key) + "   ")
                                                                                   ])
                        })
                 )
       }
       var staticRenderFns = []
       render._withStripped = true
       
       if (false) {}
       
/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {
       
       "use strict";
       __webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return normalizeComponent; });
/* globals __VUE_SSR_CONTEXT__ */
       
       // IMPORTANT: Do NOT use ES2015 features in this file (except for modules).
       // This module is a runtime utility for cleaner component module output and will
       // be included in the final webpack user bundle.
       
       function normalizeComponent (
                                    scriptExports,
                                    render,
                                    staticRenderFns,
                                    functionalTemplate,
                                    injectStyles,
                                    scopeId,
                                    moduleIdentifier, /* server only */
                                    shadowMode /* vue-cli only */
                                    ) {
       scriptExports = scriptExports || {}
       
       // ES6 modules interop
       var type = typeof scriptExports.default
       if (type === 'object' || type === 'function') {
       scriptExports = scriptExports.default
       }
       
       // Vue.extend constructor export interop
       var options = typeof scriptExports === 'function'
       ? scriptExports.options
       : scriptExports
       
       // render functions
       if (render) {
       options.render = render
       options.staticRenderFns = staticRenderFns
       options._compiled = true
       }
       
       // functional template
       if (functionalTemplate) {
       options.functional = true
       }
       
       // scopedId
       if (scopeId) {
       options._scopeId = scopeId
       }
       
       // a style object
       options._stylesheet = injectStyles
       
       /* 样式加载函数 */
       // var hook
       // if (moduleIdentifier) { // server build
       //   hook = function (context) {
       //     // 2.3 injection
       //     context =
       //       context || // cached call
       //       (this.$vnode && this.$vnode.ssrContext) || // stateful
       //       (this.parent && this.parent.$vnode && this.parent.$vnode.ssrContext) // functional
       //     // 2.2 with runInNewContext: true
       //     if (!context && typeof __VUE_SSR_CONTEXT__ !== 'undefined') {
       //       context = __VUE_SSR_CONTEXT__
       //     }
       //     // inject component styles
       //     if (injectStyles) {
       //       injectStyles.call(this, context)
       //     }
       //     // register component module identifier for async chunk inferrence
       //     if (context && context._registeredComponents) {
       //       context._registeredComponents.add(moduleIdentifier)
       //     }
       //   }
       //   // used by ssr in case component is cached and beforeCreate
       //   // never gets called
       //   options._ssrRegister = hook
       // } else if (injectStyles) {
       //   hook = shadowMode
       //     ? function () { injectStyles.call(this, this.$root.$options.shadowRoot) }
       //     : injectStyles
       // }
       
       /* 将 样式加载 放入了回调钩子了 */
       // if (hook) {
       //   console.log('options： ', options)
       //   if (options.functional) {
       //     // for template-only hot-reload because in that case the render fn doesn't
       //     // go through the normalizer
       //     options._injectStyles = hook
       //     // register for functioal component in vue file
       //     var originalRender = options.render
       //     // options.render = function renderWithStyleInjection (h, context) {
       //     //   hook.call(context)
       //     //   return originalRender(h, context)
       //     // }
       //   } else {
       //     // inject component registration as beforeCreate hook
       //     var existing = options.beforeCreate
       //     options.beforeCreate = existing
       //       ? [].concat(existing, hook)
       //       : [hook]
       //   }
       // }
       
       return {
       exports: scriptExports,
       options: options
       }
       }
       
       
/***/ })
/******/ ]);
//# sourceMappingURL=bundle.js.map
