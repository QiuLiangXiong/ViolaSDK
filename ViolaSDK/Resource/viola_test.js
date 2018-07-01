//
//new Vue({
//        el: 'test',
//        data: {
//            attr: {
//                id: 'viola-id',
//                more: 'about'
//            },
//            text: '我们都是好孩子',
//            style: {
//                backgroundColor: 'red',
//                flex: 1
//            }
//        },
//        methods: {
//        handlerClick: function (e) {
//            console.log(e)
//            this.text = 'hhhhhhhhh'
//        }
//        },
//        render: function (h) {
//            return h('div', {
//                     style: this.style,
//                     attrs: this.attr,
//                     on: {
//                     click: this.handlerClick
//                     }
//             }, [this.text])
//        }
//})
//
//
//
//return;


var container = document.createElement('div', {
                                       attr: { id: 'container' }
                                       })

var textContainer = document.createElement('div', {
     style: {
           flexDirection: 'row',
//           flexWrap: 'wrap',
           borderColor:'rgba(255,255,255,0.3)',
           backgroundColor:'green',
           margin:'20dp',
           borderWidth:'10dp',
           padding:'15dp',
           animated: true,
    }
})

var div = document.createElement('text', {
                                 events:['click'],
                                 attr: {
                                 id: 'div1',
                                 value:'们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子',
                                 },
                                 style: {
//                                    flexDirection: 'row',
//                                 flexWrap: 'wrap',
//                                 borderColor:'r',
                                     backgroundColor:'red',

//                                 maxWidth:'200dp',
                                 borderWidth:'10dp',

                                 
//                                 borderRadius:'1000dp',
//                                 padding:'40dp',
                                 animated: true,
                                 lines:0,
                                 lineHeight:'40dp',
                               //  lineSpacing:'10dp',
//                                 headIndent:'20dp',


//                                 lineHeight:'30dp',
//                                 lineSpacing:'-20dp',
                                    }
                                 })

// window.div = div.ref
var div2 = document.createElement('div', {
                                  
                                 attr: {
                                 id: 'div1',
                                 value:'我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子',
                                 },
                                 style: {
                                 //                                    flexDirection: 'row',
                                 //                                 flexWrap: 'wrap',
                                 borderColor:'rgba(255,255,255,0.3)',
                                 backgroundColor:'red',

                                  marginLeft:'5dp',
                                  marginRight:'20dp',
                                 borderWidth:'30dp',
                                 //                                 borderRadius:'1000dp',
                                 //                                 padding:'40dp',
                                 animated: true,
                                 }
                                 })

var index = 0;
div.on('click', function (e) {
       console.log(e);


       var value = [
                    '我们都是好',
                    '长一点长一长一点长长一点长长一点长长一点长',
                    '短一点',
                    '不短了不短了不短了长一点长长一点长长一点长不短了长一点不短了长一点不短了长一点不短了长一点',
                    ]
//        this.setAttr('value', value[parseInt(++index%3)])
       var values = [ {text:value[parseInt(++index%4)],color:'blue'},{highlightBackgroundColor:'rgba(0,0,0,0.4)',highlightBackgroundInset:'{3dp,0dp,3dp,0dp}',highlightBackgroundRadius:'4dp', text:value[parseInt(++index%4)], color:'yellow',fontSize:'20dp',textDecoration:'underline',fontWeight:'bold',letterSpacing:'5dp',},{highlightBackgroundColor:'rgba(255,255,255,0.4)',highlightBackgroundInset:'{3dp,0dp,3dp,0dp}',highlightBackgroundRadius:'4dp',text:value[parseInt(++index%4)],color:'black', textDecoration:'line-through'}];
       
       this.setAttr('values', values)
       this.setStyle({

                     color:'white',
//                     fontWeight:'bold',
//                     maxWidth:'400dp',
//                     textDecoration:'line-through',

                     
                     
       })
})

textContainer.appendChild(div)
//textContainer.appendChild(div2)

container.appendChild(textContainer)

//container.appendChild(div)

var div2 = document.createElement('div')

div2.setAttr('id', 'div2')

div2.setStyle({
              width: '200dp',
              height: '200dp',
              backgroundColor:'yellow',
              margin:'20dp',
              animated: true
              })

// window.div2 = div2.ref

var color = ['#d55353', '#2795ee', '#00bdb8']
var width = [100, 150, 175]
var height = [206, 110, 75]
var radius = [50, 10, 32, 100]

function getStyle () {
    var c = color.shift()
    color.push(c)
    var w = width.shift()
    width.push(w)
    var h = height.shift()
    height.push(h)
    var r = radius.shift()
    radius.push(r)
    return {
    backgroundColor: c,
    width: w,
    height: h,
    borderTopLeftRadius: radius[0],
    borderTopRightRadius: radius[1],
    borderBottomLeftRadius: radius[2],
    borderBottomRightRadius: radius[3],


    }
}
// updateElement
div2.on('click', function () {
        this.setStyle(getStyle())
        })

container.appendChild(div2)

// move
var div3 = document.createElement('div', {
                                  style: {
                                  flexDirection: 'row',
                                  width: 600,
                                  height: 100,
                                  backgroundColor:'blue',
                                  margin:'20dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                  var f = this.children[0]
                                  var l = this.children[this.children.length - 1]
                                  this.insertBefore(l, f)
                                  }
                                  }
                                  })

div3.setAttr('id', 'div3')

// window.div3 = div3.ref

for(var i = 0; i < 3; i++) {
    div3.appendChild(document.createElement('div', {
                                            style: {
                                            width: 150,
                                            height: 60,
                                            margin: '10dp',
                                            backgroundColor: color[i],
                                            animated: true
                                            }
                                            }))
}

container.appendChild(div3)

var btnGroup = document.createElement('div', {
                                      style: {
                                      backgroundColor: 'black',
                                      flexDirection: 'row',
                                      justifyContent: 'space-between'
                                      }
                                      })

var div4 = document.createElement('div', {
                                  style: {
                                  width: 100,
                                  height: 100,
                                  backgroundColor:'white',
                                  margin:'10dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                  div.appendChild(document.createElement('div', {
                                                                         style: Object.assign({
                                                                                              width: 30,
                                                                                              height: 30,
                                                                                              margin: '10dp',
                                                                                              animated: true
                                                                    }, getStyle())
                                         }))
                                  }
                                  }
                                  })

div4.setAttr('id', 'div4')
// window.div4 = div4.ref

btnGroup.appendChild(div4)

var div5 = document.createElement('div', {
                                  style: {
                                  width: 100,
                                  height: 100,
                                  backgroundColor:'green',
                                  margin:'10dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                    if (div.children.length === 0) return
                                    div.removeChild(div.children[div.children.length - 1])
                                  }
                                  }
                                  })

div5.setAttr('id', 'div5')
// window.div4 = div4.ref

btnGroup.appendChild(div5)

container.appendChild(btnGroup)

document.body.setStyle({
                       backgroundColor: 'grey'
})

document.body.type = 'div'

document.body.appendChild(container)
document.render()




//
//var div = document.createElement('div', {
//                                 attr: {
//                                 id: 'div1'
//                                 },
//                                 style: {
//                                 backgroundColor:'white',
//                                 }
//                                 })
//
//div.on('click', function (e) {
//       console.log({title: 'here is div', event: e})
//       })
//
//var child = document.createElement('div')
//
//child.setStyle({
//               backgroundColor:'red',
//               margin:'20dp',
// borderTopLeftRadius:25,
//                                                       borderBottomRightRadius:25,
//                                                       borderBottomLeftRadius:25,
//                                                        borderTopRightRadius:25,
//               borderWidth:'5px',
//               borderColor:'blue',
//               borderStyle:'dashed',
//               })
//
//child.appendChild(document.createElement('div', {
//                                         style: {
////                                         backgroundColor:'#07D0B0',
//                                         height:'13dp',
//                                         width:'25dp',
//                                         margin:'20dp',
//                                         borderRadius:'4dp',
//                                         borderWidth:'0.5',
//                                         borderColor:'blue',
////                                         borderTopLeftRadius:2000,
////                                        borderBottomRightRadius:2000,
////                                        borderBottomLeftRadius:1000,
////                                         borderTopRightRadius:1000,
//                                         },
//                                         events: {
//                                         click: function (e) {
//                                            console.log({title: 'here is blue', event: e})
//                                            e.stopPropagation()
//                                         }
//                                         }
//                                         }))
//
//div.appendChild(child)
//
//document.body.appendChild(div)
//document.render()
////
////
////var ele =  {ref:1,type:'div',style:{backgroundColor:'brown'},
////           children:[
////                  {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'19',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'20',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                   },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////
////
////              ]
////            }
////callNative(1,[{module:'dom',method:'createBody',args:[ele]}])
////
////
////
////setTimeout(function(){
//////           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px'}}]}]);
////          // callNative(1,[{module:'dom',method:'removeComponent',args:['20',true] } ]);
////           var ele = {animated:true, ref:'21',type:'div',event:['click','doubleClick','longPress'],style:{backgroundColor:'black',margin:'20dp',height:'300px'}};
////                      callNative(1,[{module:'dom',method:'addComponent',args:['19',ele,-1,true] } ]);
//////           'swipeLeft','swipeRight','swipeTop','swipeBottom','click','doubleClick','longPress'
//////           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px',backgroundColor:'black'},event:['click','pan']}]}] );
////
////           },500);
////
////
////function createInstance(instanceId,data){
////
////}
////
////
////function callJS(id,tasks){
////    nativeLog(JSON.stringify(tasks));
////}
////

